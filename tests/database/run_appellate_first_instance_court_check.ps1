param(
    [string]$DatabaseName = "qlta_schema_merge_test"
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $Global:PSNativeCommandUseErrorActionPreference = $false
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ResultFile = Join-Path $ScriptDir "APPELLATE_FIRST_INSTANCE_COURT_CHECK_RESULT.md"

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

function Invoke-PsqlFile {
    param(
        [string]$FilePath,
        [string]$StepName
    )

    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & psql -h $PgHost -p $PgPort -U $PgUser -d $DatabaseName -v ON_ERROR_STOP=1 -f $FilePath 2>&1
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
    }

    [pscustomobject]@{
        Step = $StepName
        ExitCode = $exitCode
        Output = (($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine)
    }
}

function Write-Result {
    param(
        [string]$Status,
        [object[]]$StepResults
    )

    $lines = @(
        "# APPELLATE_FIRST_INSTANCE_COURT_CHECK_RESULT",
        "",
        "- Thoi diem kiem tra: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')",
        "- Database: $DatabaseName",
        "- Ket qua: $Status",
        "- Migration: database/migrations/009_appellate_first_instance_court.sql",
        "- Seed courts: database/seed/011_courts_quang_ngai.sql",
        "- Seed test: database/seed/test/060_test_appellate_first_instance_courts.sql",
        "- Test SQL: tests/database/appellate_first_instance_court_integrity_test.sql",
        "",
        "## Lenh chay lai",
        "",
        '```powershell',
        ".\tests\database\run_appellate_first_instance_court_check.ps1 -DatabaseName $DatabaseName",
        '```',
        "",
        "## Log chi tiet",
        ""
    )

    foreach ($step in $StepResults) {
        $lines += "### $($step.Step)"
        $lines += ""
        $lines += "- Exit code: $($step.ExitCode)"
        $lines += ""
        $lines += '```text'
        $lines += $step.Output
        $lines += '```'
        $lines += ""
    }

    Set-Content -LiteralPath $ResultFile -Encoding UTF8 -Value ($lines -join [Environment]::NewLine)
}

Import-DotEnvLocal -Path (Join-Path $RepoRoot ".env.local")

$PgHost = if ($env:PGHOST) { $env:PGHOST } else { "localhost" }
$PgPort = if ($env:PGPORT) { $env:PGPORT } else { "5432" }
$PgUser = if ($env:PGUSER) { $env:PGUSER } else { "postgres" }

if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
    Write-Result -Status "NOT_RUN_ENVIRONMENT_LIMITATION" -StepResults @(
        [pscustomobject]@{ Step = "environment"; ExitCode = 2; Output = "Khong tim thay psql trong PATH." }
    )
    exit 2
}
if (-not $env:PGPASSWORD) {
    Write-Result -Status "NOT_RUN_ENVIRONMENT_LIMITATION" -StepResults @(
        [pscustomobject]@{ Step = "environment"; ExitCode = 2; Output = "Chua co bien moi truong PGPASSWORD." }
    )
    exit 2
}

$steps = @(
    [pscustomobject]@{ Name = "migration 009"; Path = Join-Path $RepoRoot "database\migrations\009_appellate_first_instance_court.sql" },
    [pscustomobject]@{ Name = "seed 011 courts"; Path = Join-Path $RepoRoot "database\seed\011_courts_quang_ngai.sql" },
    [pscustomobject]@{ Name = "seed 060 test appellate first-instance courts"; Path = Join-Path $RepoRoot "database\seed\test\060_test_appellate_first_instance_courts.sql" },
    [pscustomobject]@{ Name = "test appellate first-instance court integrity"; Path = Join-Path $ScriptDir "appellate_first_instance_court_integrity_test.sql" }
)

$results = @()
Push-Location $RepoRoot
try {
    foreach ($step in $steps) {
        $result = Invoke-PsqlFile -FilePath $step.Path -StepName $step.Name
        $results += $result
        if ($result.ExitCode -ne 0) {
            Write-Result -Status "FAILED" -StepResults $results
            exit 1
        }
    }
} finally {
    Pop-Location
}

Write-Result -Status "PASSED" -StepResults $results
Write-Host "Hoan thanh kiem tra first_instance_court cho an phuc tham. Ket qua: $ResultFile"
