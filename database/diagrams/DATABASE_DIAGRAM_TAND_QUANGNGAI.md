# DATABASE DIAGRAM - Hệ thống quản lý Tòa án Quảng Ngãi

## 1. Tư duy thiết kế cơ sở dữ liệu

Hệ thống nên thiết kế theo mô hình **Core Case Management + Specialized Case Modules**.

- `courts`, `users`, `case_files`, `participants`, `documents`, `hearings`, `decisions`, `appeals`, `deadlines`, `statistics_snapshots` là lõi chung.
- `civil_case_details` mở rộng cho dân sự, hôn nhân gia đình, kinh doanh thương mại, lao động, việc dân sự.
- `criminal_case_details`, `defendants`, `charges`, `preventive_measures`, `sentences` mở rộng cho án hình sự.
- `administrative_case_details`, `challenged_admin_objects`, `dialogue_sessions` mở rộng cho án hành chính.
- `case_events` là nhật ký nghiệp vụ để theo dõi toàn bộ vòng đời hồ sơ.
- `validation_results` dùng cho AI/rule engine kiểm tra thiếu dữ liệu, quá hạn, sai logic.
- `kpi_metrics` và `statistics_snapshots` phục vụ dashboard lãnh đạo.

---

## 2. Sơ đồ ERD tổng thể

```mermaid
erDiagram

    COURTS ||--o{ USERS : employs
    COURTS ||--o{ CASE_FILES : manages
    USERS ||--o{ CASE_ASSIGNMENTS : assigned
    CASE_FILES ||--o{ CASE_ASSIGNMENTS : has
    CASE_FILES ||--o{ PARTICIPANTS : has
    CASE_FILES ||--o{ CASE_EVENTS : logs
    CASE_FILES ||--o{ DOCUMENTS : stores
    CASE_FILES ||--o{ HEARINGS : schedules
    CASE_FILES ||--o{ DECISIONS : issues
    CASE_FILES ||--o{ APPEALS : may_have
    CASE_FILES ||--o{ DEADLINES : tracks
    CASE_FILES ||--o{ VALIDATION_RESULTS : checked_by_ai
    CASE_FILES ||--o{ STATISTICS_SNAPSHOTS : contributes_to

    CASE_FILES ||--o| CIVIL_CASE_DETAILS : civil_extension
    CASE_FILES ||--o| CRIMINAL_CASE_DETAILS : criminal_extension
    CASE_FILES ||--o| ADMINISTRATIVE_CASE_DETAILS : administrative_extension

    CIVIL_CASE_DETAILS ||--o{ CIVIL_CLAIMS : includes
    CIVIL_CASE_DETAILS ||--o{ MEDIATION_SESSIONS : has

    CRIMINAL_CASE_DETAILS ||--o{ DEFENDANTS : has
    DEFENDANTS ||--o{ CHARGES : accused_of
    DEFENDANTS ||--o{ PREVENTIVE_MEASURES : subject_to
    DEFENDANTS ||--o{ SENTENCES : receives
    CRIMINAL_CASE_DETAILS ||--o{ VICTIMS : has
    CRIMINAL_CASE_DETAILS ||--o{ INVESTIGATION_RETURNS : may_return

    ADMINISTRATIVE_CASE_DETAILS ||--o{ CHALLENGED_ADMIN_OBJECTS : challenges
    ADMINISTRATIVE_CASE_DETAILS ||--o{ DIALOGUE_SESSIONS : has
    ADMINISTRATIVE_CASE_DETAILS ||--o{ ADMIN_ENFORCEMENT_TRACKING : tracks

    STATISTICS_PERIODS ||--o{ STATISTICS_SNAPSHOTS : contains
    KPI_METRICS ||--o{ KPI_VALUES : defines
    STATISTICS_PERIODS ||--o{ KPI_VALUES : measured_in
    COURTS ||--o{ KPI_VALUES : reported_by
```

---

## 3. Nhóm bảng lõi dùng chung

```mermaid
erDiagram
    COURTS {
        uuid court_id PK
        string court_code
        string court_name
        string court_level
        string province
        string district_area
        boolean is_active
    }

    USERS {
        uuid user_id PK
        uuid court_id FK
        string full_name
        string position_title
        string role_code
        string department
        string email
        boolean is_active
    }

    CASE_FILES {
        uuid case_id PK
        uuid court_id FK
        string case_code
        string case_number
        string case_type
        string case_group
        string procedure_law
        date acceptance_date
        date filing_date
        string current_stage
        string case_status
        string resolution_status
        boolean has_foreign_element
        boolean is_minor_related
        boolean is_confidential
        date closed_date
        text summary
    }

    CASE_ASSIGNMENTS {
        uuid assignment_id PK
        uuid case_id FK
        uuid user_id FK
        string assignment_role
        date assigned_date
        date ended_date
        boolean is_primary
    }

    PARTICIPANTS {
        uuid participant_id PK
        uuid case_id FK
        string participant_type
        string full_name
        string organization_name
        string legal_representative
        string id_number
        date date_of_birth
        string gender
        string address
        string phone
        string email
        boolean is_minor
        boolean needs_interpreter
    }

    DOCUMENTS {
        uuid document_id PK
        uuid case_id FK
        string document_type
        string document_number
        date document_date
        string issued_by
        string file_name
        string storage_path
        string checksum
        boolean is_required
        boolean is_valid
    }

    CASE_EVENTS {
        uuid event_id PK
        uuid case_id FK
        string event_type
        string event_stage
        date event_date
        uuid performed_by FK
        text description
        string source_document_id
    }
```

### Ý nghĩa nhóm lõi

Nhóm này giúp quản lý thống nhất mọi hồ sơ, bất kể là dân sự, hình sự hay hành chính. `case_files` là bảng trung tâm. Mọi bảng nghiệp vụ khác đều xoay quanh `case_id`.

---

## 4. Nhóm bảng tiến trình, phiên tòa, quyết định

```mermaid
erDiagram
    HEARINGS {
        uuid hearing_id PK
        uuid case_id FK
        string hearing_type
        date scheduled_date
        time scheduled_time
        string courtroom
        string panel_composition
        string hearing_status
        string postponement_reason
        date actual_opened_date
        date actual_closed_date
    }

    DECISIONS {
        uuid decision_id PK
        uuid case_id FK
        string decision_type
        string decision_number
        date decision_date
        string result_code
        string result_summary
        boolean is_final
        date effective_date
        string document_id FK
    }

    APPEALS {
        uuid appeal_id PK
        uuid case_id FK
        string appeal_type
        string appellant_type
        string appellant_name
        date appeal_date
        string appeal_scope
        string appeal_status
        uuid appellate_case_id
    }

    DEADLINES {
        uuid deadline_id PK
        uuid case_id FK
        string deadline_type
        date start_date
        date due_date
        date completed_date
        integer extended_days
        string deadline_status
        string legal_basis
        string warning_level
    }

    VALIDATION_RESULTS {
        uuid validation_id PK
        uuid case_id FK
        string rule_code
        string severity
        string validation_status
        text message
        string field_name
        date checked_at
        string checked_by
    }
```

---

## 5. Module dân sự, hôn nhân gia đình, kinh doanh thương mại, lao động

```mermaid
erDiagram
    CASE_FILES ||--o| CIVIL_CASE_DETAILS : has

    CIVIL_CASE_DETAILS {
        uuid civil_detail_id PK
        uuid case_id FK
        string civil_category
        string dispute_type
        decimal claim_value
        string jurisdiction_basis
        boolean mediation_required
        boolean mediation_completed
        string mediation_result
        boolean temporary_measure_requested
        boolean court_fee_advance_paid
    }

    CIVIL_CLAIMS {
        uuid claim_id PK
        uuid civil_detail_id FK
        string claim_type
        string claimant_name
        string respondent_name
        decimal claim_amount
        text claim_content
        string claim_status
    }

    MEDIATION_SESSIONS {
        uuid mediation_id PK
        uuid civil_detail_id FK
        date mediation_date
        string mediation_status
        string result
        text agreement_content
        boolean recognized_by_court
    }
```

### Trường nhập liệu quan trọng cho án dân sự

| Nhóm | Trường |
|---|---|
| Loại án | `civil_category`, `dispute_type` |
| Đương sự | nguyên đơn, bị đơn, người liên quan |
| Giá trị tranh chấp | `claim_value`, `claim_amount` |
| Hòa giải | `mediation_required`, `mediation_result` |
| Án phí | `court_fee_advance_paid` |
| Biện pháp khẩn cấp | `temporary_measure_requested` |
| Kết quả | công nhận thỏa thuận, đình chỉ, xét xử, bác/nhận yêu cầu |

---

## 6. Module hình sự

```mermaid
erDiagram
    CASE_FILES ||--o| CRIMINAL_CASE_DETAILS : has
    CRIMINAL_CASE_DETAILS ||--o{ DEFENDANTS : has
    DEFENDANTS ||--o{ CHARGES : has
    DEFENDANTS ||--o{ PREVENTIVE_MEASURES : has
    DEFENDANTS ||--o{ SENTENCES : has

    CRIMINAL_CASE_DETAILS {
        uuid criminal_detail_id PK
        uuid case_id FK
        string procuracy_name
        string indictment_number
        date indictment_date
        string investigation_agency
        date dossier_received_date
        boolean has_civil_claim
        boolean has_minor_defendant
        boolean has_legal_aid
        string trial_panel_type
    }

    DEFENDANTS {
        uuid defendant_id PK
        uuid criminal_detail_id FK
        string full_name
        date date_of_birth
        string gender
        string nationality
        string ethnicity
        string occupation
        string residence
        string criminal_record_status
        boolean is_minor
        boolean is_detained
        date detention_start_date
        date detention_end_date
    }

    CHARGES {
        uuid charge_id PK
        uuid defendant_id FK
        string crime_name
        string penal_code_article
        string clause_point
        string crime_severity
        string prosecution_decision
        string court_finding
    }

    PREVENTIVE_MEASURES {
        uuid measure_id PK
        uuid defendant_id FK
        string measure_type
        date start_date
        date end_date
        string issued_by
        string status
        string replacement_measure
    }

    SENTENCES {
        uuid sentence_id PK
        uuid defendant_id FK
        string sentence_type
        decimal imprisonment_years
        decimal suspended_years
        decimal probation_years
        decimal fine_amount
        string additional_penalty
        string civil_liability
    }

    VICTIMS {
        uuid victim_id PK
        uuid criminal_detail_id FK
        string full_name
        string organization_name
        string injury_rate
        decimal damage_amount
        string claim_status
    }

    INVESTIGATION_RETURNS {
        uuid return_id PK
        uuid criminal_detail_id FK
        date return_date
        string return_reason
        string requested_by
        string result_after_return
    }
```

### Trường nhập liệu quan trọng cho án hình sự

| Nhóm | Trường |
|---|---|
| Cáo trạng | `indictment_number`, `indictment_date`, `procuracy_name` |
| Bị cáo | họ tên, năm sinh, nơi cư trú, tiền án, tình trạng tạm giam |
| Tội danh | `crime_name`, `penal_code_article`, `clause_point` |
| Biện pháp ngăn chặn | `measure_type`, `start_date`, `end_date` |
| Trả hồ sơ | `return_reason`, `return_date` |
| Kết quả xét xử | hình phạt chính, án treo, phạt tiền, trách nhiệm dân sự |
| Cảnh báo | quá hạn tạm giam, quá hạn chuẩn bị xét xử, thiếu điều luật truy tố |

---

## 7. Module hành chính

```mermaid
erDiagram
    CASE_FILES ||--o| ADMINISTRATIVE_CASE_DETAILS : has
    ADMINISTRATIVE_CASE_DETAILS ||--o{ CHALLENGED_ADMIN_OBJECTS : has
    ADMINISTRATIVE_CASE_DETAILS ||--o{ DIALOGUE_SESSIONS : has
    ADMINISTRATIVE_CASE_DETAILS ||--o{ ADMIN_ENFORCEMENT_TRACKING : has

    ADMINISTRATIVE_CASE_DETAILS {
        uuid admin_detail_id PK
        uuid case_id FK
        string lawsuit_type
        string defendant_agency_name
        string agency_representative
        string agency_level
        boolean compensation_claimed
        decimal compensation_amount
        boolean urgent_case
        string jurisdiction_basis
    }

    CHALLENGED_ADMIN_OBJECTS {
        uuid object_id PK
        uuid admin_detail_id FK
        string object_type
        string object_number
        date object_issue_date
        string issuing_agency
        text object_summary
        string challenged_scope
        string legality_review_result
    }

    DIALOGUE_SESSIONS {
        uuid dialogue_id PK
        uuid admin_detail_id FK
        date dialogue_date
        string dialogue_status
        string result
        text agreement_content
    }

    ADMIN_ENFORCEMENT_TRACKING {
        uuid enforcement_id PK
        uuid admin_detail_id FK
        uuid decision_id FK
        string obligated_agency
        date obligation_due_date
        date compliance_date
        string enforcement_status
        text note
    }
```

### Trường nhập liệu quan trọng cho án hành chính

| Nhóm | Trường |
|---|---|
| Đối tượng kiện | quyết định hành chính, hành vi hành chính, kỷ luật buộc thôi việc, danh sách cử tri |
| Người bị kiện | `defendant_agency_name`, `agency_representative`, `agency_level` |
| Quyết định bị kiện | số, ngày, cơ quan ban hành, phạm vi bị kiện |
| Bồi thường | `compensation_claimed`, `compensation_amount` |
| Đối thoại | `dialogue_status`, `result` |
| Thi hành án hành chính | cơ quan phải thi hành, hạn thi hành, trạng thái thi hành |

---

## 8. Module thống kê, KPI, dashboard

```mermaid
erDiagram
    STATISTICS_PERIODS {
        uuid period_id PK
        string period_type
        date start_date
        date end_date
        string report_year
        string report_month
        string report_quarter
    }

    STATISTICS_SNAPSHOTS {
        uuid snapshot_id PK
        uuid period_id FK
        uuid court_id FK
        uuid case_id FK
        string statistic_form_code
        string case_group
        string metric_code
        decimal metric_value
        string aggregation_level
    }

    KPI_METRICS {
        uuid metric_id PK
        string metric_code
        string metric_name
        string metric_group
        string formula
        string warning_threshold
        string target_value
    }

    KPI_VALUES {
        uuid kpi_value_id PK
        uuid metric_id FK
        uuid period_id FK
        uuid court_id FK
        decimal actual_value
        decimal target_value
        string status
        date calculated_at
    }
```

### KPI lãnh đạo nên có

| KPI | Ý nghĩa |
|---|---|
| `total_accepted_cases` | Tổng thụ lý |
| `resolved_cases` | Đã giải quyết |
| `pending_cases` | Còn tồn |
| `overdue_cases` | Quá hạn |
| `clearance_rate` | Tỷ lệ giải quyết |
| `appeal_rate` | Tỷ lệ kháng cáo |
| `modified_cancelled_rate` | Tỷ lệ án bị sửa/hủy |
| `mediation_success_rate` | Tỷ lệ hòa giải/đối thoại thành |
| `returned_investigation_rate` | Tỷ lệ trả hồ sơ điều tra bổ sung |
| `detention_deadline_warning` | Cảnh báo hạn tạm giam |

---

## 9. Gợi ý triển khai PostgreSQL schema

```sql
CREATE TYPE case_type_enum AS ENUM (
    'civil',
    'marriage_family',
    'business_commercial',
    'labor',
    'criminal',
    'administrative',
    'civil_matter'
);

CREATE TYPE case_status_enum AS ENUM (
    'draft',
    'received',
    'accepted',
    'preparing',
    'trial_scheduled',
    'resolved',
    'appealed',
    'effective',
    'temporarily_suspended',
    'suspended',
    'overdue'
);
```

### Bảng trung tâm

```sql
CREATE TABLE case_files (
    case_id UUID PRIMARY KEY,
    court_id UUID NOT NULL,
    case_code VARCHAR(100) UNIQUE,
    case_number VARCHAR(100),
    case_type case_type_enum NOT NULL,
    case_group VARCHAR(100),
    procedure_law VARCHAR(50),
    filing_date DATE,
    acceptance_date DATE,
    current_stage VARCHAR(100),
    case_status case_status_enum,
    resolution_status VARCHAR(100),
    has_foreign_element BOOLEAN DEFAULT FALSE,
    is_minor_related BOOLEAN DEFAULT FALSE,
    is_confidential BOOLEAN DEFAULT FALSE,
    closed_date DATE,
    summary TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 10. Quy tắc thiết kế quan trọng

### 10.1. Không tạo một bảng riêng cho từng loại tranh chấp nhỏ

Không nên tạo các bảng như:

- `divorce_cases`
- `land_dispute_cases`
- `contract_dispute_cases`
- `inheritance_cases`

Thay vào đó, dùng:

- `case_files.case_type`
- `civil_case_details.civil_category`
- `civil_case_details.dispute_type`
- bảng danh mục `dm_dispute_types`

### 10.2. Dữ liệu thống kê nên tách khỏi dữ liệu hồ sơ

Không nên tính báo cáo trực tiếp từ bảng hồ sơ mỗi lần mở dashboard. Nên có bảng:

- `statistics_snapshots`
- `kpi_values`

để lưu số liệu đã tổng hợp theo tháng, quý, năm.

### 10.3. AI không ghi trực tiếp vào bảng chính

AI nên ghi vào:

- `validation_results`
- `ai_suggestions`
- `case_risk_flags`

Sau đó người dùng xác nhận mới cập nhật dữ liệu chính.

---

## 11. Phiên bản mở rộng đề xuất

Ở giai đoạn sau có thể bổ sung:

```text
ai_suggestions
case_risk_flags
legal_basis_references
statistical_form_definitions
statistical_form_items
audit_logs
sync_jobs
document_ocr_results
notification_queue
```

---

## 12. Kết luận thiết kế

Mô hình cơ sở dữ liệu đề xuất có 05 lớp:

```text
1. Master Data
   courts, users, categories

2. Case Core
   case_files, participants, documents, hearings, decisions

3. Specialized Modules
   civil_case_details, criminal_case_details, administrative_case_details

4. Rule/AI Layer
   deadlines, validation_results, ai_suggestions, risk_flags

5. Analytics Layer
   statistics_snapshots, kpi_metrics, kpi_values
```

Đây là cấu trúc phù hợp để phát triển hệ thống quản lý, thống kê, giám sát và điều hành hoạt động Tòa án hai cấp tỉnh Quảng Ngãi.
