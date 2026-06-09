# STATISTICAL REFERENCE DATA ERD

ERD này mô tả lớp danh mục thống kê bổ sung ở migration 004. Các cột text/code cũ vẫn được giữ để migration an toàn và phục vụ backfill.

```mermaid
erDiagram
    STATISTICAL_CATEGORIES ||--o{ STATISTICAL_INDICATORS : contains
    STATISTICAL_INDICATORS ||--o{ STATISTICAL_INDICATOR_OPTIONS : has
    STATISTICAL_INDICATORS ||--o{ STATISTICAL_INDICATOR_APPLICABILITY : applies_to
    STATISTICAL_INDICATORS ||--o{ ENTITY_STATISTICAL_ATTRIBUTES : records
    STATISTICAL_INDICATOR_OPTIONS ||--o{ ENTITY_STATISTICAL_ATTRIBUTES : selected_option
    CASE_FILES ||--o{ ENTITY_STATISTICAL_ATTRIBUTES : context

    STATISTICAL_CATEGORIES {
        uuid statistical_category_id PK
        string category_code UK
        string category_name
        string case_type_scope
        boolean is_active
    }

    STATISTICAL_INDICATORS {
        uuid statistical_indicator_id PK
        uuid statistical_category_id FK
        string indicator_code UK
        string input_control_type
        string value_type
        boolean allow_multiple
        string applies_to_entity
    }

    STATISTICAL_INDICATOR_OPTIONS {
        uuid option_id PK
        uuid statistical_indicator_id FK
        string option_code
        string option_name
    }

    ENTITY_STATISTICAL_ATTRIBUTES {
        uuid attribute_id PK
        string entity_type
        uuid entity_id
        uuid case_id FK
        uuid statistical_indicator_id FK
        uuid option_id FK
        boolean boolean_value
        numeric numeric_value
        date date_value
    }
```

```mermaid
erDiagram
    CASE_FILES ||--o{ CRIMINAL_CASE_DETAILS : has
    CRIMINAL_CASE_DETAILS ||--o{ DEFENDANTS : has
    DEFENDANTS ||--o{ CHARGES : charged_with
    DM_PENAL_CODE_ARTICLES ||--o{ DM_CRIMES : defines
    DM_PENAL_CODE_ARTICLES ||--o{ CHARGES : referenced_by
    DM_CRIMES ||--o{ CHARGES : selected_by

    DEFENDANTS ||--o{ DEFENDANT_STATISTICAL_FEATURES : has
    DM_DEFENDANT_STATISTICAL_FEATURES ||--o{ DEFENDANT_STATISTICAL_FEATURES : selected
    DM_STATISTICAL_OPTION_GROUPS ||--o{ DM_STATISTICAL_OPTIONS : contains
    DEFENDANTS ||--o{ DEFENDANT_STATISTICAL_OPTION_VALUES : has
    DM_STATISTICAL_OPTIONS ||--o{ DEFENDANT_STATISTICAL_OPTION_VALUES : selected
    CASE_FILES ||--o{ DEFENDANT_STATISTICAL_FEATURES : context

    DM_PENAL_CODE_ARTICLES {
        uuid article_id PK
        string code UK
        string article_number
        string law_code
    }

    DM_CRIMES {
        uuid crime_id PK
        uuid article_id FK
        string crime_code UK
        string crime_name
    }

    DM_DEFENDANT_STATISTICAL_FEATURES {
        uuid feature_id PK
        string feature_code UK
        string feature_name
    }

    DEFENDANT_STATISTICAL_FEATURES {
        uuid id PK
        uuid defendant_id FK
        uuid feature_id FK
        uuid case_id FK
        boolean selected
    }
```

```mermaid
erDiagram
    CASE_FILES ||--o{ CASE_LEGAL_RELATIONSHIPS : has
    DM_LEGAL_RELATIONSHIPS ||--o{ CASE_LEGAL_RELATIONSHIPS : selected
    DM_LEGAL_RELATIONSHIPS ||--o{ DM_LEGAL_RELATIONSHIPS : parent_child

    CASE_FILES ||--o{ DECISIONS : has
    DM_TRIAL_RESULT_TYPES ||--o{ DECISIONS : result
    DECISIONS ||--o{ DECISION_RESULT_ATTRIBUTES : has
    STATISTICAL_INDICATORS ||--o{ DECISION_RESULT_ATTRIBUTES : indicator
    STATISTICAL_INDICATOR_OPTIONS ||--o{ DECISION_RESULT_ATTRIBUTES : option

    DM_LEGAL_RELATIONSHIPS {
        uuid legal_relationship_id PK
        string relationship_code UK
        string relationship_name
        string case_type_scope
        uuid parent_id FK
    }

    CASE_LEGAL_RELATIONSHIPS {
        uuid id PK
        uuid case_id FK
        uuid legal_relationship_id FK
        boolean is_primary
    }

    DM_TRIAL_RESULT_TYPES {
        uuid trial_result_type_id PK
        string result_code UK
        string result_name
        boolean affects_kpi
        boolean is_final_result
    }
```

```mermaid
erDiagram
    CASE_FILES ||--o{ APPELLATE_TRACKINGS : original_case
    DECISIONS ||--o{ APPELLATE_TRACKINGS : original_decision
    DM_APPEAL_PROTEST_TYPES ||--o{ APPELLATE_TRACKINGS : type
    DM_APPELLATE_RESULT_CODES ||--o{ APPELLATE_TRACKINGS : final_result
    APPELLATE_TRACKINGS ||--o{ APPELLATE_RESULTS : has
    APPELLATE_RESULTS ||--o{ APPELLATE_FAULT_ASSESSMENTS : has
    DM_FAULT_CLASSIFICATIONS ||--o{ APPELLATE_FAULT_ASSESSMENTS : classification
    DM_FAULT_REASON_GROUPS ||--o{ APPELLATE_FAULT_ASSESSMENTS : reason_group

    DM_APPELLATE_RESULT_CODES {
        uuid appellate_result_code_id PK
        string result_code UK
        string result_name
        boolean is_cancelled
        boolean is_modified
        boolean is_upheld
        boolean requires_fault_classification
    }

    DM_FAULT_CLASSIFICATIONS {
        uuid fault_classification_id PK
        string classification_code UK
        string classification_name
    }

    DM_FAULT_REASON_GROUPS {
        uuid fault_reason_group_id PK
        string reason_code UK
        string reason_name
        string classification_scope
    }
```

```mermaid
erDiagram
    DM_STATISTICAL_FORMS ||--o{ DM_STATISTICAL_FORM_ITEMS : contains
    DM_STATISTICAL_FORM_ITEMS ||--o{ DM_STATISTICAL_FORM_ITEMS : parent_child
    DM_STATISTICAL_METRICS ||--o{ DM_STATISTICAL_FORM_ITEMS : maps
    DM_STATISTICAL_METRICS ||--o{ STATISTICS_SNAPSHOTS : metric
    DM_STATISTICAL_FORM_ITEMS ||--o{ STATISTICS_SNAPSHOTS : form_item
    DM_STATISTICAL_METRICS ||--o{ KPI_METRICS : normalized_metric

    DM_STATISTICAL_FORMS {
        uuid form_id PK
        string form_code UK
        string form_name
        string case_type_scope
    }

    DM_STATISTICAL_FORM_ITEMS {
        uuid form_item_id PK
        uuid form_id FK
        string item_code
        string item_name
        uuid metric_id FK
        string source_table
        string source_field
    }

    DM_STATISTICAL_METRICS {
        uuid metric_id PK
        string metric_code UK
        string metric_name
        string aggregation_method
    }
```

## Ghi chú thiết kế

- `entity_statistical_attributes` phục vụ model tổng quát cho dropdown/radio/checkbox/numeric/date khi chưa cần bảng chuyên biệt.
- Bảng chuyên biệt được dùng cho tội danh, đặc điểm bị cáo, quan hệ pháp luật, kết quả xét xử, kết quả cấp trên và chỉ tiêu thống kê/KPI vì các nhóm này có giá trị nghiệp vụ cao.
- `case_legal_relationships` và `defendant_statistical_features` là quan hệ n-n để tránh nối chuỗi hoặc đếm trùng.
- `statistics_snapshots` là snapshot lịch sử; chỉ nên dùng để lưu kết quả tổng hợp sau khi dữ liệu nguồn đã chuẩn hóa.
