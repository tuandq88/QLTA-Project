import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { tableConfigs } from '../common/table-config.js';
import { crudRoutes } from './generic-crud.js';

const hearingSchema = z.object({
  case_id: z.string().uuid(),
  hearing_type: z.string().optional().nullable(),
  scheduled_date: z.string().optional().nullable(),
  scheduled_time: z.string().optional().nullable(),
  courtroom: z.string().optional().nullable(),
  panel_composition: z.string().optional().nullable(),
  hearing_status: z.string().optional().nullable(),
  postponement_reason: z.string().optional().nullable(),
  actual_opened_date: z.string().optional().nullable(),
  actual_closed_date: z.string().optional().nullable(),
  note: z.string().optional().nullable()
});

const memberSchema = z.object({
  case_id: z.string().uuid(),
  staff_id: z.string().uuid(),
  role_code: z.enum(['PRESIDING_JUDGE', 'PANEL_JUDGE', 'HEARING_CLERK']),
  role_id: z.string().uuid().optional().nullable(),
  member_order: z.number().int().positive().optional(),
  source_file: z.string().optional().nullable(),
  source_sheet: z.string().optional().nullable(),
  source_row: z.number().int().positive().optional().nullable()
});

export async function hearingRoutes(app: FastifyInstance) {
  await crudRoutes(app, {
    prefix: '/hearings',
    config: tableConfigs.hearings,
    createSchema: hearingSchema,
    updateSchema: hearingSchema.partial(),
    filterFields: ['case_id', 'hearing_type', 'hearing_status']
  });
  await crudRoutes(app, {
    prefix: '/hearing-members',
    config: tableConfigs.hearingMembers,
    createSchema: memberSchema,
    updateSchema: memberSchema.partial(),
    filterFields: ['case_id', 'staff_id', 'role_code']
  });
}
