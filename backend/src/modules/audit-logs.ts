import type { FastifyInstance } from 'fastify';
import { tableConfigs } from '../common/table-config.js';
import { crudRoutes } from './generic-crud.js';

export async function auditLogRoutes(app: FastifyInstance) {
  await crudRoutes(app, {
    prefix: '/audit-logs',
    config: tableConfigs.auditLogs,
    readRoles: ['admin', 'chief_judge', 'deputy_chief_judge'],
    filterFields: ['table_name', 'record_id', 'action', 'actor_id']
  });
}
