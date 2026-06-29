import { describe, expect, it } from 'vitest';
import { buildCasePeriodCte, categoryCondition, reportPeriodQuerySchema } from './report-period.js';

describe('report period rules', () => {
  it('accepts a one-day inclusive reporting period', () => {
    expect(reportPeriodQuerySchema.parse({ from_date: '2026-06-30', to_date: '2026-06-30' })).toEqual({
      from_date: '2026-06-30',
      to_date: '2026-06-30'
    });
  });

  it('rejects an inverted reporting period', () => {
    expect(() => reportPeriodQuerySchema.parse({ from_date: '2026-07-01', to_date: '2026-06-30' })).toThrow();
  });

  it('accepts camelCase API aliases and normalizes them', () => {
    expect(reportPeriodQuerySchema.parse({ fromDate: '2026-06-01', toDate: '2026-06-30' })).toMatchObject({
      from_date: '2026-06-01',
      to_date: '2026-06-30'
    });
  });

  it('builds classification from business dates and the period end', () => {
    const result = buildCasePeriodCte({ from_date: '2026-06-01', to_date: '2026-06-30' });
    expect(result.values).toEqual(['2026-06-01', '2026-06-30']);
    expect(result.sql).toContain('c.acceptance_date between $1::date and $2::date');
    expect(result.sql).toContain('c.acceptance_date < $1::date');
    expect(result.sql).toContain('c.closed_date is null or c.closed_date > $2::date');
    expect(result.sql).toContain('c.closed_date between $1::date and $2::date');
    expect(result.sql).toContain("then 'Giải quyết sau kỳ báo cáo: '");
  });

  it('maps each list to a distinct boolean classification', () => {
    expect(categoryCondition('accepted_in_period')).toBe('is_accepted_in_period');
    expect(categoryCondition('opening_pending')).toBe('is_opening_pending');
    expect(categoryCondition('resolved_in_period')).toBe('is_resolved_in_period');
  });
});
