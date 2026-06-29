import { z } from 'zod';
import { pool } from '../database/pool.js';
import type {
  StatisticalFormDefinition,
  StatisticalFormulaDefinition
} from './statistical-form-config.js';
import { getStatisticalForm } from './statistical-form-config.js';

const isoDateSchema = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Ngay phai co dinh dang YYYY-MM-DD');

export const statisticalReportQuerySchema = z.object({
  from_date: isoDateSchema,
  to_date: isoDateSchema,
  court_id: z.string().uuid().optional()
}).superRefine((value, context) => {
  if (value.from_date > value.to_date) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ['to_date'], message: 'from_date phai nho hon hoac bang to_date' });
  }
});

export type StatisticalReportQuery = z.infer<typeof statisticalReportQuerySchema>;

export type StatisticalCellStatus = 'source' | 'formula' | 'unmapped' | 'deferred';

export type StatisticalCell = {
  column: number;
  code: string;
  value: number | null;
  status: StatisticalCellStatus;
  sourceTables: string[];
  sourceRecordIds: string[];
  sourceGrain?: string;
  formulaRef?: string;
  formula?: string;
  reason?: string;
};

export type StatisticalReport = {
  form: StatisticalFormDefinition;
  query: StatisticalReportQuery;
  cells: Record<string, StatisticalCell>;
  status: 'complete' | 'incomplete' | 'invalid';
  validations: Array<{ code: string; severity: 'WARNING' | 'ERROR'; message: string; columns?: string[] }>;
  unmappedCells: string[];
  generatedAt: string;
};

type SourceCell = Omit<StatisticalCell, 'column' | 'code' | 'status'>;
export type SourceCellMap = Record<string, SourceCell>;

function cellCode(column: number) {
  return `C${column}`;
}

function evaluateExpression(expression: string, cells: Record<string, StatisticalCell>) {
  const tokens = expression.match(/C\d+|[+-]/g);
  if (!tokens?.length) throw new Error(`Unsupported formula: ${expression}`);
  let total = 0;
  let operator = 1;
  for (const token of tokens) {
    if (token === '+') { operator = 1; continue; }
    if (token === '-') { operator = -1; continue; }
    const value = cells[token]?.value;
    if (value === null || value === undefined) return null;
    total += operator * value;
  }
  return total;
}

export function calculateMappedCells(
  form: StatisticalFormDefinition,
  sourceCells: SourceCellMap
) {
  const formulaTargets = new Map<number, StatisticalFormulaDefinition>(form.formulas.map((formula) => [formula.target, formula]));
  const cells: Record<string, StatisticalCell> = {};
  for (let column = 2; column <= form.workbook_column_count; column += 1) {
    const code = cellCode(column);
    if (form.deferred_columns.includes(column)) {
      cells[code] = { column, code, value: null, status: 'deferred', sourceTables: [], sourceRecordIds: [], reason: 'Cot phat sinh ngoai pham vi giai doan hien tai' };
      continue;
    }
    const source = sourceCells[code];
    if (source) {
      cells[code] = { column, code, status: 'source', ...source };
      continue;
    }
    const formula = formulaTargets.get(column);
    cells[code] = {
      column,
      code,
      value: null,
      status: 'unmapped',
      sourceTables: [],
      sourceRecordIds: [],
      formulaRef: formula?.formula_ref,
      formula: formula?.expression,
      reason: formula ? 'Chua du toan hang co nguon de tinh cong thuc' : 'Chua co mapping nguon duoc duyet'
    };
  }

  for (let pass = 0; pass < form.formulas.length; pass += 1) {
    let changed = false;
    for (const formula of form.formulas) {
      const code = cellCode(formula.target);
      if (cells[code]?.status === 'formula') continue;
      const dependenciesReady = formula.dependencies.every((column) => {
        const dependency = cells[cellCode(column)];
        return dependency && dependency.value !== null && dependency.status !== 'deferred';
      });
      if (!dependenciesReady) continue;
      const value = evaluateExpression(formula.expression, cells);
      if (value === null) continue;
      cells[code] = {
        column: formula.target,
        code,
        value,
        status: 'formula',
        sourceTables: [...new Set(formula.dependencies.flatMap((column) => cells[cellCode(column)].sourceTables))],
        sourceRecordIds: [...new Set(formula.dependencies.flatMap((column) => cells[cellCode(column)].sourceRecordIds))],
        sourceGrain: 'formula_from_mapped_cells',
        formulaRef: formula.formula_ref,
        formula: formula.expression
      };
      changed = true;
    }
    if (!changed) break;
  }
  return cells;
}

function sourceCell(value: number, sourceTables: string[], sourceRecordIds: string[], sourceGrain: string): SourceCell {
  return { value, sourceTables, sourceRecordIds, sourceGrain };
}

function courtFilter(alias: string, courtId: string | undefined, values: unknown[]) {
  if (!courtId) return '';
  values.push(courtId);
  return ` and ${alias}.court_id = $${values.length}`;
}

async function caseIdsByPeriod(form: StatisticalFormDefinition, query: StatisticalReportQuery) {
  const values: unknown[] = [query.from_date, query.to_date, form.case_type, form.trial_level];
  const courtSql = courtFilter('c', query.court_id, values);
  const result = await pool.query<{ case_id: string; bucket: 'old' | 'new' }>(
    `select c.case_id,
            case when c.acceptance_date < $1::date then 'old' else 'new' end as bucket
     from case_files c
     where c.case_type = $3
       and c.case_group = $4
       and c.acceptance_date is not null
       and (
         (c.acceptance_date < $1::date and (c.closed_date is null or c.closed_date >= $1::date))
         or c.acceptance_date between $1::date and $2::date
       )${courtSql}`,
    values
  );
  return {
    old: result.rows.filter((row) => row.bucket === 'old').map((row) => row.case_id),
    new: result.rows.filter((row) => row.bucket === 'new').map((row) => row.case_id)
  };
}

async function decisionResults(form: StatisticalFormDefinition, query: StatisticalReportQuery) {
  const values: unknown[] = [query.from_date, query.to_date, form.case_type, form.trial_level];
  const courtSql = courtFilter('c', query.court_id, values);
  const result = await pool.query<{ case_id: string; result_code: string }>(
    `select distinct on (c.case_id) c.case_id, rt.result_code
     from case_files c
     join decisions d on d.case_id = c.case_id
     join dm_trial_result_types rt on rt.trial_result_type_id = d.trial_result_type_id
     where c.case_type = $3
       and c.case_group = $4
       and d.decision_date between $1::date and $2::date${courtSql}
     order by c.case_id, d.decision_date desc, d.decision_id desc`,
    values
  );
  return result.rows;
}

async function recognizedAgreementCaseIds(form: StatisticalFormDefinition, query: StatisticalReportQuery) {
  if (form.case_type === 'administrative' || form.case_type === 'criminal') return [];
  const values: unknown[] = [query.from_date, query.to_date, form.case_type, form.trial_level];
  const courtSql = courtFilter('c', query.court_id, values);
  const result = await pool.query<{ case_id: string }>(
    `select distinct c.case_id
     from case_files c
     join civil_case_details cd on cd.case_id = c.case_id
     join mediation_sessions ms on ms.civil_detail_id = cd.civil_detail_id
     where c.case_type = $3
       and c.case_group = $4
       and ms.recognized_by_court is true
       and ms.mediation_date between $1::date and $2::date${courtSql}`,
    values
  );
  return result.rows.map((row) => row.case_id);
}

function idsForResult(rows: Array<{ case_id: string; result_code: string }>, codes: string[]) {
  return [...new Set(rows.filter((row) => codes.includes(row.result_code)).map((row) => row.case_id))];
}

async function genericFirstInstanceSources(form: StatisticalFormDefinition, query: StatisticalReportQuery) {
  const [period, decisions, agreements] = await Promise.all([
    caseIdsByPeriod(form, query),
    decisionResults(form, query),
    recognizedAgreementCaseIds(form, query)
  ]);
  const suspended = idsForResult(decisions, ['suspended']);
  const agreementSet = new Set(agreements);
  const rejected = idsForResult(decisions, ['rejected_claim']).filter((id) => !agreementSet.has(id));
  const partial = idsForResult(decisions, ['partially_accepted_claim']).filter((id) => !agreementSet.has(id));
  const accepted = idsForResult(decisions, ['accepted_claim']).filter((id) => !agreementSet.has(id));
  const tried = [...new Set([...rejected, ...partial, ...accepted])];
  const sources: SourceCellMap = {
    C2: sourceCell(period.old.length, ['case_files'], period.old, 'case_id'),
    C3: sourceCell(period.new.length, ['case_files'], period.new, 'case_id')
  };

  if (form.source_profile === 'civil_first_instance') {
    sources.C7 = sourceCell(suspended.length, ['decisions', 'dm_trial_result_types'], suspended, 'case_id');
    sources.C8 = sourceCell(agreements.length, ['mediation_sessions'], agreements, 'case_id');
    sources.C9 = sourceCell(tried.length, ['decisions', 'dm_trial_result_types'], tried, 'case_id');
  } else if (form.source_profile === 'marriage_first_instance') {
    sources.C7 = sourceCell(suspended.length, ['decisions', 'dm_trial_result_types'], suspended, 'case_id');
    sources.C9 = sourceCell(agreements.length, ['mediation_sessions'], agreements, 'case_id');
    sources.C10 = sourceCell(rejected.length, ['decisions', 'dm_trial_result_types'], rejected, 'case_id');
    const acceptedAny = [...new Set([...partial, ...accepted])];
    sources.C13 = sourceCell(acceptedAny.length, ['decisions', 'dm_trial_result_types'], acceptedAny, 'case_id');
  } else if (form.source_profile === 'administrative_first_instance') {
    sources.C10 = sourceCell(rejected.length, ['decisions', 'dm_trial_result_types'], rejected, 'case_id');
    sources.C11 = sourceCell(partial.length, ['decisions', 'dm_trial_result_types'], partial, 'case_id');
    sources.C12 = sourceCell(accepted.length, ['decisions', 'dm_trial_result_types'], accepted, 'case_id');
  } else {
    sources.C7 = sourceCell(suspended.length, ['decisions', 'dm_trial_result_types'], suspended, 'case_id');
    sources.C8 = sourceCell(agreements.length, ['mediation_sessions'], agreements, 'case_id');
    sources.C9 = sourceCell(rejected.length, ['decisions', 'dm_trial_result_types'], rejected, 'case_id');
    sources.C10 = sourceCell(partial.length, ['decisions', 'dm_trial_result_types'], partial, 'case_id');
    sources.C11 = sourceCell(accepted.length, ['decisions', 'dm_trial_result_types'], accepted, 'case_id');
  }
  return sources;
}

async function defendantIdsForCases(caseIds: string[]) {
  if (!caseIds.length) return [];
  const result = await pool.query<{ defendant_id: string }>(
    `select d.defendant_id
     from defendants d
     join criminal_case_details cd on cd.criminal_detail_id = d.criminal_detail_id
     where cd.case_id = any($1::uuid[])`,
    [caseIds]
  );
  return result.rows.map((row) => row.defendant_id);
}

async function criminalFirstInstanceSources(form: StatisticalFormDefinition, query: StatisticalReportQuery) {
  const [period, decisions] = await Promise.all([caseIdsByPeriod(form, query), decisionResults(form, query)]);
  const [oldDefendants, newDefendants] = await Promise.all([
    defendantIdsForCases(period.old),
    defendantIdsForCases(period.new)
  ]);
  const suspendedCases = idsForResult(decisions, ['suspended']);
  const triedCases = idsForResult(decisions, ['accepted_claim', 'partially_accepted_claim', 'rejected_claim']);
  const [suspendedDefendants, triedDefendants] = await Promise.all([
    defendantIdsForCases(suspendedCases),
    defendantIdsForCases(triedCases)
  ]);
  const values: unknown[] = [query.from_date, query.to_date];
  if (query.court_id) values.push(query.court_id);
  const returnResult = await pool.query<{ resolution_event_id: string; case_id: string }>(
    `select re.resolution_event_id, re.case_id
     from case_resolution_events re
     join case_files c on c.case_id = re.case_id
     where c.case_type = 'criminal'
       and c.case_group = 'SO_THAM'
       and re.resolution_type_code = 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION'
       and re.counted_as_resolved is true
       and re.event_date between $1::date and $2::date${query.court_id ? ' and c.court_id = $3' : ''}`,
    values
  );
  const returnDefendantResult = returnResult.rows.length
    ? await pool.query<{ trace_id: string }>(
        `select re.resolution_event_id::text || ':' || d.defendant_id::text as trace_id
         from case_resolution_events re
         join criminal_case_details cd on cd.case_id = re.case_id
         join defendants d on d.criminal_detail_id = cd.criminal_detail_id
         where re.resolution_event_id = any($1::uuid[])`,
        [returnResult.rows.map((row) => row.resolution_event_id)]
      )
    : { rows: [] as Array<{ trace_id: string }> };
  return {
    C3: sourceCell(period.old.length, ['case_files'], period.old, 'case_id'),
    C4: sourceCell(oldDefendants.length, ['case_files', 'criminal_case_details', 'defendants'], oldDefendants, 'defendant_id'),
    C5: sourceCell(period.new.length, ['case_files'], period.new, 'case_id'),
    C6: sourceCell(newDefendants.length, ['case_files', 'criminal_case_details', 'defendants'], newDefendants, 'defendant_id'),
    C11: sourceCell(suspendedCases.length, ['decisions', 'dm_trial_result_types'], suspendedCases, 'case_id'),
    C12: sourceCell(suspendedDefendants.length, ['decisions', 'defendants'], suspendedDefendants, 'defendant_id'),
    C13: sourceCell(returnResult.rows.length, ['case_resolution_events'], returnResult.rows.map((row) => row.resolution_event_id), 'occurrence_resolution_event'),
    C14: sourceCell(returnDefendantResult.rows.length, ['case_resolution_events', 'defendants'], returnDefendantResult.rows.map((row) => row.trace_id), 'resolution_event_id + defendant_id'),
    C16: sourceCell(triedCases.length, ['decisions', 'dm_trial_result_types'], triedCases, 'case_id'),
    C17: sourceCell(triedDefendants.length, ['decisions', 'defendants'], triedDefendants, 'defendant_id')
  } satisfies SourceCellMap;
}

async function appellateTrackingRows(form: StatisticalFormDefinition, query: StatisticalReportQuery) {
  const values: unknown[] = [query.from_date, query.to_date, form.case_type];
  if (query.court_id) values.push(query.court_id);
  const result = await pool.query<{
    appellate_tracking_id: string;
    appeal_protest_type: 'APPEAL' | 'PROTEST' | 'BOTH';
    upper_court_acceptance_date: string;
    resolved_date: string | null;
    result_code: string | null;
    is_upheld: boolean | null;
    is_modified: boolean | null;
    is_cancelled: boolean | null;
    is_withdrawn: boolean | null;
  }>(
    `select at.appellate_tracking_id, at.appeal_protest_type,
            at.upper_court_acceptance_date, at.resolved_date,
            rc.result_code, rc.is_upheld, rc.is_modified, rc.is_cancelled, rc.is_withdrawn
     from appellate_trackings at
     left join dm_appellate_result_codes rc on rc.result_code = at.final_result_code
     where at.case_type = $3
       and at.upper_court_acceptance_date is not null
       and at.upper_court_acceptance_date <= $2::date
       and (at.resolved_date is null or at.resolved_date >= $1::date)${query.court_id ? ' and at.upper_court_id = $4' : ''}`,
    values
  );
  return result.rows;
}

function trackingBucket(type: 'APPEAL' | 'PROTEST' | 'BOTH') {
  return type === 'APPEAL' ? 'appeal' : 'protest';
}

async function genericAppellateSources(form: StatisticalFormDefinition, query: StatisticalReportQuery) {
  const rows = await appellateTrackingRows(form, query);
  const ids = (predicate: (row: typeof rows[number]) => boolean) => rows.filter(predicate).map((row) => row.appellate_tracking_id);
  const old = (bucket: string) => ids((row) => row.upper_court_acceptance_date < query.from_date && trackingBucket(row.appeal_protest_type) === bucket);
  const fresh = (bucket: string) => ids((row) => row.upper_court_acceptance_date >= query.from_date && trackingBucket(row.appeal_protest_type) === bucket);
  const resolved = (bucket: string, kind: 'withdrawn' | 'terminated' | 'tried') => ids((row) => {
    if (!row.resolved_date || row.resolved_date < query.from_date || row.resolved_date > query.to_date) return false;
    if (trackingBucket(row.appeal_protest_type) !== bucket) return false;
    if (kind === 'withdrawn') return row.is_withdrawn === true;
    if (kind === 'terminated') return row.result_code === 'terminated';
    return row.is_upheld === true || row.is_modified === true || row.is_cancelled === true;
  });
  const oldAppeal = old('appeal');
  const oldProtest = old('protest');
  const newAppeal = fresh('appeal');
  const newProtest = fresh('protest');
  const withdrawnAppeal = resolved('appeal', 'withdrawn');
  const withdrawnProtest = resolved('protest', 'withdrawn');
  const terminatedAppeal = resolved('appeal', 'terminated');
  const terminatedProtest = resolved('protest', 'terminated');
  const triedAppeal = resolved('appeal', 'tried');
  const triedProtest = resolved('protest', 'tried');
  const upheld = ids((row) => Boolean(row.resolved_date && row.resolved_date >= query.from_date && row.resolved_date <= query.to_date && row.is_upheld));
  const tracked = (recordIds: string[]) => sourceCell(recordIds.length, ['appellate_trackings', 'dm_appellate_result_codes'], recordIds, 'appellate_tracking_id');
  return {
    C2: tracked(oldAppeal), C3: tracked(oldProtest), C4: tracked(newAppeal), C5: tracked(newProtest),
    C9: tracked(withdrawnAppeal), C10: tracked(withdrawnProtest),
    C11: tracked(terminatedAppeal), C12: tracked(terminatedProtest),
    C14: tracked(triedAppeal), C15: tracked(triedProtest), C29: tracked(upheld)
  } satisfies SourceCellMap;
}

async function criminalAppellateSources(form: StatisticalFormDefinition, query: StatisticalReportQuery) {
  const tracking = await appellateTrackingRows(form, query);
  const trackingIds = (bucket: 'appeal' | 'protest', old: boolean) => tracking
    .filter((row) => trackingBucket(row.appeal_protest_type) === bucket && (row.upper_court_acceptance_date < query.from_date) === old)
    .map((row) => row.appellate_tracking_id);
  const values: unknown[] = [query.from_date, query.to_date];
  if (query.court_id) values.push(query.court_id);
  const result = await pool.query<{
    appellate_result_id: string;
    case_id: string;
    defendant_id: string;
    appeal_protest_scope_code: string | null;
    result_group_code: string;
    result_type_code: string;
    counted_as_case_resolved: boolean | null;
    counted_as_defendant_resolved: boolean;
  }>(
    `select r.appellate_result_id, r.case_id, r.defendant_id,
            r.appeal_protest_scope_code, r.result_group_code, r.result_type_code,
            r.counted_as_case_resolved, r.counted_as_defendant_resolved
     from criminal_appellate_defendant_results r
     join case_files c on c.case_id = r.case_id
     where c.case_type = 'criminal'
       and c.case_group = 'PHUC_THAM'
       and r.is_final_result is true
       and r.result_date between $1::date and $2::date${query.court_id ? ' and c.court_id = $3' : ''}`,
    values
  );
  const scope = (row: typeof result.rows[number]) => row.appeal_protest_scope_code === 'APPEAL' ? 'appeal' : 'protest';
  const classifiedIds = (bucket: 'appeal' | 'protest', group: 'withdrawn' | 'terminated' | 'trial', entity: 'case' | 'defendant') => {
    const filtered = result.rows.filter((row) => {
      if (scope(row) !== bucket) return false;
      if (entity === 'case' && row.counted_as_case_resolved !== true) return false;
      if (entity === 'defendant' && row.counted_as_defendant_resolved !== true) return false;
      if (group === 'withdrawn') return row.result_type_code.startsWith('WITHDRAWAL_');
      if (group === 'terminated') return row.result_group_code === 'TERMINATION' && !row.result_type_code.startsWith('WITHDRAWAL_');
      return row.result_group_code === 'TRIAL';
    });
    return [...new Set(filtered.map((row) => entity === 'case' ? row.case_id : row.appellate_result_id))];
  };
  const trackingCell = (ids: string[]) => sourceCell(ids.length, ['appellate_trackings'], ids, 'appellate_tracking_id');
  const resultCell = (ids: string[], grain: string) => sourceCell(ids.length, ['criminal_appellate_defendant_results'], ids, grain);
  return {
    C3: trackingCell(trackingIds('protest', true)), C5: trackingCell(trackingIds('appeal', true)),
    C7: trackingCell(trackingIds('protest', false)), C9: trackingCell(trackingIds('appeal', false)),
    C16: resultCell(classifiedIds('protest', 'withdrawn', 'case'), 'case_id'),
    C17: resultCell(classifiedIds('protest', 'withdrawn', 'defendant'), 'defendant_result_id'),
    C18: resultCell(classifiedIds('appeal', 'withdrawn', 'case'), 'case_id'),
    C19: resultCell(classifiedIds('appeal', 'withdrawn', 'defendant'), 'defendant_result_id'),
    C20: resultCell(classifiedIds('protest', 'terminated', 'case'), 'case_id'),
    C21: resultCell(classifiedIds('protest', 'terminated', 'defendant'), 'defendant_result_id'),
    C22: resultCell(classifiedIds('appeal', 'terminated', 'case'), 'case_id'),
    C23: resultCell(classifiedIds('appeal', 'terminated', 'defendant'), 'defendant_result_id'),
    C24: resultCell(classifiedIds('protest', 'trial', 'case'), 'case_id'),
    C25: resultCell(classifiedIds('protest', 'trial', 'defendant'), 'defendant_result_id'),
    C26: resultCell(classifiedIds('appeal', 'trial', 'case'), 'case_id'),
    C27: resultCell(classifiedIds('appeal', 'trial', 'defendant'), 'defendant_result_id')
  } satisfies SourceCellMap;
}

export async function getSourceCells(form: StatisticalFormDefinition, query: StatisticalReportQuery) {
  if (form.source_profile === 'criminal_first_instance') return criminalFirstInstanceSources(form, query);
  if (form.source_profile === 'criminal_appellate') return criminalAppellateSources(form, query);
  if (form.source_profile === 'generic_appellate') return genericAppellateSources(form, query);
  return genericFirstInstanceSources(form, query);
}

export async function calculateStatisticalReport(formCode: string, query: StatisticalReportQuery) {
  const form = getStatisticalForm(formCode);
  const sourceCells = await getSourceCells(form, query);
  const cells = calculateMappedCells(form, sourceCells);
  const validations: StatisticalReport['validations'] = [];
  for (const cell of Object.values(cells)) {
    if (cell.value !== null && cell.value < 0) {
      validations.push({ code: 'NEGATIVE_VALUE', severity: 'ERROR', message: `${cell.code} co gia tri am`, columns: [cell.code] });
    }
  }
  const unmappedCells = Object.values(cells)
    .filter((cell) => cell.column <= form.guide_column_count && cell.status === 'unmapped')
    .map((cell) => cell.code);
  if (unmappedCells.length) {
    validations.push({
      code: 'UNMAPPED_SOURCE_CELLS',
      severity: 'WARNING',
      message: 'Mot so cot trong pham vi chua co nguon duoc duyet; de trong, khong ghi 0.',
      columns: unmappedCells
    });
  }
  validations.push({
    code: 'ROW_BREAKDOWN_DEFERRED',
    severity: 'WARNING',
    message: 'Giai doan nay ghi tong cong; phan ra day du theo danh muc dong can catalog nguon hoan chinh.'
  });
  const status: StatisticalReport['status'] = validations.some((item) => item.severity === 'ERROR')
    ? 'invalid'
    : 'incomplete';
  return {
    form,
    query,
    cells,
    status,
    validations,
    unmappedCells,
    generatedAt: new Date().toISOString()
  } satisfies StatisticalReport;
}
