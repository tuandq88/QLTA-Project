param(
    [string]$DatabaseName = "qlta_schema_merge_test"
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $Global:PSNativeCommandUseErrorActionPreference = $false
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ResultFile = Join-Path $ScriptDir "EXCEL_CASE_FULL_IMPORT_CHECK_RESULT.md"

function Import-DotEnvLocal {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    Get-Content -LiteralPath $Path | ForEach-Object {
        $line = $_.Trim()
        if (-not $line -or $line.StartsWith("#") -or $line -notmatch '^([^=]+)=(.*)$') { return }
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

function Write-Result {
    param(
        [string]$Status,
        [string]$Message = ""
    )
    $lines = @(
        "# Ket qua kiem tra Excel case full import",
        "",
        "- Thoi diem kiem tra: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')",
        "- Database: $DatabaseName",
        "- Ket qua: $Status",
        "- PGHOST: $PgHost",
        "- PGPORT: $PgPort",
        "- PGUSER: $PgUser",
        ""
    )
    if ($Message) {
        $lines += "## Log"
        $lines += '```text'
        $lines += $Message
        $lines += '```'
    }
    Set-Content -LiteralPath $ResultFile -Encoding UTF8 -Value ($lines -join [Environment]::NewLine)
}

if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
    Write-Result -Status "NOT_RUN_ENVIRONMENT_LIMITATION" -Message "Khong tim thay psql trong PATH."
    exit 2
}
if (-not $env:PGPASSWORD) {
    Write-Result -Status "NOT_RUN_ENVIRONMENT_LIMITATION" -Message "Chua co bien moi truong PGPASSWORD."
    exit 2
}

$testFile = Join-Path $ScriptDir "excel_case_full_import_integrity_test.sql"
Push-Location $RepoRoot
$oldPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
try {
    $output = & psql -h $PgHost -p $PgPort -U $PgUser -d $DatabaseName -v ON_ERROR_STOP=1 -f $testFile 2>&1
    $exitCode = $LASTEXITCODE
} finally {
    $ErrorActionPreference = $oldPreference
    Pop-Location
}

$message = ($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine
if ($exitCode -ne 0) {
    Write-Result -Status "FAILED" -Message $message
    exit 1
}

Write-Result -Status "PASSED" -Message $message
Write-Host "Hoan thanh kiem tra Excel full import. Ket qua: $ResultFile"
