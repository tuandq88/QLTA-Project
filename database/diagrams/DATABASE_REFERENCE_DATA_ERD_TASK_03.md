# DATABASE REFERENCE DATA ERD TASK 03

## Mô hình danh mục tổng quát

```mermaid
erDiagram
    DM_CATEGORIES ||--o{ DM_CATEGORY_ITEMS : contains
    DM_CATEGORY_ITEMS ||--o{ DM_CATEGORY_ITEMS : parent_child
    DM_CATEGORIES ||--o{ DM_TABLE_REFERENCE_COLUMNS : binds

    DM_CATEGORIES {
        uuid category_id PK
        string category_code UK
        string category_name
        boolean is_active
        int sort_order
    }

    DM_CATEGORY_ITEMS {
        uuid item_id PK
        uuid category_id FK
        string item_code
        string item_name
        uuid parent_item_id FK
        boolean is_active
        int sort_order
        jsonb metadata
    }

    DM_TABLE_REFERENCE_COLUMNS {
        uuid binding_id PK
        uuid category_id FK
        string table_name
        string source_column_name
        string reference_column_name
        int migration_phase
    }
```

## Quan hệ 1-n sang bảng nghiệp vụ

```mermaid
erDiagram
    DM_CATEGORY_ITEMS ||--o{ CASE_FILES : case_group_id
    DM_CATEGORY_ITEMS ||--o{ CASE_FILES : procedure_law_id
    DM_CATEGORY_ITEMS ||--o{ PARTICIPANTS : participant_type_id
    DM_CATEGORY_ITEMS ||--o{ DOCUMENTS : document_type_id
    DM_CATEGORY_ITEMS ||--o{ DECISIONS : decision_type_id
    DM_CATEGORY_ITEMS ||--o{ DEADLINES : deadline_type_id
    DM_CATEGORY_ITEMS ||--o{ VALIDATION_RESULTS : rule_id
    DM_CATEGORY_ITEMS ||--o{ KPI_METRICS : metric_group_id
    DM_CATEGORY_ITEMS ||--o{ APPELLATE_TRACKINGS : tracking_status_id
    DM_CATEGORY_ITEMS ||--o{ APPELLATE_RESULTS : result_code_id
    DM_CATEGORY_ITEMS ||--o{ CASE_RISK_FLAGS : risk_type_id
```

Task 03 thêm FK nullable đến `dm_category_items` để không phá dữ liệu cũ. Tầng ứng dụng hoặc task backfill sau sẽ bảo đảm item thuộc đúng category theo mapping trong `dm_table_reference_columns`.

## Nhóm danh mục ưu tiên

- Hồ sơ: `case_group`, `procedure_law`, `case_stage`, `case_status`.
- Đương sự/tài liệu/quyết định: `participant_type`, `document_type`, `decision_type`.
- Deadline/validation: `deadline_type`, `deadline_status`, `warning_level`, `validation_rule`, `validation_status`.
- Thống kê/KPI: `period_type`, `aggregation_level`, `statistic_form`, `kpi_group`.
- Phân công: `assignment_role`, `assignment_method`, `assignment_status`.
- Cấp trên: `appeal_protest_type`, `tracking_status`, `appellate_result`, `fault_classification`, `fault_reason_group`.
- AI/audit: `risk_type`, `ai_suggestion_type`, `audit_action`.
