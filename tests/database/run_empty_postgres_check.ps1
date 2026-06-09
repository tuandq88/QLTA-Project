param(
    [string]$DatabaseName = "qlta_empty_test",
    [ValidateSet("UnifiedOnly", "MigrationsOnly")]
    [string]$Mode = "UnifiedOnly",
    [switch]$SkipSeed,
    [switch]$SkipTests
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $Global:PSNativeCommandUseErrorActionPreference = $false
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ResultFile = Join-Path $ScriptDir "EMPTY_POSTGRES_CHECK_RESULT.md"

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
$SkippedFiles = New-Object System.Collections.Generic.List[string]
$Messages = New-Object System.Collections.Generic.List[string]
$StepStatus = [ordered]@{
    "Kiem tra moi truong" = "PENDING"
    "Tao lai database test" = "PENDING"
    "Chay unified schema" = "PENDING"
    "Chay migrations" = "PENDING"
    "Chay seed" = "PENDING"
    "Chay SQL test" = "PENDING"
}

function Add-Line([string]$Text = "") {
    $Lines.Add($Text) | Out-Null
}

function Get-RelativePath([string]$Path) {
    $full = (Resolve-Path -LiteralPath $Path).Path
    return $full.Substring($RepoRoot.Length + 1).Replace("\", "/")
}

function Quote-Identifier([string]$Value) {
    return '"' + $Value.Replace('"', '""') + '"'
}

function Write-Result([string]$FinalStatus, [string]$ErrorMessage = "", [string]$FailedFile = "") {
    $Lines.Clear()
    Add-Line "# Kết quả kiểm tra PostgreSQL trống"
    Add-Line ""
    Add-Line "- Thời điểm kiểm tra: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')"
    Add-Line "- Database test: $DatabaseName"
    Add-Line "- Chế độ: $Mode"
    Add-Line "- PGHOST: $PgHost"
    Add-Line "- PGPORT: $PgPort"
    Add-Line "- PGUSER: $PgUser"
    Add-Line "- SkipSeed: $($SkipSeed.IsPresent)"
    Add-Line "- SkipTests: $($SkipTests.IsPresent)"
    Add-Line "- Kết quả cuối: $FinalStatus"
    Add-Line ""
    Add-Line "## Trạng thái từng bước"
    foreach ($key in $StepStatus.Keys) {
        Add-Line "- ${key}: $($StepStatus[$key])"
    }
    Add-Line ""
    Add-Line "## File đã chạy"
    if ($RanFiles.Count -eq 0) { Add-Line "- Không có" } else { foreach ($file in $RanFiles) { Add-Line "- $file" } }
    Add-Line ""
    Add-Line "## File đã bỏ qua"
    if ($SkippedFiles.Count -eq 0) { Add-Line "- Không có" } else { foreach ($file in $SkippedFiles) { Add-Line "- $file" } }
    Add-Line ""
    Add-Line "## Ghi chú chạy psql"
    Add-Line "- Câu lệnh SQL chạy bằng `-c`."
    Add-Line "- File SQL chạy bằng `-f`."
    Add-Line "- Script không dùng tham số `-i`."
    Add-Line "- NOTICE/WARNING của PostgreSQL chỉ được ghi log; chỉ exit code khác 0 mới làm fail."
    Add-Line ""
    Add-Line "## Log PostgreSQL"
    if ($Messages.Count -eq 0) {
        Add-Line "- Không có"
    } else {
        Add-Line '```text'
        foreach ($message in $Messages) { Add-Line $message }
        Add-Line '```'
    }
    if ($ErrorMessage) {
        Add-Line ""
        Add-Line "## Lỗi"
        if ($FailedFile) { Add-Line "- File lỗi: $FailedFile" }
        Add-Line '```text'
        Add-Line $ErrorMessage
        Add-Line '```'
        Add-Line ""
        Add-Line "## Gợi ý xử lý"
        Add-Line "- Đọc lỗi PostgreSQL đầu tiên trong log vì script bật `ON_ERROR_STOP=1`."
        Add-Line "- Nếu lỗi đăng nhập, kiểm tra `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`."
        Add-Line '- Đặt mật khẩu trong PowerShell bằng `$env:PGPASSWORD = "<mat_khau>"`.'
        Add-Line "- Chỉ chạy một trong hai chế độ `UnifiedOnly` hoặc `MigrationsOnly`, không chạy cả hai lên cùng database."
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
    $args = @("-h", $PgHost, "-p", $PgPort, "-U", $PgUser, "-d", $Database, "-v", "ON_ERROR_STOP=1", "-c", $Sql)
    $result = Invoke-Psql -Arguments $args -Label "$StepName / $Database"
    if ($result.ExitCode -ne 0) {
        $StepStatus[$StepName] = "FAILED"
        Write-Result -FinalStatus "FAILED" -ErrorMessage ($result.Output -join [Environment]::NewLine)
        exit 1
    }
}

function Invoke-PsqlFile([string]$Database, [string]$FilePath, [string]$StepName) {
    $relative = Get-RelativePath $FilePath
    Write-Host "Đang chạy $relative"
    $args = @("-h", $PgHost, "-p", $PgPort, "-U", $PgUser, "-d", $Database, "-v", "ON_ERROR_STOP=1", "-f", $FilePath)
    $result = Invoke-Psql -Arguments $args -Label "$StepName / $relative"
    if ($result.ExitCode -ne 0) {
        $StepStatus[$StepName] = "FAILED"
        Write-Result -FinalStatus "FAILED" -ErrorMessage ($result.Output -join [Environment]::NewLine) -FailedFile $relative
        exit 1
    }
    $RanFiles.Add($relative) | Out-Null
}

if ($DatabaseName -notmatch '^[A-Za-z_][A-Za-z0-9_]*$') {
    $StepStatus["Kiem tra moi truong"] = "FAILED"
    Write-Result -FinalStatus "FAILED" -ErrorMessage "Tên database không an toàn. Chỉ dùng chữ, số, dấu gạch dưới và bắt đầu bằng chữ hoặc gạch dưới."
    exit 1
}

if (@("postgres", "template0", "template1") -contains $DatabaseName.ToLowerInvariant()) {
    $StepStatus["Kiem tra moi truong"] = "FAILED"
    Write-Result -FinalStatus "FAILED" -ErrorMessage "Từ chối drop database hệ thống: $DatabaseName"
    exit 1
}

if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
    foreach ($key in $StepStatus.Keys) { $StepStatus[$key] = "NOT_RUN" }
    Write-Result -FinalStatus "NOT_RUN_ENVIRONMENT_LIMITATION" -ErrorMessage "Không tìm thấy psql trong PATH."
    exit 2
}

if (-not $env:PGPASSWORD) {
    foreach ($key in $StepStatus.Keys) { $StepStatus[$key] = "NOT_RUN" }
    Write-Result -FinalStatus "NOT_RUN_ENVIRONMENT_LIMITATION" -ErrorMessage "Chưa có biến môi trường PGPASSWORD. Script không hard-code mật khẩu."
    exit 2
}

$StepStatus["Kiem tra moi truong"] = "PASSED"
$dbIdentifier = Quote-Identifier $DatabaseName

Invoke-PsqlCommand -Database $MaintenanceDatabase -StepName "Tao lai database test" -Sql "SELECT 1;"
$dropResult = Invoke-Psql -Arguments @("-h", $PgHost, "-p", $PgPort, "-U", $PgUser, "-d", $MaintenanceDatabase, "-v", "ON_ERROR_STOP=1", "-c", "DROP DATABASE IF EXISTS $dbIdentifier WITH (FORCE);") -Label "Tao lai database test / drop force"
if ($dropResult.ExitCode -ne 0) {
    $Messages.Add("[Fallback] PostgreSQL không hỗ trợ DROP DATABASE WITH (FORCE) hoặc đang lỗi; thử DROP DATABASE IF EXISTS thông thường.") | Out-Null
    Invoke-PsqlCommand -Database $MaintenanceDatabase -StepName "Tao lai database test" -Sql "DROP DATABASE IF EXISTS $dbIdentifier;"
}
Invoke-PsqlCommand -Database $MaintenanceDatabase -StepName "Tao lai database test" -Sql "CREATE DATABASE $dbIdentifier;"
$StepStatus["Tao lai database test"] = "PASSED"

$schemaFile = Join-Path $RepoRoot "database\schema\unified_postgresql_schema.sql"
if ($Mode -eq "UnifiedOnly") {
    Invoke-PsqlFile -Database $DatabaseName -FilePath $schemaFile -StepName "Chay unified schema"
    $StepStatus["Chay unified schema"] = "PASSED"
    $StepStatus["Chay migrations"] = "SKIPPED"
} else {
    $SkippedFiles.Add("$(Get-RelativePath $schemaFile) - bỏ qua vì đang chạy MigrationsOnly") | Out-Null
    $StepStatus["Chay unified schema"] = "SKIPPED"
    $legacyMigrations = @("appeal_protest_tracking_schema_extension.sql", "random_assignment_schema_extension.sql")
    $migrationFiles = Get-ChildItem -LiteralPath (Join-Path $RepoRoot "database\migrations") -Filter "*.sql" | Sort-Object Name
    foreach ($migration in $migrationFiles) {
        if ($legacyMigrations -contains $migration.Name) {
            $SkippedFiles.Add("$(Get-RelativePath $migration.FullName) - legacy extension đã được gộp vào migration số/unified schema, không chạy mặc định để tránh trùng bảng") | Out-Null
            continue
        }
        Invoke-PsqlFile -Database $DatabaseName -FilePath $migration.FullName -StepName "Chay migrations"
    }
    $StepStatus["Chay migrations"] = "PASSED"
}

if ($SkipSeed) {
    $StepStatus["Chay seed"] = "SKIPPED"
} else {
    $seedFiles = Get-ChildItem -LiteralPath (Join-Path $RepoRoot "database\seed") -Filter "*.sql" | Where-Object { $_.Name -ne "999_seed_all.sql" } | Sort-Object Name
    foreach ($seed in $seedFiles) {
        Invoke-PsqlFile -Database $DatabaseName -FilePath $seed.FullName -StepName "Chay seed"
    }
    $StepStatus["Chay seed"] = "PASSED"
}

if ($SkipTests) {
    $StepStatus["Chay SQL test"] = "SKIPPED"
} else {
    $testNames = @(
        "database_structure_integrity_test.sql",
        "seed_data_integrity_test.sql",
        "statistics_algorithm_precheck.sql"
    )
    foreach ($name in $testNames) {
        $file = Join-Path $ScriptDir $name
        Invoke-PsqlFile -Database $DatabaseName -FilePath $file -StepName "Chay SQL test"
    }
    $StepStatus["Chay SQL test"] = "PASSED"
}

Write-Result -FinalStatus "PASSED"
Write-Host "Hoàn thành kiểm tra PostgreSQL trống. Kết quả: $ResultFile"
