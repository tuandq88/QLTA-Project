import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { tableConfigs } from '../common/table-config.js';
import { crudRoutes } from './generic-crud.js';

const validationSchema = z.object({
  case_id: z.string().uuid().optional().nullable(),
  rule_code: z.string().min(1),
  severity: z.enum(['INFO', 'WARNING', 'ERROR', 'CRITICAL']).default('WARNING'),
  validation_status: z.string().default('open'),
  message: z.string().min(1),
  field_name: z.string().optional().nullable(),
  checked_by: z.string().optional().nullable(),
  legal_basis: z.string().optional().nullable(),
  suggested_action: z.string().optional().nullable()
});

export async function validationResultRoutes(app: FastifyInstance) {
  await crudRoutes(app, {
    prefix: '/validation-results',
    config: tableConfigs.validationResults,
    createSchema: validationSchema,
    updateSchema: validationSchema.partial(),
    filterFields: ['case_id', 'rule_code', 'severity', 'validation_status']
  });
}
