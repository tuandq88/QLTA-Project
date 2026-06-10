param(
    [string]$DatabaseName = "qlta_empty_test",
    [switch]$ResetDatabase,
    [switch]$SeedOnly
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $Global:PSNativeCommandUseErrorActionPreference = $false
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ResultFile = Join-Path $ScriptDir "DATABASE_SEED_CHECK_RESULT.md"

function Import-DotEnvLocal {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }
    Get-Content -LiteralPath $Path | ForEach-Object {
        $line = $_.Trim()
        if (-not $line -or $line.StartsWith("#") -or $line -notmatch '^([^=]+)=(.*)$') {
            return
        }
        $name = $matches[1].Trim()
        $value = $matches[2].Trim()
        if (($value.StartsWith('"') -and $value.EndsWith('"')) -or ($value.StartsWith("'") -and $value.EndsWith("'"))) {
            $value = $value.Substring(1, $value.Length - 2)
        }
        if (-not [Environment]::GetEnvironmentVariable($name, "Process")) {
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }
}

Import-DotEnvLocal -Path (Join-Path $RepoRoot ".env.local")

$PgHost = if ($env:PGHOST) { $env:PGHOST } else { "localhost" }
$PgPort = if ($env:PGPORT) { $env:PGPORT } else { "5432" }
$PgUser = if ($env:PGUSER) { $env:PGUSER } else { "postgres" }
$MaintenanceDatabase = "postgres"

$Lines = New-Object System.Collections.Generic.List[string]
$RanFiles = New-Object System.Collections.Generic.List[string]
$Messages = New-Object System.Collections.Generic.List[string]
$StepStatus = [ordered]@{
    "Kiem tra moi truong" = "PENDING"
    "Reset database neu duoc yeu cau" = "PENDING"
    "Chay schema khi reset" = "PENDING"
    "Chay seed lan 1" = "PENDING"
    "Chay seed lan 2" = "PENDING"
    "Chay seed test" = "PENDING"
}

function Add-Line([string]$Text = "") { $Lines.Add($Text) | Out-Null }
function Get-RelativePath([string]$Path) {
    $full = (Resolve-Path -LiteralPath $Path).Path
    return $full.Substring($RepoRoot.Length + 1).Replace("\", "/")
}
function Quote-Identifier([string]$Value) { return '"' + $Value.Replace('"', '""') + '"' }

function Write-Result([string]$FinalStatus, [string]$ErrorMessage = "", [string]$FailedFile = "") {
    $Lines.Clear()
    Add-Line "# Ket qua kiem tra seed database"
    Add-Line ""
    Add-Line "- Thoi diem kiem tra: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')"
    Add-Line "- Database: $DatabaseName"
    Add-Line "- ResetDatabase: $($ResetDatabase.IsPresent)"
    Add-Line "- SeedOnly: $($SeedOnly.IsPresent)"
    Add-Line "- PGHOST: $PgHost"
    Add-Line "- PGPORT: $PgPort"
    Add-Line "- PGUSER: $PgUser"
    Add-Line "- Ket qua cuoi: $FinalStatus"
    Add-Line ""
    Add-Line "## Trang thai tung buoc"
    foreach ($key in $StepStatus.Keys) { Add-Line "- ${key}: $($StepStatus[$key])" }
    Add-Line ""
    Add-Line "## File da chay"
    if ($RanFiles.Count -eq 0) { Add-Line "- Khong co" } else { foreach ($file in $RanFiles) { Add-Line "- $file" } }
    Add-Line ""
    Add-Line "## Log PostgreSQL"
    if ($Messages.Count -eq 0) {
        Add-Line "- Khong co"
    } else {
        Add-Line '```text'
        foreach ($message in $Messages) { Add-Line $message }
        Add-Line '```'
    }
    if ($ErrorMessage) {
        Add-Line ""
        Add-Line "## Loi"
        if ($FailedFile) { Add-Line "- File loi: $FailedFile" }
        Add-Line '```text'
        Add-Line $ErrorMessage
        Add-Line '```'
        Add-Line ""
        Add-Line "## Goi y xu ly"
        Add-Line "- Neu loi la bang khong ton tai, kiem tra database da chay unified schema chua."
        Add-Line "- Neu loi duplicate key khi chay lan 2, seed chua idempotent."
        Add-Line "- Neu loi FK, kiem tra thu tu seed va du lieu cha."
    }
    Set-Content -LiteralPath $ResultFile -Encoding UTF8 -Value ($Lines -join [Environment]::NewLine)
}

function Invoke-Psql([string[]]$Arguments, [string]$Label) {
    Push-Location $RepoRoot
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & psql @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
        Pop-Location
    }
    if ($output) {
        $Messages.Add("[$Label]") | Out-Null
        foreach ($line in @($output)) { $Messages.Add($line.ToString()) | Out-Null }
    }
    return [pscustomobject]@{ ExitCode = $exitCode; Output = @($output | ForEach-Object { $_.ToString() }) }
}

function Invoke-PsqlCommand([string]$Database, [string]$Sql, [string]$StepName) {
    $result = Invoke-Psql -Arguments @("-h", $PgHost, "-p", $PgPort, "-U", $PgUser, "-d", $Database, "-v", "ON_ERROR_STOP=1", "-c", $Sql) -Label "$StepName / $Database"
    if ($result.ExitCode -ne 0) {
        $StepStatus[$StepName] = "FAILED"
        Write-Result -FinalStatus "FAILED" -ErrorMessage ($result.Output -join [Environment]::NewLine)
        exit 1
    }
}

function Invoke-PsqlFile([string]$Database, [string]$FilePath, [string]$StepName) {
    $relative = Get-RelativePath $FilePath
    Write-Host "Dang chay $relative"
    $result = Invoke-Psql -Arguments @("-h", $PgHost, "-p", $PgPort, "-U", $PgUser, "-d", $Database, "-v", "ON_ERROR_STOP=1", "-f", $FilePath) -Label "$StepName / $relative"
    if ($result.ExitCode -ne 0) {
        $StepStatus[$StepName] = "FAILED"
        Write-Result -FinalStatus "FAILED" -ErrorMessage ($result.Output -join [Environment]::NewLine) -FailedFile $relative
        exit 1
    }
    $RanFiles.Add($relative) | Out-Null
}

if ($DatabaseName -notmatch '^[A-Za-z_][A-Za-z0-9_]*$') {
    $StepStatus["Kiem tra moi truong"] = "FAILED"
    Write-Result -FinalStatus "FAILED" -ErrorMessage "Ten database khong an toan."
    exit 1
}
if (@("postgres", "template0", "template1") -contains $DatabaseName.ToLowerInvariant()) {
    $StepStatus["Kiem tra moi truong"] = "FAILED"
    Write-Result -FinalStatus "FAILED" -ErrorMessage "Tu choi thao tac tren database he thong: $DatabaseName"
    exit 1
}
if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
    foreach ($key in $StepStatus.Keys) { $StepStatus[$key] = "NOT_RUN" }
    Write-Result -FinalStatus "NOT_RUN_ENVIRONMENT_LIMITATION" -ErrorMessage "Khong tim thay psql trong PATH."
    exit 2
}
if (-not $env:PGPASSWORD) {
    foreach ($key in $StepStatus.Keys) { $StepStatus[$key] = "NOT_RUN" }
    Write-Result -FinalStatus "NOT_RUN_ENVIRONMENT_LIMITATION" -ErrorMessage "Chua co bien moi truong PGPASSWORD."
    exit 2
}
$StepStatus["Kiem tra moi truong"] = "PASSED"

if ($ResetDatabase) {
    $dbIdentifier = Quote-Identifier $DatabaseName
    $dropResult = Invoke-Psql -Arguments @("-h", $PgHost, "-p", $PgPort, "-U", $PgUser, "-d", $MaintenanceDatabase, "-v", "ON_ERROR_STOP=1", "-c", "DROP DATABASE IF EXISTS $dbIdentifier WITH (FORCE);") -Label "Reset database / drop force"
    if ($dropResult.ExitCode -ne 0) {
        Invoke-PsqlCommand -Database $MaintenanceDatabase -StepName "Reset database neu duoc yeu cau" -Sql "DROP DATABASE IF EXISTS $dbIdentifier;"
    }
    Invoke-PsqlCommand -Database $MaintenanceDatabase -StepName "Reset database neu duoc yeu cau" -Sql "CREATE DATABASE $dbIdentifier;"
    $StepStatus["Reset database neu duoc yeu cau"] = "PASSED"
    Invoke-PsqlFile -Database $DatabaseName -FilePath (Join-Path $RepoRoot "database\schema\unified_postgresql_schema.sql") -StepName "Chay schema khi reset"
    $StepStatus["Chay schema khi reset"] = "PASSED"
} else {
    $StepStatus["Reset database neu duoc yeu cau"] = "SKIPPED"
    $StepStatus["Chay schema khi reset"] = "SKIPPED"
}

function Invoke-AllSeeds([string]$StepName) {
    $seedFiles = Get-ChildItem -LiteralPath (Join-Path $RepoRoot "database\seed") -Filter "*.sql" | Where-Object { $_.Name -ne "999_seed_all.sql" } | Sort-Object Name
    foreach ($seed in $seedFiles) {
        Invoke-PsqlFile -Database $DatabaseName -FilePath $seed.FullName -StepName $StepName
    }
}

Invoke-AllSeeds -StepName "Chay seed lan 1"
$StepStatus["Chay seed lan 1"] = "PASSED"
Invoke-AllSeeds -StepName "Chay seed lan 2"
$StepStatus["Chay seed lan 2"] = "PASSED"

if ($SeedOnly) {
    $StepStatus["Chay seed test"] = "SKIPPED"
} else {
    $seedTestFiles = @(
        "seed_data_integrity_test.sql",
        "excel_seed_integrity_test.sql",
        "excel_seed_duplicate_prevention_test.sql",
        "case_file_excel_seed_integrity_test.sql"
    )
    foreach ($testFile in $seedTestFiles) {
        Invoke-PsqlFile -Database $DatabaseName -FilePath (Join-Path $ScriptDir $testFile) -StepName "Chay seed test"
    }
    $StepStatus["Chay seed test"] = "PASSED"
}

Write-Result -FinalStatus "PASSED"
Write-Host "Hoan thanh kiem tra seed. Ket qua: $ResultFile"
