import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { pool } from '../database/pool.js';
import { requireRoles } from '../common/auth.js';
import { writeAudit } from '../common/audit.js';
import { ApiError, ok } from '../common/http.js';
import { tableConfigs } from '../common/table-config.js';
import { crudRoutes } from './generic-crud.js';

const userCreateSchema = z.object({
  court_id: z.string().uuid().optional().nullable(),
  full_name: z.string().min(1),
  position_title: z.string().optional().nullable(),
  role_code: z.enum(['admin', 'chief_judge', 'deputy_chief_judge', 'judge', 'clerk', 'viewer']).default('viewer'),
  department: z.string().optional().nullable(),
  email: z.string().email().optional().nullable(),
  phone: z.string().optional().nullable(),
  is_active: z.boolean().optional()
});

const userUpdateSchema = userCreateSchema.partial();

export async function userRoutes(app: FastifyInstance) {
  await crudRoutes(app, {
    prefix: '/users',
    config: tableConfigs.users,
    createSchema: userCreateSchema,
    updateSchema: userUpdateSchema,
    filterFields: ['court_id', 'role_code', 'is_active'],
    auditName: 'users'
  });

  app.delete('/users/:id', async (request, reply) => {
    const user = requireRoles(request, ['admin', 'chief_judge', 'deputy_chief_judge']);
    const id = z.object({ id: z.string().uuid() }).parse(request.params).id;
    const client = await pool.connect();
    try {
      await client.query('begin');
      const before = await client.query('select * from users where user_id = $1', [id]);
      if (!before.rowCount) throw new ApiError('NOT_FOUND', 'Khong tim thay tai khoan', 404);
      const updated = await client.query('update users set is_active = false, updated_at = now() where user_id = $1 returning *', [id]);
      await writeAudit(client, {
        tableName: 'users',
        recordId: id,
        action: 'users.lock',
        actor: user,
        oldData: before.rows[0],
        newData: updated.rows[0]
      });
      await client.query('commit');
      return ok(reply, updated.rows[0]);
    } catch (error) {
      await client.query('rollback');
      throw error;
    } finally {
      client.release();
    }
  });
}
