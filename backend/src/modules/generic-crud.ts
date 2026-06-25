import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { pool } from '../database/pool.js';
import { getCurrentUser, requireRoles } from '../common/auth.js';
import { writeAudit } from '../common/audit.js';
import { ok } from '../common/http.js';
import { paginationSchema, pageMeta } from '../common/pagination.js';
import { Repository, type TableConfig } from '../common/repository.js';

const idParams = z.object({ id: z.string().uuid() });
const anyObject = z.record(z.unknown());

export type CrudOptions = {
  prefix: string;
  config: TableConfig;
  readRoles?: string[];
  writeRoles?: string[];
  createSchema?: z.ZodTypeAny;
  updateSchema?: z.ZodTypeAny;
  filterFields?: readonly string[];
  auditName?: string;
};

export async function crudRoutes(app: FastifyInstance, options: CrudOptions) {
  const repo = new Repository(pool, options.config);
  const readRoles = options.readRoles;
  const writeRoles = options.writeRoles ?? ['admin', 'chief_judge', 'deputy_chief_judge'];

  app.get(options.prefix, async (request, reply) => {
    if (readRoles) requireRoles(request, readRoles);
    const pagination = paginationSchema.parse(request.query);
    const query = request.query as Record<string, unknown>;
    const filters: Record<string, unknown> = {};
    for (const field of options.filterFields ?? []) filters[field] = query[field];
    const result = await repo.list({ ...pagination, filters });
    return ok(reply, result.rows, pageMeta(result.total, pagination));
  });

  app.get(`${options.prefix}/:id`, async (request, reply) => {
    if (readRoles) requireRoles(request, readRoles);
    const { id } = idParams.parse(request.params);
    return ok(reply, await repo.get(id));
  });

  if (options.config.writable.length) {
    app.post(options.prefix, async (request, reply) => {
      const user = requireRoles(request, writeRoles);
      const input = (options.createSchema ?? anyObject).parse(request.body) as Record<string, unknown>;
      const client = await pool.connect();
      try {
        await client.query('begin');
        const txRepo = new Repository(client, options.config);
        const created = await txRepo.create(input);
        await writeAudit(client, {
          tableName: options.config.table,
          recordId: created[options.config.idColumn],
          action: `${options.auditName ?? options.config.table}.create`,
          actor: user,
          newData: created
        });
        await client.query('commit');
        return reply.status(201).send({ success: true, data: created, meta: {} });
      } catch (error) {
        await client.query('rollback');
        throw error;
      } finally {
        client.release();
      }
    });

    app.patch(`${options.prefix}/:id`, async (request, reply) => {
      const user = requireRoles(request, writeRoles);
      const { id } = idParams.parse(request.params);
      const input = (options.updateSchema ?? anyObject).parse(request.body) as Record<string, unknown>;
      const client = await pool.connect();
      try {
        await client.query('begin');
        const txRepo = new Repository(client, options.config);
        const before = await txRepo.get(id);
        const updated = await txRepo.update(id, input);
        await writeAudit(client, {
          tableName: options.config.table,
          recordId: id,
          action: `${options.auditName ?? options.config.table}.update`,
          actor: user,
          oldData: before,
          newData: updated
        });
        await client.query('commit');
        return ok(reply, updated);
      } catch (error) {
        await client.query('rollback');
        throw error;
      } finally {
        client.release();
      }
    });
  }
}
