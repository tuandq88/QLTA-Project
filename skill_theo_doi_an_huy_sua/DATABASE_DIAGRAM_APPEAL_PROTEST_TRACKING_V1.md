# DATABASE_DIAGRAM_APPEAL_PROTEST_TRACKING_V1.md

## 1. Đánh giá database hiện có

Database v1 trước đó đã có một số bảng phù hợp:

| Bảng hiện có | Có dùng được không | Vai trò |
|---|---:|---|
| `case_files` | Có | Vụ án/vụ việc gốc |
| `decisions` | Có | Bản án/quyết định bị kháng cáo/kháng nghị |
| `appeals` | Có nhưng chưa đủ | Mới chỉ ghi nhận kháng cáo cơ bản |
| `courts` | Có | Tòa án sơ thẩm và Tòa cấp trên |
| `participants` | Có | Người kháng cáo |
| `documents` | Có | Đơn kháng cáo, quyết định kháng nghị, bản án phúc thẩm |
| `case_assignments` | Có | Liên kết Thẩm phán/HĐXX sơ thẩm |
| `statistics_snapshots` | Có | Tổng hợp thống kê |
| `kpi_values` | Có | Dashboard chất lượng xét xử |
| `validation_results` | Có | Kiểm tra lỗi dữ liệu |

Tuy nhiên bảng `appeals` hiện tại chỉ phù hợp để ghi nhận đơn kháng cáo/kháng nghị đơn giản. Để theo dõi đầy đủ kết quả cấp trên, rút kháng cáo/kháng nghị, y án, hủy, sửa, lỗi khách quan/chủ quan, cần bổ sung module mới.

---

## 2. ERD tổng thể bổ sung

```mermaid
erDiagram
    CASE_FILES ||--o{ APPELLATE_TRACKINGS : has
    DECISIONS ||--o{ APPELLATE_TRACKINGS : appealed_or_protested
    COURTS ||--o{ APPELLATE_TRACKINGS : original_court
    COURTS ||--o{ APPELLATE_TRACKINGS : upper_court
    APPELLATE_TRACKINGS ||--o{ APPEAL_PROTEST_ITEMS : includes
    PARTICIPANTS ||--o{ APPEAL_PROTEST_ITEMS : appellant
    DOCUMENTS ||--o{ APPEAL_PROTEST_ITEMS : source_document
    APPELLATE_TRACKINGS ||--o{ APPELLATE_RESULTS : resolved_by_upper_court
    DOCUMENTS ||--o{ APPELLATE_RESULTS : result_document
    APPELLATE_RESULTS ||--o{ APPELLATE_FAULT_ASSESSMENTS : has
    USERS ||--o{ APPELLATE_FAULT_ASSESSMENTS : responsible_judge
    COURTS ||--o{ APPELLATE_FAULT_ASSESSMENTS : responsible_court
    APPELLATE_TRACKINGS ||--o{ APPELLATE_FOLLOWUP_ACTIONS : requires
    APPELLATE_TRACKINGS ||--o{ APPELLATE_STATUS_HISTORY : logs
    APPELLATE_TRACKINGS ||--o{ VALIDATION_RESULTS : validated
    APPELLATE_TRACKINGS ||--o{ STATISTICS_SNAPSHOTS : contributes_to
    APPELLATE_TRACKINGS ||--o{ KPI_VALUES : impacts

    APPELLATE_TRACKINGS {
        uuid appellate_tracking_id PK
        uuid original_case_id FK
        uuid original_decision_id FK
        uuid original_court_id FK
        uuid upper_court_id FK
        string case_type
        string appeal_protest_type
        date received_date
        string appeal_deadline_status
        string tracking_status
        date sent_to_upper_court_date
        date upper_court_acceptance_date
        string upper_court_case_number
        date resolved_date
        string final_result_code
        string fault_classification
        boolean quality_kpi_impact
        text note
    }

    APPEAL_PROTEST_ITEMS {
        uuid item_id PK
        uuid appellate_tracking_id FK
        string item_type
        string subtype
        uuid appellant_participant_id FK
        string protest_agency_name
        uuid source_document_id FK
        string document_number
        date document_date
        date received_date
        text scope
        text content_summary
        string status
    }

    APPELLATE_RESULTS {
        uuid appellate_result_id PK
        uuid appellate_tracking_id FK
        uuid result_document_id FK
        string result_number
        date result_date
        string result_code
        string result_scope
        text summary
        date effective_date
        boolean requires_retrial
        uuid retrial_case_id FK
    }

    APPELLATE_FAULT_ASSESSMENTS {
        uuid fault_assessment_id PK
        uuid appellate_result_id FK
        string fault_classification
        string fault_reason_group
        string responsible_level
        uuid responsible_court_id FK
        uuid responsible_judge_id FK
        string assessment_source
        date assessment_date
        uuid approved_by FK
        text description
    }

    APPELLATE_FOLLOWUP_ACTIONS {
        uuid followup_action_id PK
        uuid appellate_tracking_id FK
        string action_type
        date due_date
        date completed_date
        uuid assigned_to FK
        string status
        text note
    }

    APPELLATE_STATUS_HISTORY {
        uuid status_history_id PK
        uuid appellate_tracking_id FK
        string old_status
        string new_status
        datetime changed_at
        uuid changed_by FK
        text note
    }
```

---

## 3. Module tối thiểu cần bổ sung

```text
Appeal/Protest Tracking Module
├── appellate_trackings
├── appeal_protest_items
├── appellate_results
├── appellate_fault_assessments
├── appellate_followup_actions
└── appellate_status_history
```

---

## 4. Liên kết với phân hệ phân công án ngẫu nhiên

Phân hệ phân công án cần tiêu chí:

```text
số vụ việc bị hủy, sửa do nguyên nhân chủ quan trong thời hạn 01 năm
```

Do đó module appellate phải cung cấp dữ liệu cho:

```text
judge_workload_snapshots.subjective_cancel_modify_count_1y
assignment_batch_judges.subjective_cancel_modify_count_1y
```

Nguồn tính:

```sql
count(appellate_fault_assessments)
where fault_classification = 'subjective'
and fault_reason_group is not null
and responsible_judge_id = judge_id
and assessment_date >= assignment_date - interval '1 year'
```

---

## 5. Liên kết với KPI Dashboard

Module này cung cấp các KPI:

```text
appeal_rate
protest_rate
appellate_resolved_count
upheld_rate
modified_rate
cancelled_rate
subjective_modified_cancelled_rate
objective_modified_cancelled_rate
withdrawn_appeal_protest_rate
upper_court_pending_cases
```

---

## 6. Liên kết với thống kê TAND

Cần bổ sung mapping vào `statistics_snapshots`:

| metric_code | Ý nghĩa |
|---|---|
| APPEALED_CASES | Số án bị kháng cáo |
| PROTESTED_CASES | Số án bị kháng nghị |
| APPELLATE_ACCEPTED | Số án đã được cấp trên thụ lý |
| APPELLATE_RESOLVED | Số án đã có kết quả cấp trên |
| APPELLATE_UPHELD | Y án |
| APPELLATE_MODIFIED | Sửa án |
| APPELLATE_CANCELLED | Hủy án |
| APPELLATE_WITHDRAWN | Rút kháng cáo/kháng nghị |
| CANCELLED_SUBJECTIVE | Hủy do lỗi chủ quan |
| MODIFIED_SUBJECTIVE | Sửa do lỗi chủ quan |
| CANCELLED_OBJECTIVE | Hủy do khách quan |
| MODIFIED_OBJECTIVE | Sửa do khách quan |

---

## 7. Kết luận đánh giá

Database hiện tại **cần bổ sung** module theo dõi kháng cáo/kháng nghị. Không nên chỉ mở rộng bảng `appeals` vì:

1. Một vụ án có thể có nhiều chủ thể kháng cáo/kháng nghị.
2. Cần theo dõi tiến trình chuyển cấp trên, thụ lý, giải quyết.
3. Cần phân biệt kết quả cuối cùng và từng văn bản/kết quả.
4. Cần phân loại hủy/sửa khách quan/chủ quan.
5. Cần gắn trách nhiệm với Thẩm phán/Tòa án để phục vụ KPI và phân công án ngẫu nhiên.
6. Cần lưu lịch sử trạng thái và hành động tiếp theo.

Sau khi bổ sung module này, database sẽ phù hợp để quản lý vòng đời án từ sơ thẩm đến kết quả cấp trên và đánh giá chất lượng xét xử.
