import { describe, expect, it } from 'vitest';
import { buildApp } from './app.js';

describe('app contract', () => {
  it('returns standard success response for health', async () => {
    const app = await buildApp();
    const response = await app.inject({ method: 'GET', url: '/health' });
    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({ success: true, data: { status: 'ok' }, meta: {} });
    await app.close();
  });

  it('returns standard validation error response', async () => {
    const app = await buildApp();
    const response = await app.inject({ method: 'POST', url: '/auth/login', payload: {} });
    expect(response.statusCode).toBe(400);
    expect(response.json().success).toBe(false);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
    await app.close();
  });

  it('allows local-no-auth me response by default', async () => {
    const app = await buildApp();
    const response = await app.inject({ method: 'GET', url: '/auth/me' });
    expect(response.statusCode).toBe(200);
    expect(response.json().data.roleCode).toBe('local_no_auth');
    await app.close();
  });
});
