import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { pool } from '../database/pool.js';
import { ApiError, ok } from '../common/http.js';
import { requireRoles } from '../common/auth.js';
import { writeAudit } from '../common/audit.js';
import { pageMeta, paginationSchema } from '../common/pagination.js';
import { tableConfigs } from '../common/table-config.js';
import { crudRoutes } from './generic-crud.js';

const caseCreateSchema = z.object({
  court_id: z.string().uuid(),
  case_code: z.string().optional().nullable(),
  case_number: z.string().optional().nullable(),
  case_type: z.enum(['criminal', 'civil', 'administrative', 'marriage_family', 'business_commercial', 'labor', 'other']),
  case_group: z.string().optional().nullable(),
  procedure_law: z.string().optional().nullable(),
  filing_date: z.string().optional().nullable(),
  acceptance_date: z.string().optional().nullable(),
  current_stage: z.string().optional().nullable(),
  case_status: z.enum(['draft', 'accepted', 'in_progress', 'suspended', 'resolved', 'closed', 'overdue']).optional(),
  resolution_status: z.string().optional().nullable(),
  has_foreign_element: z.boolean().optional(),
  is_minor_related: z.boolean().optional(),
  is_confidential: z.boolean().optional(),
  first_instance_court_id: z.string().uuid().optional().nullable(),
  first_instance_case_number: z.string().optional().nullable(),
  first_instance_judgment_number: z.string().optional().nullable(),
  first_instance_judgment_date: z.string().optional().nullable(),
  closed_date: z.string().optional().nullable(),
  summary: z.string().optional().nullable()
});

const worklistQuerySchema = paginationSchema.extend({
  court_id: z.string().uuid().optional(),
  case_type: z.string().optional(),
  case_group: z.string().optional(),
  case_status: z.string().optional(),
  current_stage: z.string().optional(),
  from_date: z.string().optional(),
  to_date: z.string().optional()
});

const nullableText = z.string().trim().optional().nullable();
const nullableDate = z.string().trim().optional().nullable();

const caseIntakeSchema = z.object({
  case: z.object({
    court_id: z.string().uuid(),
    case_code: nullableText,
    case_number: nullableText,
    case_type: z.enum(['criminal', 'civil', 'administrative', 'marriage_family', 'business_commercial', 'labor']),
    case_group: nullableText,
    procedure_law: nullableText,
    filing_date: nullableDate,
    acceptance_date: nullableDate,
    current_stage: nullableText,
    case_status: z.enum(['draft', 'accepted', 'in_progress', 'suspended', 'resolved', 'closed', 'overdue']).default('accepted'),
    resolution_status: nullableText,
    has_foreign_element: z.boolean().optional(),
    is_minor_related: z.boolean().optional(),
    is_confidential: z.boolean().optional(),
    first_instance_court_id: z.string().uuid().optional().nullable(),
    first_instance_case_number: nullableText,
    first_instance_judgment_number: nullableText,
    first_instance_judgment_date: nullableDate,
    summary: nullableText
  }),
  occurrence: z
    .object({
      occurrence_no: z.number().int().positive().default(1),
      acceptance_date: z.string().trim(),
      acceptance_type_code: z.enum(['INITIAL_ACCEPTANCE', 'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION']).default('INITIAL_ACCEPTANCE'),
      source_note: nullableText
    })
    .optional(),
  criminalDetail: z
    .object({
      procuracy_name: nullableText,
      indictment_number: nullableText,
      indictment_date: nullableDate,
      investigation_agency: nullableText,
      dossier_received_date: nullableDate,
      trial_panel_type: nullableText
    })
    .optional(),
  civilDetail: z
    .object({
      civil_category: nullableText,
      dispute_type: nullableText,
      claim_value: z.coerce.number().optional().nullable(),
      jurisdiction_basis: nullableText,
      mediation_result: nullableText,
      court_fee_advance_paid: z.boolean().optional()
    })
    .optional(),
  administrativeDetail: z
    .object({
      lawsuit_type: nullableText,
      defendant_agency_name: nullableText,
      agency_representative: nullableText,
      agency_level: nullableText,
      compensation_amount: z.coerce.number().optional().nullable(),
      jurisdiction_basis: nullableText
    })
    .optional()
});

export async function caseRoutes(app: FastifyInstance) {
  app.get('/cases/worklist', async (request, reply) => {
    const query = worklistQuerySchema.parse(request.query);
    const values: unknown[] = [];
    const where: string[] = [];

    function addFilter(sql: string, value: unknown) {
      if (value === undefined || value === null || value === '') return;
      values.push(value);
      where.push(sql.replace('?', `$${values.length}`));
    }

    addFilter('c.court_id = ?', query.court_id);
    addFilter('c.case_type = ?', query.case_type);
    addFilter('c.case_group = ?', query.case_group);
    addFilter('c.case_status = ?', query.case_status);
    addFilter('c.current_stage = ?', query.current_stage);
    addFilter('c.acceptance_date >= ?', query.from_date);
    addFilter('c.acceptance_date <= ?', query.to_date);

    if (query.search) {
      values.push(`%${query.search}%`);
      where.push(
        `(c.case_code ilike $${values.length}
          or c.case_number ilike $${values.length}
          or c.summary ilike $${values.length}
          or court.court_name ilike $${values.length})`
      );
    }

    const whereSql = where.length ? `where ${where.join(' and ')}` : '';
    const countSql = `
      select count(*)::text as total
      from case_files c
      join courts court on court.court_id = c.court_id
      ${whereSql}
    `;
    const count = await pool.query<{ total: string }>(countSql, values);

    const page = query.page;
    const pageSize = query.pageSize;
    const listValues = [...values, pageSize, (page - 1) * pageSize];
    const result = await pool.query(
      `with participant_counts as (
         select case_id, count(*)::int as participant_count
         from participants
         group by case_id
       ),
       hearing_counts as (
         select case_id, count(*)::int as hearing_count
         from hearings
         group by case_id
       ),
       open_validation_counts as (
         select case_id, count(*)::int as open_validation_count
         from validation_results
         where validation_status = 'open'
         group by case_id
       ),
       occurrence_counts as (
         select case_id, count(*)::int as occurrence_count
         from case_occurrences
         group by case_id
       )
       select c.case_id,
              c.case_code,
              c.case_number,
              c.case_type,
              c.case_group,
              c.procedure_law,
              c.acceptance_date,
              c.current_stage,
              c.case_status,
              c.resolution_status,
              c.closed_date,
              c.updated_at,
              court.court_id,
              court.court_code,
              court.court_name,
              court.court_level,
              coalesce(pc.participant_count, 0) as participant_count,
              coalesce(hc.hearing_count, 0) as hearing_count,
              coalesce(oc.occurrence_count, 0) as occurrence_count,
              coalesce(vc.open_validation_count, 0) as open_validation_count
       from case_files c
       join courts court on court.court_id = c.court_id
       left join participant_counts pc on pc.case_id = c.case_id
       left join hearing_counts hc on hc.case_id = c.case_id
       left join occurrence_counts oc on oc.case_id = c.case_id
       left join open_validation_counts vc on vc.case_id = c.case_id
       ${whereSql}
       order by c.updated_at desc, c.created_at desc
       limit $${listValues.length - 1} offset $${listValues.length}`,
      listValues
    );

    return ok(reply, result.rows, {
      ...pageMeta(Number(count.rows[0]?.total ?? 0), query),
      trace: {
        sourceTables: [
          'case_files',
          'courts',
          'participants',
          'hearings',
          'case_occurrences',
          'validation_results'
        ],
        filters: {
          court_id: query.court_id,
          case_type: query.case_type,
          case_group: query.case_group,
          case_status: query.case_status,
          current_stage: query.current_stage,
          from_date: query.from_date,
          to_date: query.to_date,
          search: query.search
        },
        note: 'Readonly worklist API; counts are per related table and do not compute statistics indicators.'
      }
    });
  });

  await crudRoutes(app, {
    prefix: '/cases',
    config: tableConfigs.cases,
    createSchema: caseCreateSchema,
    updateSchema: caseCreateSchema.partial(),
    filterFields: ['court_id', 'case_type', 'case_group', 'case_status', 'current_stage', 'resolution_status']
  });

  app.post('/cases/intake', async (request, reply) => {
    const user = requireRoles(request, ['admin', 'chief_judge', 'deputy_chief_judge']);
    const input = caseIntakeSchema.parse(request.body);
    const client = await pool.connect();

    try {
      await client.query('begin');

      if (input.case.case_number) {
        const duplicate = await client.query(
          `select case_id
           from case_files
           where court_id = $1
             and case_number = $2
             and case_type = $3
           limit 1`,
          [input.case.court_id, input.case.case_number, input.case.case_type]
        );
        if (duplicate.rowCount) {
          throw new ApiError('CONFLICT', 'Ho so da ton tai trong cung toa an va loai an', 409, {
            case_id: duplicate.rows[0]?.case_id
          });
        }
      }

      const createdCase = await insertRecord(client, 'case_files', [
        'court_id',
        'case_code',
        'case_number',
        'case_type',
        'case_group',
        'procedure_law',
        'filing_date',
        'acceptance_date',
        'current_stage',
        'case_status',
        'resolution_status',
        'has_foreign_element',
        'is_minor_related',
        'is_confidential',
        'first_instance_court_id',
        'first_instance_case_number',
        'first_instance_judgment_number',
        'first_instance_judgment_date',
        'summary'
      ], normalizeInput(input.case));

      const createdOccurrence = input.occurrence
        ? await insertRecord(client, 'case_occurrences', [
            'case_id',
            'occurrence_no',
            'acceptance_date',
            'acceptance_type_code',
            'source_note'
          ], {
            case_id: createdCase.case_id,
            ...normalizeInput(input.occurrence)
          })
        : null;

      const detail = await createCaseDetail(client, input.case.case_type, createdCase.case_id, input);

      await writeAudit(client, {
        tableName: 'case_files',
        recordId: createdCase.case_id,
        action: 'case_intake.create',
        actor: user,
        newData: {
          case: createdCase,
          occurrence: createdOccurrence,
          detail
        }
      });

      await client.query('commit');
      return reply.status(201).send({
        success: true,
        data: {
          case: createdCase,
          occurrence: createdOccurrence,
          detail
        },
        meta: {
          trace: {
            sourceTables: ['case_files', 'case_occurrences', detail?.tableName].filter(Boolean),
            note: 'Transaction tao ho so tu form nhap lieu; chua tinh chi tieu thong ke.'
          }
        }
      });
    } catch (error) {
      await client.query('rollback');
      throw error;
    } finally {
      client.release();
    }
  });

  app.get('/cases/:id/overview', async (request, reply) => {
    const { id } = z.object({ id: z.string().uuid() }).parse(request.params);
    const caseResult = await pool.query(
      `select c.*,
              court.court_code,
              court.court_name,
              court.court_level,
              first_court.court_code as first_instance_court_code,
              first_court.court_name as first_instance_court_name
       from case_files c
       join courts court on court.court_id = c.court_id
       left join courts first_court on first_court.court_id = c.first_instance_court_id
       where c.case_id = $1`,
      [id]
    );
    if (!caseResult.rowCount) {
      throw new ApiError('NOT_FOUND', 'Khong tim thay ho so', 404);
    }

    const [
      occurrences,
      resolutionEvents,
      participants,
      hearings,
      hearingMembers,
      validations,
      auditLogs
    ] = await Promise.all([
      pool.query(
        `select occurrence_id, case_id, occurrence_no, acceptance_date, acceptance_type_code,
                acceptance_type_id, previous_occurrence_id, source_note, created_at, updated_at
         from case_occurrences
         where case_id = $1
         order by occurrence_no, acceptance_date`,
        [id]
      ),
      pool.query(
        `select resolution_event_id, case_id, occurrence_id, event_type_code, event_date,
                resolution_type_code, resolution_type_id, return_to_agency_code, return_to_agency_id,
                decision_number, counted_as_resolved, reason, created_at, updated_at
         from case_resolution_events
         where case_id = $1
         order by event_date, created_at`,
        [id]
      ),
      pool.query(
        `select participant_id, case_id, participant_type, full_name, organization_name,
                legal_representative, id_number, date_of_birth, gender, address, phone,
                email, is_minor, needs_interpreter, note
         from participants
         where case_id = $1
         order by participant_type, full_name nulls last, organization_name nulls last`,
        [id]
      ),
      pool.query(
        `select hearing_id, case_id, hearing_type, scheduled_date, scheduled_time, courtroom,
                panel_composition, hearing_status, postponement_reason, actual_opened_date,
                actual_closed_date, note
         from hearings
         where case_id = $1
         order by scheduled_date nulls last, scheduled_time nulls last`,
        [id]
      ),
      pool.query(
        `select m.case_hearing_member_id, m.case_id, m.staff_id, s.full_name, s.staff_type,
                s.position_title, m.role_code, m.role_id, m.member_order, m.source_file,
                m.source_sheet, m.source_row, m.created_at, m.updated_at
         from case_hearing_members m
         join court_staff s on s.staff_id = m.staff_id
         where m.case_id = $1
         order by m.role_code, m.member_order`,
        [id]
      ),
      pool.query(
        `select validation_id, case_id, rule_code, severity, validation_status, message,
                field_name, checked_at, checked_by, legal_basis, suggested_action
         from validation_results
         where case_id = $1
         order by checked_at desc`,
        [id]
      ),
      pool.query(
        `select audit_log_id, table_name, record_id, action, actor_id, action_at,
                old_data, new_data, integrity_hash
         from audit_logs
         where record_id = $1
            or new_data->>'case_id' = $1::text
            or old_data->>'case_id' = $1::text
         order by action_at desc
         limit 100`,
        [id]
      )
    ]);

    return ok(
      reply,
      {
        case: caseResult.rows[0],
        occurrences: occurrences.rows,
        resolutionEvents: resolutionEvents.rows,
        participants: participants.rows,
        hearings: hearings.rows,
        hearingMembers: hearingMembers.rows,
        validationResults: validations.rows,
        auditLogs: auditLogs.rows
      },
      {
        trace: {
          sourceTables: [
            'case_files',
            'courts',
            'case_occurrences',
            'case_resolution_events',
            'participants',
            'hearings',
            'case_hearing_members',
            'court_staff',
            'validation_results',
            'audit_logs'
          ],
          note: 'Readonly overview API; khong tinh chi tieu thong ke moi.'
        }
      }
    );
  });
}

async function createCaseDetail(
  client: import('pg').PoolClient,
  caseType: z.infer<typeof caseIntakeSchema>['case']['case_type'],
  caseId: string,
  input: z.infer<typeof caseIntakeSchema>
) {
  if (caseType === 'criminal' && input.criminalDetail) {
    const row = await insertRecord(client, 'criminal_case_details', [
      'case_id',
      'procuracy_name',
      'indictment_number',
      'indictment_date',
      'investigation_agency',
      'dossier_received_date',
      'trial_panel_type'
    ], {
      case_id: caseId,
      ...normalizeInput(input.criminalDetail)
    });
    return { tableName: 'criminal_case_details', row };
  }

  if (caseType === 'administrative' && input.administrativeDetail) {
    const detailInput = normalizeInput(input.administrativeDetail);
    const row = await insertRecord(client, 'administrative_case_details', [
      'case_id',
      'lawsuit_type',
      'defendant_agency_name',
      'agency_representative',
      'agency_level',
      'compensation_claimed',
      'compensation_amount',
      'jurisdiction_basis'
    ], {
      case_id: caseId,
      ...detailInput,
      compensation_claimed: detailInput.compensation_amount !== null && detailInput.compensation_amount !== undefined
    });
    return { tableName: 'administrative_case_details', row };
  }

  if (input.civilDetail) {
    const row = await insertRecord(client, 'civil_case_details', [
      'case_id',
      'civil_category',
      'dispute_type',
      'claim_value',
      'jurisdiction_basis',
      'mediation_result',
      'court_fee_advance_paid'
    ], {
      case_id: caseId,
      ...normalizeInput(input.civilDetail)
    });
    return { tableName: 'civil_case_details', row };
  }

  return null;
}

function normalizeInput(input: Record<string, unknown>) {
  return Object.fromEntries(
    Object.entries(input).map(([key, value]) => [key, value === '' ? null : value])
  );
}

async function insertRecord(
  client: import('pg').PoolClient,
  table: string,
  allowedColumns: readonly string[],
  input: Record<string, unknown>
) {
  const entries = allowedColumns
    .filter((column) => input[column] !== undefined)
    .map((column) => [column, input[column]] as const);
  const columns = entries.map(([column]) => column);
  const values = entries.map(([, value]) => value);
  const params = values.map((_, index) => `$${index + 1}`);
  const result = await client.query(
    `insert into ${table} (${columns.join(', ')}) values (${params.join(', ')}) returning *`,
    values
  );
  return result.rows[0];
}
