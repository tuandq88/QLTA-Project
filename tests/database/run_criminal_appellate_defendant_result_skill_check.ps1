param(
    [string]$DatabaseName = "qlta_schema_merge_test"
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $Global:PSNativeCommandUseErrorActionPreference = $false
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ResultFile = Join-Path $ScriptDir "CRIMINAL_APPELLATE_DEFENDANT_RESULT_SKILL_RESULT.md"

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
        "# CRIMINAL_APPELLATE_DEFENDANT_RESULT_SKILL_RESULT",
        "",
        "- Thoi diem kiem tra: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')",
        "- Database: $DatabaseName",
        "- Ket qua: $Status",
        "- Migration: database/migrations/008_criminal_appellate_defendant_results.sql",
        "- Bang bi cao: defendants",
        "- Bang ket qua phuc tham theo bi cao: criminal_appellate_defendant_results",
        "- Bang tieu chi sua an: criminal_appellate_modify_criteria",
        "- Seed danh muc: database/seed/003_reference_data_seed.sql",
        "- Seed test: database/seed/test/050_test_criminal_appellate_defendant_results.sql",
        "- Skill: knowledge_base/skills/statistics/skill_criminal_appellate_defendant_result_rules.md",
        "- Test SQL: tests/database/test_criminal_appellate_defendant_result_skill.sql",
        "",
        "## Ky kiem tra",
        "",
        "| Ky | Tu ngay | Den ngay | Ghi chu |",
        "|---|---:|---:|---|",
        "| A | 2026-06-01 | 2026-06-10 | HSPT-001 rut khang cao mot bi cao truoc phien toa, vu van con lai |",
        "| B | 2026-06-01 | 2026-06-30 | HSPT-002, HSPT-004 giai quyet het; HSPT-005 van con lai |",
        "| C | 2026-07-01 | 2026-07-31 | HSPT-003 giai quyet trong thang 7 |",
        "| D | 2026-06-01 | 2026-07-31 | Kiem tra tong hop hai thang |",
        "",
        "## Expected vs actual chinh",
        "",
        "| Ho so | Ky | Expected |",
        "|---|---|---|",
        "| HSPT-001 | A | defendant_resolved=1, defendant_remaining=2, case_resolved=0, case_remaining=1 |",
        "| HSPT-002 | B | termination=2, uphold=1, modify=1, case_resolved=1, case_remaining=0 |",
        "| HSPT-003 | B/C | B con lai=1; C resolved=1, cancel=1, modify=1 |",
        "| HSPT-004 | B | termination_at_hearing=1, case_resolved=1 |",
        "| HSPT-005 | B | uphold=1, modify=1, case_resolved=0, case_remaining=1 |",
        "",
        "## Nguyen tac da kiem tra",
        "",
        "- Ket qua phuc tham duoc ghi theo tung defendant_id, khong gan chung cho case_id.",
        "- Vu an chi duoc tinh da giai quyet khi tat ca bi cao trong pham vi phuc tham co final result den ngay chot.",
        "- Bi cao rut khang cao/khang nghi truoc phien toa duoc tinh la bi cao da giai quyet nhom dinh chi nhung khong lam ca vu an giai quyet neu con bi cao chua co ket qua.",
        "- Mot bi cao khong duoc co hon mot final result trong cung case_id.",
        "- Ket qua sua an phai luu duoc tieu chi sua an trong criminal_appellate_modify_criteria.",
        "",
        "## Lenh chay lai",
        "",
        '```powershell',
        ".\tests\database\run_criminal_appellate_defendant_result_skill_check.ps1 -DatabaseName $DatabaseName",
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
    [pscustomobject]@{ Name = "migration 008"; Path = Join-Path $RepoRoot "database\migrations\008_criminal_appellate_defendant_results.sql" },
    [pscustomobject]@{ Name = "seed 003 reference data"; Path = Join-Path $RepoRoot "database\seed\003_reference_data_seed.sql" },
    [pscustomobject]@{ Name = "seed 050 test appellate defendant results"; Path = Join-Path $RepoRoot "database\seed\test\050_test_criminal_appellate_defendant_results.sql" },
    [pscustomobject]@{ Name = "test appellate defendant result skill"; Path = Join-Path $ScriptDir "test_criminal_appellate_defendant_result_skill.sql" }
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
Write-Host "Hoan thanh kiem tra an hinh su phuc tham theo tung bi cao. Ket qua: $ResultFile"
