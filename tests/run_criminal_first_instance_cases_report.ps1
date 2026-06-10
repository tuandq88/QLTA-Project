param(
    [string]$DatabaseName = "qlta_schema_merge_test",
    [string]$FromDate = "2026-06-01",
    [string]$ToDate = "2026-06-10",
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $Global:PSNativeCommandUseErrorActionPreference = $false
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..")).Path
$PythonScript = Join-Path $ScriptDir "generate_criminal_first_instance_cases_report_2026_06_01_to_2026_06_10.py"

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

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    throw "Khong tim thay python trong PATH."
}
if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
    throw "Khong tim thay psql trong PATH."
}

$arguments = @(
    $PythonScript,
    "--database", $DatabaseName,
    "--from-date", $FromDate,
    "--to-date", $ToDate
)
if ($OutputPath) {
    $arguments += @("--output", $OutputPath)
}

Push-Location $RepoRoot
try {
    & python @arguments
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
} finally {
    Pop-Location
}
