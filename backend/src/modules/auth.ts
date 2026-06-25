import type { FastifyInstance } from 'fastify';
import bcrypt from 'bcryptjs';
import { z } from 'zod';
import { pool } from '../database/pool.js';
import { getCurrentUser, signToken } from '../common/auth.js';
import { ApiError, ok } from '../common/http.js';

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1)
});

async function findPasswordColumn() {
  const result = await pool.query<{ column_name: string }>(
    `select column_name
     from information_schema.columns
     where table_name = 'users'
       and column_name in ('password_hash', 'password_digest')
     order by column_name
     limit 1`
  );
  return result.rows[0]?.column_name;
}

export async function authRoutes(app: FastifyInstance) {
  app.post('/auth/login', async (request, reply) => {
    const input = loginSchema.parse(request.body);
    const passwordColumn = await findPasswordColumn();
    if (!passwordColumn) {
      throw new ApiError('AUTH_PASSWORD_NOT_CONFIGURED', 'Schema users chua co cot password hash de dang nhap', 501);
    }
    const result = await pool.query(
      `select user_id, court_id, full_name, role_code, is_active, ${passwordColumn} as password_hash
       from users
       where lower(email) = lower($1)
       limit 1`,
      [input.email]
    );
    const user = result.rows[0];
    if (!user || !user.is_active) throw new ApiError('UNAUTHORIZED', 'Thong tin dang nhap khong hop le', 401);
    const matched = await bcrypt.compare(input.password, user.password_hash);
    if (!matched) throw new ApiError('UNAUTHORIZED', 'Thong tin dang nhap khong hop le', 401);
    const currentUser = {
      userId: user.user_id,
      courtId: user.court_id,
      roleCode: user.role_code,
      fullName: user.full_name
    };
    return ok(reply, { accessToken: signToken(currentUser), user: currentUser });
  });

  app.post('/auth/logout', async (_request, reply) => ok(reply, { loggedOut: true }));

  app.get('/auth/me', async (request, reply) => ok(reply, getCurrentUser(request)));
}
