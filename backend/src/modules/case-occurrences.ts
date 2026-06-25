import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { tableConfigs } from '../common/table-config.js';
import { crudRoutes } from './generic-crud.js';

const occurrenceSchema = z.object({
  case_id: z.string().uuid(),
  occurrence_no: z.number().int().positive(),
  acceptance_date: z.string(),
  acceptance_type_code: z.enum(['INITIAL_ACCEPTANCE', 'RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION']),
  acceptance_type_id: z.string().uuid().optional().nullable(),
  previous_occurrence_id: z.string().uuid().optional().nullable(),
  source_note: z.string().optional().nullable()
});

const eventSchema = z.object({
  case_id: z.string().uuid(),
  occurrence_id: z.string().uuid(),
  event_type_code: z.string().default('RESOLUTION'),
  event_date: z.string(),
  resolution_type_code: z.string().min(1),
  resolution_type_id: z.string().uuid().optional().nullable(),
  return_to_agency_code: z.string().optional().nullable(),
  return_to_agency_id: z.string().uuid().optional().nullable(),
  decision_number: z.string().optional().nullable(),
  counted_as_resolved: z.boolean().optional(),
  reason: z.string().optional().nullable()
});

export async function caseOccurrenceRoutes(app: FastifyInstance) {
  await crudRoutes(app, {
    prefix: '/case-occurrences',
    config: tableConfigs.occurrences,
    createSchema: occurrenceSchema,
    updateSchema: occurrenceSchema.partial(),
    filterFields: ['case_id', 'acceptance_type_code']
  });
  await crudRoutes(app, {
    prefix: '/case-resolution-events',
    config: tableConfigs.resolutionEvents,
    createSchema: eventSchema,
    updateSchema: eventSchema.partial(),
    filterFields: ['case_id', 'occurrence_id', 'event_type_code', 'resolution_type_code', 'counted_as_resolved']
  });
}
