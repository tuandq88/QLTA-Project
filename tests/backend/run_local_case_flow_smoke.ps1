param(
    [string]$BaseUrl = "http://127.0.0.1:3000"
)

$ErrorActionPreference = "Stop"

function Invoke-QltaApi {
    param(
        [Parameter(Mandatory = $true)][string]$Method,
        [Parameter(Mandatory = $true)][string]$Path,
        [object]$Body = $null
    )

    $uri = "$BaseUrl$Path"
    if ($null -eq $Body) {
        return Invoke-RestMethod -Uri $uri -Method $Method
    }

    return Invoke-RestMethod `
        -Uri $uri `
        -Method $Method `
        -ContentType "application/json" `
        -Body ($Body | ConvertTo-Json -Depth 20)
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

$health = Invoke-QltaApi -Method "GET" -Path "/health/db"
Assert-True $health.success "Health DB failed"

$me = Invoke-QltaApi -Method "GET" -Path "/auth/me"
Assert-True ($me.data.roleCode -eq "local_no_auth") "AUTH_REQUIRED=false is not active"

$courtResponse = Invoke-QltaApi -Method "GET" -Path "/api/courts?page=1&pageSize=1"
Assert-True ($courtResponse.data.Count -ge 1) "No court found for smoke test"
$courtId = $courtResponse.data[0].court_id

$suffix = Get-Date -Format "yyyyMMddHHmmss"
$case = Invoke-QltaApi -Method "POST" -Path "/api/cases" -Body @{
    court_id = $courtId
    case_code = "LOCAL-SMOKE-$suffix"
    case_number = "LOCAL-SMOKE-$suffix"
    case_type = "criminal"
    case_group = "SO_THAM"
    filing_date = "2026-06-25"
    acceptance_date = "2026-06-25"
    case_status = "accepted"
    summary = "Ho so kiem thu API local, khong dung du lieu ca nhan that."
}
$caseId = $case.data.case_id
Assert-True ([string]::IsNullOrWhiteSpace($caseId) -eq $false) "Case create did not return case_id"

$occurrence = Invoke-QltaApi -Method "POST" -Path "/api/case-occurrences" -Body @{
    case_id = $caseId
    occurrence_no = 1
    acceptance_date = "2026-06-25"
    acceptance_type_code = "INITIAL_ACCEPTANCE"
    source_note = "Tao bang smoke test local."
}

$participant = Invoke-QltaApi -Method "POST" -Path "/api/participants" -Body @{
    case_id = $caseId
    participant_type = "TEST_PARTICIPANT"
    full_name = "Nguoi kiem thu local"
    note = "Du lieu mau local, khong phai du lieu that."
}

$hearing = Invoke-QltaApi -Method "POST" -Path "/api/hearings" -Body @{
    case_id = $caseId
    hearing_type = "LOCAL_TEST"
    scheduled_date = "2026-07-01"
    scheduled_time = "08:00"
    courtroom = "Phong xu an local"
}

$validation = Invoke-QltaApi -Method "POST" -Path "/api/validation-results" -Body @{
    case_id = $caseId
    rule_code = "LOCAL_FLOW_SMOKE_TEST"
    severity = "WARNING"
    message = "Canh bao kiem thu API local."
    field_name = "case_id"
    checked_by = "local-no-auth"
    suggested_action = "Kiem tra lai du lieu mau truoc khi dung."
}

$caseRead = Invoke-QltaApi -Method "GET" -Path "/api/cases/$caseId"
Assert-True ($caseRead.data.case_id -eq $caseId) "Case detail mismatch"

$participants = Invoke-QltaApi -Method "GET" -Path "/api/participants?page=1&pageSize=20&case_id=$caseId"
$hearings = Invoke-QltaApi -Method "GET" -Path "/api/hearings?page=1&pageSize=20&case_id=$caseId"
$occurrences = Invoke-QltaApi -Method "GET" -Path "/api/case-occurrences?page=1&pageSize=20&case_id=$caseId"
$validations = Invoke-QltaApi -Method "GET" -Path "/api/validation-results?page=1&pageSize=20&case_id=$caseId"

Assert-True ($participants.data.Count -ge 1) "Participant list did not include created record"
Assert-True ($hearings.data.Count -ge 1) "Hearing list did not include created record"
Assert-True ($occurrences.data.Count -ge 1) "Occurrence list did not include created record"
Assert-True ($validations.data.Count -ge 1) "Validation list did not include created record"

$audit = Invoke-QltaApi -Method "GET" -Path "/api/audit-logs?page=1&pageSize=20&record_id=$caseId"
Assert-True ($audit.data.Count -ge 1) "Audit log did not include case create"

[pscustomobject]@{
    success = $true
    case_id = $caseId
    occurrence_id = $occurrence.data.occurrence_id
    participant_id = $participant.data.participant_id
    hearing_id = $hearing.data.hearing_id
    validation_id = $validation.data.validation_id
    audit_count = $audit.data.Count
} | ConvertTo-Json -Depth 5
