# Core Database Schema ERD

```mermaid
erDiagram
    courts ||--o{ courts : parent
    courts ||--o{ users : has
    courts ||--o{ case_files : receives
    users ||--o| judge_profiles : extends
    users ||--o{ case_files : assigned_judge
    case_files ||--o{ participants : has
    case_files ||--o{ documents : has
    case_files ||--o{ hearings : schedules
    case_files ||--o{ decisions : produces
    documents ||--o{ decisions : attaches
    case_files ||--o{ case_assignments : assigned
    users ||--o{ case_assignments : assignee
    case_files ||--o{ case_events : lifecycle
    users ||--o{ case_events : performs
    documents ||--o{ case_events : source
    case_files ||--o{ deadlines : tracks
    case_files ||--o{ validation_results : validates
    users ||--o{ audit_logs : actor

    courts {
        uuid court_id PK
        uuid parent_court_id FK
        varchar court_code UK
        varchar court_name
        court_level_enum court_level
        varchar province
        varchar district_area
        text address
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    users {
        uuid user_id PK
        uuid court_id FK
        varchar full_name
        varchar position_title
        user_role_enum role_code
        varchar department
        varchar email UK
        varchar phone
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    judge_profiles {
        uuid judge_profile_id PK
        uuid user_id FK
        varchar judge_code UK
        varchar judge_title
        varchar specialized_court_code
        varchar specialized_group
        boolean is_leadership
        numeric leadership_quota
        boolean maternity_quota_status
        integer annual_assignment_quota
        boolean can_handle_minor_cases
        boolean is_active_for_assignment
    }

    case_files {
        uuid case_id PK
        uuid court_id FK
        varchar case_code UK
        varchar case_number
        case_type_enum case_type
        varchar case_group
        varchar procedure_law
        date filing_date
        date acceptance_date
        varchar current_stage
        case_status_enum case_status
        varchar resolution_status
        boolean has_foreign_element
        boolean is_minor_related
        boolean is_confidential
        uuid assigned_judge_id FK
        date closed_date
        text summary
    }

    participants {
        uuid participant_id PK
        uuid case_id FK
        participant_type_enum participant_type
        varchar full_name
        varchar organization_name
        varchar legal_representative
        varchar id_number
        date date_of_birth
        varchar gender
        text address
        varchar phone
        varchar email
        boolean is_minor
        boolean needs_interpreter
    }

    documents {
        uuid document_id PK
        uuid case_id FK
        document_type_enum document_type
        varchar document_number
        date document_date
        varchar issued_by
        varchar file_name
        text storage_path
        varchar checksum UK
        boolean is_required
        boolean is_valid
    }

    hearings {
        uuid hearing_id PK
        uuid case_id FK
        hearing_type_enum hearing_type
        date scheduled_date
        time scheduled_time
        varchar courtroom
        text panel_composition
        hearing_status_enum hearing_status
        text postponement_reason
        date actual_opened_date
        date actual_closed_date
    }

    decisions {
        uuid decision_id PK
        uuid case_id FK
        decision_type_enum decision_type
        varchar decision_number
        date decision_date
        varchar result_code
        text result_summary
        boolean is_final
        date effective_date
        uuid document_id FK
    }

    case_assignments {
        uuid assignment_id PK
        uuid case_id FK
        uuid user_id FK
        assignment_role_enum assignment_role
        date assigned_date
        date ended_date
        boolean is_primary
        assignment_status_enum status
    }

    case_events {
        uuid event_id PK
        uuid case_id FK
        varchar event_type
        varchar event_stage
        date event_date
        uuid performed_by FK
        text description
        uuid source_document_id FK
    }

    deadlines {
        uuid deadline_id PK
        uuid case_id FK
        varchar deadline_type
        date start_date
        date due_date
        date completed_date
        integer extended_days
        deadline_status_enum deadline_status
        text legal_basis
        varchar warning_level
    }

    validation_results {
        uuid validation_id PK
        uuid case_id FK
        varchar rule_code
        validation_severity_enum severity
        varchar validation_status
        text message
        varchar field_name
        timestamp checked_at
        varchar checked_by
        text legal_basis
        text suggested_action
    }

    audit_logs {
        uuid audit_id PK
        varchar table_name
        uuid record_id
        audit_action_type_enum action
        uuid actor_id FK
        timestamp event_time
        jsonb before_data
        jsonb after_data
        inet ip_address
        text user_agent
        text note
    }
```

## Notes

- The core uses PostgreSQL enums for stable operational states and roles because these values are used in constraints, partial indexes, and validation paths.
- `dm_categories` and `dm_category_items` are included as a minimal reference-data foundation for later business-specific catalogs, without expanding this core task into detailed legal/statistical catalogs.
- Random assignment batches, appeal/protest tracking, statistics/KPI formulas, and specialized case detail tables are intentionally outside this ERD.
