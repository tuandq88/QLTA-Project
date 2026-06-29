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

  it('lists the twelve supported A/B statistical templates without database access', async () => {
    const app = await buildApp();
    const response = await app.inject({ method: 'GET', url: '/api/statistics/forms' });
    expect(response.statusCode).toBe(200);
    expect(response.json().data).toHaveLength(12);
    expect(response.json().data.filter((form: { trialLevel: string }) => form.trialLevel === 'SO_THAM')).toHaveLength(6);
    expect(response.json().data.filter((form: { trialLevel: string }) => form.trialLevel === 'PHUC_THAM')).toHaveLength(6);
    await app.close();
  });

  it('rejects PDF for template reports before accessing the database', async () => {
    const app = await buildApp();
    const response = await app.inject({
      method: 'GET',
      url: '/api/statistics/reports/2A/export?format=pdf&from_date=2026-05-01&to_date=2026-05-31'
    });
    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
    expect(response.json().error.details.supportedFormats).toEqual(['xlsx']);
    await app.close();
  });
});
