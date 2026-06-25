import type { FastifyInstance } from 'fastify';
import { checkDatabase } from '../database/pool.js';
import { ok } from '../common/http.js';

export async function healthRoutes(app: FastifyInstance) {
  app.get('/health', async (_request, reply) => ok(reply, { status: 'ok' }));

  app.get('/health/db', async (_request, reply) => {
    await checkDatabase();
    return ok(reply, { status: 'ok' });
  });
}
