import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
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

export async function caseRoutes(app: FastifyInstance) {
  await crudRoutes(app, {
    prefix: '/cases',
    config: tableConfigs.cases,
    createSchema: caseCreateSchema,
    updateSchema: caseCreateSchema.partial(),
    filterFields: ['court_id', 'case_type', 'case_group', 'case_status', 'current_stage', 'resolution_status']
  });
}
