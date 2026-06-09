param(
    [string]$DatabaseName = "qlta_empty_test"
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $Global:PSNativeCommandUseErrorActionPreference = $false
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ResultFile = Join-Path $ScriptDir "STATISTICS_PRECHECK_RESULT.md"
$PgHost = if ($env:PGHOST) { $env:PGHOST } else { "localhost" }
$PgPort = if ($env:PGPORT) { $env:PGPORT } else { "5432" }
$PgUser = if ($env:PGUSER) { $env:PGUSER } else { "postgres" }
$Lines = New-Object System.Collections.Generic.List[string]
$Messages = New-Object System.Collections.Generic.List[string]

function Add-Line([string]$Text = "") { $Lines.Add($Text) | Out-Null }
function Write-Result([string]$FinalStatus, [string]$ErrorMessage = "") {
    $Lines.Clear()
    Add-Line "# Ket qua precheck thong ke"
    Add-Line ""
    Add-Line "- Thoi diem kiem tra: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')"
    Add-Line "- Database: $DatabaseName"
    Add-Line "- PGHOST: $PgHost"
    Add-Line "- PGPORT: $PgPort"
    Add-Line "- PGUSER: $PgUser"
    Add-Line "- Ket qua cuoi: $FinalStatus"
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
        Add-Line '```text'
        Add-Line $ErrorMessage
        Add-Line '```'
    }
    Set-Content -LiteralPath $ResultFile -Encoding UTF8 -Value ($Lines -join [Environment]::NewLine)
}

function Invoke-PsqlFile([string]$FilePath) {
    Push-Location $RepoRoot
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & psql -h $PgHost -p $PgPort -U $PgUser -d $DatabaseName -v ON_ERROR_STOP=1 -f $FilePath 2>&1
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
        Pop-Location
    }
    if ($output) {
        foreach ($line in @($output)) { $Messages.Add($line.ToString()) | Out-Null }
    }
    return [pscustomobject]@{ ExitCode = $exitCode; Output = @($output | ForEach-Object { $_.ToString() }) }
}

if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
    Write-Result -FinalStatus "NOT_RUN_ENVIRONMENT_LIMITATION" -ErrorMessage "Khong tim thay psql trong PATH."
    exit 2
}
if (-not $env:PGPASSWORD) {
    Write-Result -FinalStatus "NOT_RUN_ENVIRONMENT_LIMITATION" -ErrorMessage "Chua co bien moi truong PGPASSWORD."
    exit 2
}

$precheckFile = Join-Path $ScriptDir "statistics_algorithm_precheck.sql"
$result = Invoke-PsqlFile -FilePath $precheckFile
if ($result.ExitCode -ne 0) {
    Write-Result -FinalStatus "FAILED" -ErrorMessage ($result.Output -join [Environment]::NewLine)
    exit 1
}

Write-Result -FinalStatus "PASSED"
Write-Host "Hoan thanh precheck thong ke. Ket qua: $ResultFile"
