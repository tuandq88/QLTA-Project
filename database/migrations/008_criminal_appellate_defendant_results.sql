-- Migration 008: criminal appellate defendant-level result model.
-- Purpose: store final appellate results per defendant, not only per case.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS criminal_appellate_defendant_results (
    appellate_result_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id UUID NOT NULL REFERENCES case_files(case_id) ON DELETE CASCADE,
    defendant_id UUID NOT NULL REFERENCES defendants(defendant_id) ON DELETE CASCADE,
    appeal_protest_scope_code VARCHAR(100),
    decision_stage_code VARCHAR(50) NOT NULL,
    decision_stage_id UUID,
    result_group_code VARCHAR(50) NOT NULL,
    result_group_id UUID,
    result_type_code VARCHAR(100) NOT NULL,
    result_type_id UUID,
    result_date DATE NOT NULL,
    decision_number VARCHAR(100),
    is_final_result BOOLEAN NOT NULL DEFAULT TRUE,
    counted_as_defendant_resolved BOOLEAN NOT NULL DEFAULT TRUE,
    counted_as_case_resolved BOOLEAN,
    note TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_criminal_appellate_result_stage CHECK (
        decision_stage_code IN ('BEFORE_HEARING', 'AT_HEARING', 'AFTER_HEARING')
    ),
    CONSTRAINT chk_criminal_appellate_result_group CHECK (
        result_group_code IN ('TERMINATION', 'TRIAL')
    ),
    CONSTRAINT chk_criminal_appellate_result_type CHECK (
        result_type_code IN (
            'WITHDRAWAL_BEFORE_HEARING',
            'WITHDRAWAL_AT_HEARING',
            'OTHER_TERMINATION',
            'UPHOLD_FIRST_INSTANCE',
            'MODIFY_FIRST_INSTANCE_SUBJECTIVE',
            'MODIFY_FIRST_INSTANCE_OBJECTIVE',
            'CANCEL_FIRST_INSTANCE_SUBJECTIVE',
            'CANCEL_FIRST_INSTANCE_OBJECTIVE'
        )
    ),
    CONSTRAINT chk_criminal_appellate_result_stage_type CHECK (
        (decision_stage_code = 'BEFORE_HEARING' AND result_type_code IN ('WITHDRAWAL_BEFORE_HEARING', 'OTHER_TERMINATION'))
        OR (decision_stage_code = 'AT_HEARING' AND result_type_code IN ('WITHDRAWAL_AT_HEARING', 'OTHER_TERMINATION', 'UPHOLD_FIRST_INSTANCE', 'MODIFY_FIRST_INSTANCE_SUBJECTIVE', 'MODIFY_FIRST_INSTANCE_OBJECTIVE', 'CANCEL_FIRST_INSTANCE_SUBJECTIVE', 'CANCEL_FIRST_INSTANCE_OBJECTIVE'))
        OR (decision_stage_code = 'AFTER_HEARING')
    ),
    CONSTRAINT chk_criminal_appellate_result_group_type CHECK (
        (result_group_code = 'TERMINATION' AND result_type_code IN ('WITHDRAWAL_BEFORE_HEARING', 'WITHDRAWAL_AT_HEARING', 'OTHER_TERMINATION'))
        OR (result_group_code = 'TRIAL' AND result_type_code IN ('UPHOLD_FIRST_INSTANCE', 'MODIFY_FIRST_INSTANCE_SUBJECTIVE', 'MODIFY_FIRST_INSTANCE_OBJECTIVE', 'CANCEL_FIRST_INSTANCE_SUBJECTIVE', 'CANCEL_FIRST_INSTANCE_OBJECTIVE'))
    )
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_criminal_appellate_defendant_final_result
    ON criminal_appellate_defendant_results(case_id, defendant_id)
    WHERE is_final_result IS TRUE;

CREATE TABLE IF NOT EXISTS criminal_appellate_modify_criteria (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appellate_result_id UUID NOT NULL REFERENCES criminal_appellate_defendant_results(appellate_result_id) ON DELETE CASCADE,
    criterion_code VARCHAR(100) NOT NULL,
    criterion_id UUID,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_criminal_appellate_modify_criterion CHECK (
        criterion_code IN (
            'EXEMPT_CRIMINAL_LIABILITY_OR_PENALTY',
            'SUSPENDED_SENTENCE_GRANTED',
            'SUSPENDED_SENTENCE_NOT_GRANTED',
            'REDUCE_PENALTY',
            'CHANGE_TO_LIGHTER_PENALTY',
            'INCREASE_PENALTY',
            'CHANGE_TO_HEAVIER_PENALTY',
            'CHANGE_CHARGE'
        )
    ),
    CONSTRAINT uq_criminal_appellate_modify_criteria UNIQUE (appellate_result_id, criterion_code)
);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cadr_decision_stage_dm_item') THEN
        ALTER TABLE criminal_appellate_defendant_results
            ADD CONSTRAINT fk_cadr_decision_stage_dm_item
            FOREIGN KEY (decision_stage_id) REFERENCES dm_category_items(item_id) ON DELETE RESTRICT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cadr_result_group_dm_item') THEN
        ALTER TABLE criminal_appellate_defendant_results
            ADD CONSTRAINT fk_cadr_result_group_dm_item
            FOREIGN KEY (result_group_id) REFERENCES dm_category_items(item_id) ON DELETE RESTRICT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cadr_result_type_dm_item') THEN
        ALTER TABLE criminal_appellate_defendant_results
            ADD CONSTRAINT fk_cadr_result_type_dm_item
            FOREIGN KEY (result_type_id) REFERENCES dm_category_items(item_id) ON DELETE RESTRICT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_camc_criterion_dm_item') THEN
        ALTER TABLE criminal_appellate_modify_criteria
            ADD CONSTRAINT fk_camc_criterion_dm_item
            FOREIGN KEY (criterion_id) REFERENCES dm_category_items(item_id) ON DELETE RESTRICT;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_criminal_appellate_results_case_date
    ON criminal_appellate_defendant_results(case_id, result_date);
CREATE INDEX IF NOT EXISTS idx_criminal_appellate_results_defendant
    ON criminal_appellate_defendant_results(defendant_id, is_final_result);
CREATE INDEX IF NOT EXISTS idx_criminal_appellate_results_type_date
    ON criminal_appellate_defendant_results(result_type_code, result_date);
CREATE INDEX IF NOT EXISTS idx_criminal_appellate_modify_criteria_result
    ON criminal_appellate_modify_criteria(appellate_result_id);
