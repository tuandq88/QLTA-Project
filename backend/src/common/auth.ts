import type { FastifyRequest } from 'fastify';
import jwt from 'jsonwebtoken';
import type { SignOptions } from 'jsonwebtoken';
import { ApiError } from './http.js';
import { env } from '../config/env.js';

export type CurrentUser = {
  userId?: string | null;
  courtId?: string | null;
  roleCode: string;
  fullName: string;
};

export const localSystemUser: CurrentUser = {
  userId: null,
  courtId: null,
  roleCode: 'local_no_auth',
  fullName: 'Local development'
};

export function signToken(user: CurrentUser) {
  const options: SignOptions = { expiresIn: env.JWT_EXPIRES_IN as SignOptions['expiresIn'] };
  return jwt.sign(user, env.JWT_SECRET, options);
}

export function getCurrentUser(request: FastifyRequest): CurrentUser {
  if (!env.AUTH_REQUIRED) return localSystemUser;
  const auth = request.headers.authorization;
  if (!auth?.startsWith('Bearer ')) {
    throw new ApiError('UNAUTHORIZED', 'Chua xac thuc', 401);
  }
  try {
    return jwt.verify(auth.slice(7), env.JWT_SECRET) as CurrentUser;
  } catch {
    throw new ApiError('UNAUTHORIZED', 'Phien dang nhap khong hop le', 401);
  }
}

export function requireRoles(request: FastifyRequest, roles: string[]) {
  const user = getCurrentUser(request);
  if (!env.AUTH_REQUIRED) return user;
  if (!roles.includes(user.roleCode)) {
    throw new ApiError('FORBIDDEN', 'Khong du quyen thuc hien thao tac', 403);
  }
  return user;
}
