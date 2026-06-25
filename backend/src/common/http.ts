import type { FastifyReply } from 'fastify';

export type ApiErrorCode =
  | 'BAD_REQUEST'
  | 'UNAUTHORIZED'
  | 'FORBIDDEN'
  | 'NOT_FOUND'
  | 'CONFLICT'
  | 'VALIDATION_ERROR'
  | 'DATABASE_ERROR'
  | 'DATABASE_SCHEMA_NOT_READY'
  | 'AUTH_PASSWORD_NOT_CONFIGURED'
  | 'INTERNAL_ERROR';

export class ApiError extends Error {
  constructor(
    public readonly code: ApiErrorCode,
    message: string,
    public readonly statusCode = 400,
    public readonly details?: unknown
  ) {
    super(message);
  }
}

export function ok(reply: FastifyReply, data: unknown, meta: Record<string, unknown> = {}) {
  return reply.send({ success: true, data, meta });
}

export function fail(reply: FastifyReply, error: ApiError) {
  return reply.status(error.statusCode).send({
    success: false,
    error: {
      code: error.code,
      message: error.message,
      details: error.details ?? {}
    }
  });
}
