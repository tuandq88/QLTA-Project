import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { tableConfigs } from '../common/table-config.js';
import { crudRoutes } from './generic-crud.js';

const participantSchema = z.object({
  case_id: z.string().uuid(),
  participant_type: z.string().min(1),
  full_name: z.string().optional().nullable(),
  organization_name: z.string().optional().nullable(),
  legal_representative: z.string().optional().nullable(),
  id_number: z.string().optional().nullable(),
  date_of_birth: z.string().optional().nullable(),
  gender: z.string().optional().nullable(),
  address: z.string().optional().nullable(),
  phone: z.string().optional().nullable(),
  email: z.string().email().optional().nullable(),
  is_minor: z.boolean().optional(),
  needs_interpreter: z.boolean().optional(),
  note: z.string().optional().nullable()
});

export async function participantRoutes(app: FastifyInstance) {
  await crudRoutes(app, {
    prefix: '/participants',
    config: tableConfigs.participants,
    createSchema: participantSchema,
    updateSchema: participantSchema.partial(),
    filterFields: ['case_id', 'participant_type', 'is_minor']
  });
}
