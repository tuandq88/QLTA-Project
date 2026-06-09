-- Migration 004: statistical reference data and specialized catalog layer.
-- Scope: additive database-only migration. Do not drop legacy text/code columns.
-- Run after unified schema and migration 003.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ---------------------------------------------------------------------
-- Phase 1: generic statistical indicator catalog.
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS statistical_categories (
    statistical_category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_code VARCHAR(100) UNIQUE NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    description TEXT,
    case_type_scope VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_statistical_categories_code CHECK (category_code ~ '^[a-z][a-z0-9_]*$'),
    CONSTRAINT chk_statistical_categories_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS statistical_indicators (
    statistical_indicator_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    statistical_category_id UUID NOT NULL REFERENCES statistical_categories(statistical_category_id) ON DELETE RESTRICT,
    indicator_code VARCHAR(150) UNIQUE NOT NULL,
    indicator_name VARCHAR(255) NOT NULL,
    input_control_type VARCHAR(50) NOT NULL,
    value_type VARCHAR(50) NOT NULL DEFAULT 'option',
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    allow_multiple BOOLEAN NOT NULL DEFAULT FALSE,
    applies_to_entity VARCHAR(100) NOT NULL,
    case_type_scope VARCHAR(100),
    legal_basis TEXT,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_statistical_indicators_input_control
        CHECK (input_control_type IN ('dropdown', 'radio', 'checkbox', 'checkbox_group', 'number', 'date', 'text')),
    CONSTRAINT chk_statistical_indicators_value_type
        CHECK (value_type IN ('option', 'boolean', 'numeric', 'date', 'text')),
    CONSTRAINT chk_statistical_indicators_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS statistical_indicator_options (
    option_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    statistical_indicator_id UUID NOT NULL REFERENCES statistical_indicators(statistical_indicator_id) ON DELETE CASCADE,
    option_code VARCHAR(150) NOT NULL,
    option_name VARCHAR(255) NOT NULL,
    option_value VARCHAR(255),
    parent_option_id UUID REFERENCES statistical_indicator_options(option_id) ON DELETE RESTRICT,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_statistical_indicator_options_code UNIQUE (statistical_indicator_id, option_code),
    CONSTRAINT chk_statistical_indicator_options_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS statistical_indicator_applicability (
    applicability_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    statistical_indicator_id UUID NOT NULL REFERENCES statistical_indicators(statistical_indicator_id) ON DELETE CASCADE,
    case_type VARCHAR(100),
    entity_type VARCHAR(100) NOT NULL,
    procedure_law VARCHAR(100),
    applies_to_court_level VARCHAR(100),
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    note TEXT
);

CREATE TABLE IF NOT EXISTS entity_statistical_attributes (
    attribute_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type VARCHAR(100) NOT NULL,
    entity_id UUID NOT NULL,
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    statistical_indicator_id UUID NOT NULL REFERENCES statistical_indicators(statistical_indicator_id) ON DELETE RESTRICT,
    option_id UUID REFERENCES statistical_indicator_options(option_id) ON DELETE RESTRICT,
    boolean_value BOOLEAN,
    numeric_value NUMERIC(18,4),
    text_value TEXT,
    date_value DATE,
    source_table VARCHAR(100),
    source_field VARCHAR(100),
    created_by UUID REFERENCES users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_entity_statistical_attribute_option UNIQUE (
        entity_type,
        entity_id,
        statistical_indicator_id,
        option_id
    ),
    CONSTRAINT chk_entity_statistical_attribute_one_value CHECK (
        num_nonnulls(option_id, boolean_value, numeric_value, text_value, date_value) = 1
    )
);

CREATE INDEX IF NOT EXISTS idx_statistical_categories_active_sort
    ON statistical_categories(is_active, sort_order, category_code);
CREATE INDEX IF NOT EXISTS idx_statistical_indicators_category
    ON statistical_indicators(statistical_category_id, is_active, sort_order);
CREATE INDEX IF NOT EXISTS idx_statistical_indicator_options_indicator
    ON statistical_indicator_options(statistical_indicator_id, is_active, sort_order);
CREATE INDEX IF NOT EXISTS idx_stat_indicator_applicability_entity
    ON statistical_indicator_applicability(entity_type, case_type, is_active);
CREATE UNIQUE INDEX IF NOT EXISTS uq_stat_indicator_applicability_scope
    ON statistical_indicator_applicability (
        statistical_indicator_id,
        COALESCE(case_type, ''),
        entity_type,
        COALESCE(procedure_law, ''),
        COALESCE(applies_to_court_level, '')
    );
CREATE INDEX IF NOT EXISTS idx_entity_stat_attributes_case
    ON entity_statistical_attributes(case_id);
CREATE INDEX IF NOT EXISTS idx_entity_stat_attributes_entity
    ON entity_statistical_attributes(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_entity_stat_attributes_indicator
    ON entity_statistical_attributes(statistical_indicator_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_entity_statistical_attribute_value_scope
    ON entity_statistical_attributes (
        entity_type,
        entity_id,
        statistical_indicator_id,
        COALESCE(option_id, uuid_nil())
    );

-- ---------------------------------------------------------------------
-- Phase 2: specialized catalogs for high-value business references.
-- ---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS dm_penal_code_articles (
    article_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) UNIQUE NOT NULL,
    article_number VARCHAR(50) NOT NULL,
    article_title VARCHAR(255),
    chapter VARCHAR(100),
    law_code VARCHAR(100),
    effective_from DATE,
    effective_to DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    CONSTRAINT chk_dm_penal_code_articles_valid_range
        CHECK (effective_to IS NULL OR effective_from IS NULL OR effective_to >= effective_from)
);

CREATE TABLE IF NOT EXISTS dm_crimes (
    crime_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES dm_penal_code_articles(article_id) ON DELETE RESTRICT,
    crime_code VARCHAR(100) UNIQUE NOT NULL,
    crime_name VARCHAR(255) NOT NULL,
    crime_severity VARCHAR(100),
    default_statistical_group VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_dm_crimes_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS dm_defendant_statistical_features (
    feature_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    feature_code VARCHAR(100) UNIQUE NOT NULL,
    feature_name VARCHAR(255) NOT NULL,
    input_control_type VARCHAR(50) NOT NULL DEFAULT 'checkbox',
    description TEXT,
    legal_basis TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_dm_defendant_features_input CHECK (input_control_type IN ('checkbox', 'radio', 'dropdown')),
    CONSTRAINT chk_dm_defendant_features_sort CHECK (sort_order >= 0)
);

CREATE TABLE IF NOT EXISTS defendant_statistical_features (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defendant_id UUID NOT NULL REFERENCES defendants(defendant_id) ON DELETE CASCADE,
    feature_id UUID NOT NULL REFERENCES dm_defendant_statistical_features(feature_id) ON DELETE RESTRICT,
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    selected BOOLEAN NOT NULL DEFAULT TRUE,
    note TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (defendant_id, feature_id)
);

CREATE TABLE IF NOT EXISTS dm_statistical_option_groups (
    group_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_code VARCHAR(100) UNIQUE NOT NULL,
    group_name VARCHAR(255) NOT NULL,
    allow_multiple BOOLEAN NOT NULL DEFAULT FALSE,
    applies_to_entity VARCHAR(100),
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_statistical_options (
    option_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id UUID NOT NULL REFERENCES dm_statistical_option_groups(group_id) ON DELETE CASCADE,
    option_code VARCHAR(100) NOT NULL,
    option_name VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    UNIQUE (group_id, option_code)
);

CREATE TABLE IF NOT EXISTS defendant_statistical_option_values (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defendant_id UUID NOT NULL REFERENCES defendants(defendant_id) ON DELETE CASCADE,
    group_id UUID NOT NULL REFERENCES dm_statistical_option_groups(group_id) ON DELETE RESTRICT,
    option_id UUID NOT NULL REFERENCES dm_statistical_options(option_id) ON DELETE RESTRICT,
    case_id UUID REFERENCES case_files(case_id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (defendant_id, option_id)
);

CREATE OR REPLACE FUNCTION enforce_defendant_statistical_option_group()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_allow_multiple BOOLEAN;
BEGIN
    SELECT allow_multiple
    INTO v_allow_multiple
    FROM dm_statistical_option_groups
    WHERE group_id = NEW.group_id;

    IF NOT EXISTS (
        SELECT 1
        FROM dm_statistical_options
        WHERE option_id = NEW.option_id
          AND group_id = NEW.group_id
    ) THEN
        RAISE EXCEPTION 'statistical option % does not belong to group %', NEW.option_id, NEW.group_id;
    END IF;

    IF v_allow_multiple IS FALSE AND EXISTS (
        SELECT 1
        FROM defendant_statistical_option_values existing
        WHERE existing.defendant_id = NEW.defendant_id
          AND existing.group_id = NEW.group_id
          AND existing.id <> COALESCE(NEW.id, uuid_nil())
    ) THEN
        RAISE EXCEPTION 'defendant % already has a value for single-select group %', NEW.defendant_id, NEW.group_id;
    END IF;

    RETURN NEW;
END $$;

DO $$
BEGIN
    CREATE TRIGGER trg_defendant_statistical_option_group
    BEFORE INSERT OR UPDATE ON defendant_statistical_option_values
    FOR EACH ROW EXECUTE FUNCTION enforce_defendant_statistical_option_group();
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

CREATE TABLE IF NOT EXISTS dm_legal_relationships (
    legal_relationship_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    relationship_code VARCHAR(150) UNIQUE NOT NULL,
    relationship_name VARCHAR(255) NOT NULL,
    case_type_scope VARCHAR(100),
    parent_id UUID REFERENCES dm_legal_relationships(legal_relationship_id) ON DELETE RESTRICT,
    legal_basis TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS case_legal_relationships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    legal_relationship_id UUID NOT NULL REFERENCES dm_legal_relationships(legal_relationship_id) ON DELETE RESTRICT,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    note TEXT,
    UNIQUE (case_id, legal_relationship_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_case_legal_relationship_primary
    ON case_legal_relationships(case_id)
    WHERE is_primary IS TRUE;

CREATE TABLE IF NOT EXISTS dm_trial_result_types (
    trial_result_type_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    result_code VARCHAR(100) UNIQUE NOT NULL,
    result_name VARCHAR(255) NOT NULL,
    case_type_scope VARCHAR(100),
    stage_scope VARCHAR(100),
    affects_kpi BOOLEAN NOT NULL DEFAULT TRUE,
    is_final_result BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS decision_result_attributes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    decision_id UUID NOT NULL REFERENCES decisions(decision_id) ON DELETE CASCADE,
    statistical_indicator_id UUID NOT NULL REFERENCES statistical_indicators(statistical_indicator_id) ON DELETE RESTRICT,
    option_id UUID NOT NULL REFERENCES statistical_indicator_options(option_id) ON DELETE RESTRICT,
    UNIQUE (decision_id, statistical_indicator_id, option_id)
);

CREATE TABLE IF NOT EXISTS dm_appellate_result_codes (
    appellate_result_code_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    result_code VARCHAR(100) UNIQUE NOT NULL,
    result_name VARCHAR(255) NOT NULL,
    is_cancelled BOOLEAN NOT NULL DEFAULT FALSE,
    is_modified BOOLEAN NOT NULL DEFAULT FALSE,
    is_upheld BOOLEAN NOT NULL DEFAULT FALSE,
    is_withdrawn BOOLEAN NOT NULL DEFAULT FALSE,
    requires_fault_classification BOOLEAN NOT NULL DEFAULT FALSE,
    affects_quality_kpi BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_fault_classifications (
    fault_classification_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    classification_code VARCHAR(100) UNIQUE NOT NULL,
    classification_name VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_fault_reason_groups (
    fault_reason_group_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reason_code VARCHAR(100) UNIQUE NOT NULL,
    reason_name VARCHAR(255) NOT NULL,
    classification_scope VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_appeal_protest_types (
    appeal_protest_type_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type_code VARCHAR(100) UNIQUE NOT NULL,
    type_name VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dm_statistical_forms (
    form_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_code VARCHAR(100) UNIQUE NOT NULL,
    form_name VARCHAR(255) NOT NULL,
    case_type_scope VARCHAR(100),
    report_period_type VARCHAR(100),
    legal_basis TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS dm_statistical_metrics (
    metric_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    metric_code VARCHAR(100) UNIQUE NOT NULL,
    metric_name VARCHAR(255) NOT NULL,
    metric_group VARCHAR(100),
    value_type VARCHAR(50) NOT NULL DEFAULT 'numeric',
    aggregation_method VARCHAR(50) NOT NULL DEFAULT 'sum',
    formula TEXT,
    legal_basis TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS dm_statistical_form_items (
    form_item_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_id UUID NOT NULL REFERENCES dm_statistical_forms(form_id) ON DELETE CASCADE,
    item_code VARCHAR(150) NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    parent_item_id UUID REFERENCES dm_statistical_form_items(form_item_id) ON DELETE RESTRICT,
    metric_code VARCHAR(100),
    metric_id UUID REFERENCES dm_statistical_metrics(metric_id) ON DELETE RESTRICT,
    input_control_type VARCHAR(50),
    source_table VARCHAR(100),
    source_field VARCHAR(100),
    formula_ref VARCHAR(255),
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (form_id, item_code)
);

-- ---------------------------------------------------------------------
-- Phase 3: nullable FK columns on business tables. Legacy text/code is kept.
-- Existing migration 003 may already have generic *_id columns; new names are
-- used where reusing the same column would conflict with dm_category_items FK.
-- ---------------------------------------------------------------------

ALTER TABLE IF EXISTS charges
    ADD COLUMN IF NOT EXISTS crime_id UUID,
    ADD COLUMN IF NOT EXISTS article_id UUID;

ALTER TABLE IF EXISTS decisions
    ADD COLUMN IF NOT EXISTS trial_result_type_id UUID;

ALTER TABLE IF EXISTS appellate_trackings
    ADD COLUMN IF NOT EXISTS final_result_code_id UUID,
    ADD COLUMN IF NOT EXISTS appeal_protest_type_catalog_id UUID,
    ADD COLUMN IF NOT EXISTS fault_classification_catalog_id UUID;

ALTER TABLE IF EXISTS appellate_fault_assessments
    ADD COLUMN IF NOT EXISTS fault_classification_catalog_id UUID,
    ADD COLUMN IF NOT EXISTS fault_reason_group_catalog_id UUID;

ALTER TABLE IF EXISTS statistics_snapshots
    ADD COLUMN IF NOT EXISTS metric_id UUID,
    ADD COLUMN IF NOT EXISTS form_item_id UUID;

ALTER TABLE IF EXISTS kpi_metrics
    ADD COLUMN IF NOT EXISTS statistical_metric_id UUID;

DO $$
BEGIN
    IF to_regclass('charges') IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_charges_crime_id_dm_crimes') THEN
            ALTER TABLE charges ADD CONSTRAINT fk_charges_crime_id_dm_crimes
                FOREIGN KEY (crime_id) REFERENCES dm_crimes(crime_id) ON DELETE RESTRICT;
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_charges_article_id_dm_penal_code_articles') THEN
            ALTER TABLE charges ADD CONSTRAINT fk_charges_article_id_dm_penal_code_articles
                FOREIGN KEY (article_id) REFERENCES dm_penal_code_articles(article_id) ON DELETE RESTRICT;
        END IF;
    END IF;

    IF to_regclass('decisions') IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_decisions_trial_result_type') THEN
            ALTER TABLE decisions ADD CONSTRAINT fk_decisions_trial_result_type
                FOREIGN KEY (trial_result_type_id) REFERENCES dm_trial_result_types(trial_result_type_id) ON DELETE RESTRICT;
        END IF;
    END IF;

    IF to_regclass('appellate_trackings') IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_trackings_final_result_code') THEN
            ALTER TABLE appellate_trackings ADD CONSTRAINT fk_appellate_trackings_final_result_code
                FOREIGN KEY (final_result_code_id) REFERENCES dm_appellate_result_codes(appellate_result_code_id) ON DELETE RESTRICT;
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_trackings_appeal_protest_type_catalog') THEN
            ALTER TABLE appellate_trackings ADD CONSTRAINT fk_appellate_trackings_appeal_protest_type_catalog
                FOREIGN KEY (appeal_protest_type_catalog_id) REFERENCES dm_appeal_protest_types(appeal_protest_type_id) ON DELETE RESTRICT;
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_trackings_fault_classification_catalog') THEN
            ALTER TABLE appellate_trackings ADD CONSTRAINT fk_appellate_trackings_fault_classification_catalog
                FOREIGN KEY (fault_classification_catalog_id) REFERENCES dm_fault_classifications(fault_classification_id) ON DELETE RESTRICT;
        END IF;
    END IF;

    IF to_regclass('appellate_fault_assessments') IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_fault_classification_catalog') THEN
            ALTER TABLE appellate_fault_assessments ADD CONSTRAINT fk_appellate_fault_classification_catalog
                FOREIGN KEY (fault_classification_catalog_id) REFERENCES dm_fault_classifications(fault_classification_id) ON DELETE RESTRICT;
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_appellate_fault_reason_group_catalog') THEN
            ALTER TABLE appellate_fault_assessments ADD CONSTRAINT fk_appellate_fault_reason_group_catalog
                FOREIGN KEY (fault_reason_group_catalog_id) REFERENCES dm_fault_reason_groups(fault_reason_group_id) ON DELETE RESTRICT;
        END IF;
    END IF;

    IF to_regclass('statistics_snapshots') IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_statistics_snapshots_metric_catalog') THEN
            ALTER TABLE statistics_snapshots ADD CONSTRAINT fk_statistics_snapshots_metric_catalog
                FOREIGN KEY (metric_id) REFERENCES dm_statistical_metrics(metric_id) ON DELETE RESTRICT;
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_statistics_snapshots_form_item') THEN
            ALTER TABLE statistics_snapshots ADD CONSTRAINT fk_statistics_snapshots_form_item
                FOREIGN KEY (form_item_id) REFERENCES dm_statistical_form_items(form_item_id) ON DELETE RESTRICT;
        END IF;
    END IF;

    IF to_regclass('kpi_metrics') IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_kpi_metrics_statistical_metric') THEN
            ALTER TABLE kpi_metrics ADD CONSTRAINT fk_kpi_metrics_statistical_metric
                FOREIGN KEY (statistical_metric_id) REFERENCES dm_statistical_metrics(metric_id) ON DELETE RESTRICT;
        END IF;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_defendant_stat_features_defendant ON defendant_statistical_features(defendant_id);
CREATE INDEX IF NOT EXISTS idx_defendant_stat_features_feature ON defendant_statistical_features(feature_id);
CREATE INDEX IF NOT EXISTS idx_defendant_stat_option_values_defendant ON defendant_statistical_option_values(defendant_id);
CREATE INDEX IF NOT EXISTS idx_case_legal_relationships_case ON case_legal_relationships(case_id);
CREATE INDEX IF NOT EXISTS idx_case_legal_relationships_relationship ON case_legal_relationships(legal_relationship_id);
CREATE INDEX IF NOT EXISTS idx_dm_statistical_form_items_form ON dm_statistical_form_items(form_id, sort_order);

DO $$
BEGIN
    IF to_regclass('charges') IS NOT NULL THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_charges_crime_id ON charges(crime_id)';
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_charges_article_id ON charges(article_id)';
    END IF;
    IF to_regclass('decisions') IS NOT NULL THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_decisions_trial_result_type ON decisions(trial_result_type_id)';
    END IF;
    IF to_regclass('appellate_trackings') IS NOT NULL THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_appellate_trackings_final_result_code_id ON appellate_trackings(final_result_code_id)';
    END IF;
    IF to_regclass('statistics_snapshots') IS NOT NULL THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_statistics_snapshots_metric_id ON statistics_snapshots(metric_id)';
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_statistics_snapshots_form_item_id ON statistics_snapshots(form_item_id)';
    END IF;
END $$;
