# Data Dictionary tổng

## Entity: Case
case_id, case_number, case_type, acceptance_date, court_level, court_unit, judge, clerk, status, resolved_date, resolution_type.

## Entity: Party
party_id, case_id, role, full_name, organization_name, address, phone, representative, legal_capacity.

## Entity: Defendant
full_name, dob, gender, residence, offense, detention_status, detention_start, detention_end, sentence_type.

## Entity: Deadline
deadline_id, case_id, deadline_type, start_date, due_date, extended_due_date, status.
