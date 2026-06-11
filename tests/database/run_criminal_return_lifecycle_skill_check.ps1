param(
    [string]$DatabaseName = "qlta_schema_merge_test"
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $Global:PSNativeCommandUseErrorActionPreference = $false
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ResultFile = Join-Path $ScriptDir "CRIMINAL_RETURN_LIFECYCLE_TEST_RESULT.md"

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
        "# CRIMINAL_RETURN_LIFECYCLE_TEST_RESULT",
        "",
        "- Thoi diem kiem tra: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')",
        "- Database: $DatabaseName",
        "- Ket qua: $Status",
        "- Migration: database/migrations/007_case_occurrences_and_resolution_events.sql",
        "- Seed danh muc: database/seed/003_reference_data_seed.sql",
        "- Seed test: database/seed/test/040_test_criminal_first_instance_return_lifecycle.sql",
        "- Test SQL: tests/database/test_criminal_first_instance_return_lifecycle_skill.sql",
        "",
        "## Ky kiem tra",
        "",
        "| Ky | Tu ngay | Den ngay | Thu ly | Giai quyet | Tra VKS | Xet xu | Ton cuoi ky |",
        "|---|---:|---:|---:|---:|---:|---:|---:|",
        "| A | 2026-03-01 | 2026-05-31 | 6 | 4 | 4 | 0 | 2 |",
        "| B | 2026-03-01 | 2026-06-30 | 8 | 6 | 4 | 2 | 2 |",
        "| C | 2026-06-01 | 2026-06-30 | 2 | 2 | 0 | 2 | 2 |",
        "| D | 2026-01-01 | 2026-12-31 | 10 | 9 | 7 | 2 | 1 |",
        "| E | 2026-07-01 | 2026-07-31 | 0 | 1 | 1 | 0 | 1 |",
        "",
        "## Nguyen tac da kiem tra",
        "",
        "- Don vi dem la occurrence/vong doi thong ke, khong phai distinct case_id.",
        "- Moi lan tra ho so cho VKS la mot su kien giai quyet rieng cua occurrence.",
        "- Moi lan thu ly lai sau dieu tra bo sung la mot occurrence moi.",
        "- Ho so HSST-RETURN-003 occurrence 4 van ton den het nam 2026.",
        "",
        "## Lenh chay lai",
        "",
        '```powershell',
        ".\tests\database\run_criminal_return_lifecycle_skill_check.ps1 -DatabaseName $DatabaseName",
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
    [pscustomobject]@{ Name = "migration 007"; Path = Join-Path $RepoRoot "database\migrations\007_case_occurrences_and_resolution_events.sql" },
    [pscustomobject]@{ Name = "seed 003 reference data"; Path = Join-Path $RepoRoot "database\seed\003_reference_data_seed.sql" },
    [pscustomobject]@{ Name = "seed 040 test lifecycle"; Path = Join-Path $RepoRoot "database\seed\test\040_test_criminal_first_instance_return_lifecycle.sql" },
    [pscustomobject]@{ Name = "test lifecycle skill"; Path = Join-Path $ScriptDir "test_criminal_first_instance_return_lifecycle_skill.sql" }
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
Write-Host "Hoan thanh kiem tra lifecycle tra ho so cho VKS. Ket qua: $ResultFile"
