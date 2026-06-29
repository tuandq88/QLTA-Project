import cors from '@fastify/cors';
import helmet from '@fastify/helmet';
import Fastify from 'fastify';
import { ZodError } from 'zod';
import { ApiError, fail } from './common/http.js';
import { auditLogRoutes } from './modules/audit-logs.js';
import { authRoutes } from './modules/auth.js';
import { caseAssignmentRoutes } from './modules/case-assignments.js';
import { caseOccurrenceRoutes } from './modules/case-occurrences.js';
import { caseRoutes } from './modules/cases.js';
import { catalogRoutes } from './modules/catalog.js';
import { dashboardRoutes } from './modules/dashboard.js';
import { defendantRoutes } from './modules/defendants.js';
import { healthRoutes } from './modules/health.js';
import { hearingRoutes } from './modules/hearings.js';
import { participantRoutes } from './modules/participants.js';
import { statisticsRoutes } from './modules/statistics.js';
import { userRoutes } from './modules/users.js';
import { validationResultRoutes } from './modules/validation-results.js';

export async function buildApp() {
  const app = Fastify({ logger: true });
  await app.register(helmet);
  await app.register(cors, { origin: true });

  app.setErrorHandler((error, _request, reply) => {
    if (error instanceof ZodError) {
      return fail(reply, new ApiError('VALIDATION_ERROR', 'Du lieu khong hop le', 400, error.flatten()));
    }
    if (error instanceof ApiError) return fail(reply, error);
    if (typeof error === 'object' && error && 'code' in error && error.code === '42P01') {
      return fail(
        reply,
        new ApiError(
          'DATABASE_SCHEMA_NOT_READY',
          'Database chua co bang theo unified schema. Hay chay schema/seed hoac kiem tra DATABASE_URL.',
          503
        )
      );
    }
    app.log.error(error);
    return fail(reply, new ApiError('INTERNAL_ERROR', 'Loi he thong', 500));
  });

  await app.register(healthRoutes);
  await app.register(authRoutes);
  await app.register(async (api) => {
    await api.register(userRoutes);
    await api.register(catalogRoutes);
    await api.register(dashboardRoutes);
    await api.register(caseRoutes);
    await api.register(defendantRoutes);
    await api.register(caseAssignmentRoutes);
    await api.register(caseOccurrenceRoutes);
    await api.register(participantRoutes);
    await api.register(hearingRoutes);
    await api.register(statisticsRoutes);
    await api.register(validationResultRoutes);
    await api.register(auditLogRoutes);
  }, { prefix: '/api' });

  return app;
}
