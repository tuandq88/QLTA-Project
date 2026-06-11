param(
    [string]$DatabaseName = "qlta_schema_merge_test"
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $Global:PSNativeCommandUseErrorActionPreference = $false
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ResultFile = Join-Path $ScriptDir "CRIMINAL_FIRST_INSTANCE_RETURN_TO_PROCURACY_LIST_SKILL_RESULT.md"

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
$TestFile = Join-Path $ScriptDir "criminal_return_to_procuracy_occurrence_logic_test.sql"
$SkillFile = "knowledge_base/skills/statistics/skill_criminal_first_instance_return_to_procuracy_list.md"

function Write-Result {
    param(
        [string]$Status,
        [string]$Message = ""
    )
    $lines = @(
        "# CRIMINAL_FIRST_INSTANCE_RETURN_TO_PROCURACY_LIST_SKILL_RESULT",
        "",
        "- Thoi diem kiem tra: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')",
        "- Database: $DatabaseName",
        "- Ket qua: $Status",
        "- Skill da tao/cap nhat: $SkillFile",
        "- Schema hien tai co occurrence/event day du: Co sau migration 007_case_occurrences_and_resolution_events.sql",
        "- Migration da tao: database/migrations/007_case_occurrences_and_resolution_events.sql",
        "- Danh muc can co: HINH_SU/criminal, SO_THAM, INITIAL_ACCEPTANCE, RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION, RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION, TRIAL_JUDGMENT, PROCURACY/VIEN_KIEM_SAT, OCCURRENCE.",
        "- Test da tao: tests/database/criminal_return_to_procuracy_occurrence_logic_test.sql",
        "",
        "## Giai thich vi du vu an A",
        "",
        "- Ky 2026-03-01 den 2026-06-30: accepted_count = 2, resolved_count = 2, remaining_count = 0, return_to_procuracy_list_count = 1.",
        "- Ky 2026-03-01 den 2026-05-31: accepted_count = 2, resolved_count = 1, remaining_count = 1, return_to_procuracy_list_count = 1.",
        "- Test dung bang tam de chung minh don vi dung la occurrence/event, khong phai distinct case_id.",
        "",
        "## Lenh chay lai",
        "",
        '```powershell',
        ".\tests\database\run_criminal_return_to_procuracy_occurrence_logic_check.ps1 -DatabaseName $DatabaseName",
        '```',
        "",
        "## Diem con thieu",
        "",
        "- Test nay dung bang tam de bao ve logic toi thieu; test lifecycle nhieu ky dung bang that nam trong tests/database/run_criminal_return_lifecycle_skill_check.ps1.",
        "- case_files.acceptance_date va case_files.closed_date chi du cho timeline don, khong du thay the occurrence/event.",
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

Push-Location $RepoRoot
$oldPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
try {
    $output = & psql -h $PgHost -p $PgPort -U $PgUser -d $DatabaseName -v ON_ERROR_STOP=1 -f $TestFile 2>&1
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
Write-Host "Hoan thanh kiem tra skill list tra ho so cho VKS. Ket qua: $ResultFile"
