import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { tableConfigs } from '../common/table-config.js';
import { crudRoutes } from './generic-crud.js';

const caseAssignmentSchema = z.object({
  case_id: z.string().uuid(),
  user_id: z.string().uuid(),
  assignment_role: z.enum(['primary_judge', 'panel_judge', 'clerk', 'procurator', 'assistant', 'other']).default('primary_judge'),
  assigned_date: z.string().optional().nullable(),
  ended_date: z.string().optional().nullable(),
  is_primary: z.boolean().optional(),
  assignment_method: z.enum(['RANDOM', 'DESIGNATED', 'MIXED']).optional().nullable(),
  assigned_by: z.string().uuid().optional().nullable(),
  legal_basis: z.string().optional().nullable(),
  designated_reason_code: z.string().optional().nullable(),
  judge_rank_at_assignment: z.coerce.number().int().optional().nullable(),
  case_order_at_assignment: z.coerce.number().int().optional().nullable(),
  integrity_hash: z.string().optional().nullable(),
  status: z.enum(['draft', 'running', 'completed', 'cancelled', 'active', 'replaced']).optional(),
  replacement_reason: z.string().optional().nullable()
});

export async function caseAssignmentRoutes(app: FastifyInstance) {
  await crudRoutes(app, {
    prefix: '/case-assignments',
    config: tableConfigs.caseAssignments,
    createSchema: caseAssignmentSchema,
    updateSchema: caseAssignmentSchema.partial(),
    filterFields: ['case_id', 'user_id', 'assignment_role', 'status']
  });
}
