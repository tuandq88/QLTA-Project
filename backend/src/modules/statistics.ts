import type { FastifyInstance } from 'fastify';
import { pool } from '../database/pool.js';
import { ok } from '../common/http.js';
import { paginationSchema, pageMeta } from '../common/pagination.js';

export async function statisticsRoutes(app: FastifyInstance) {
  app.get('/statistics/snapshots', async (request, reply) => {
    const query = request.query as Record<string, string | undefined>;
    const pagination = paginationSchema.parse(query);
    const values: unknown[] = [];
    const where: string[] = [];
    for (const field of ['period_id', 'court_id', 'case_id', 'metric_code', 'statistic_form_code', 'case_group']) {
      if (!query[field]) continue;
      values.push(query[field]);
      where.push(`${field} = $${values.length}`);
    }
    const whereSql = where.length ? `where ${where.join(' and ')}` : '';
    const count = await pool.query<{ total: string }>(`select count(*)::text as total from statistics_snapshots ${whereSql}`, values);
    values.push(pagination.pageSize, (pagination.page - 1) * pagination.pageSize);
    const result = await pool.query(
      `select snapshot_id, period_id, court_id, case_id, statistic_form_code, case_group,
              metric_code, metric_value, aggregation_level, source_table, source_record_id, calculated_at
       from statistics_snapshots
       ${whereSql}
       order by calculated_at desc
       limit $${values.length - 1} offset $${values.length}`,
      values
    );
    return ok(reply, result.rows, {
      ...pageMeta(Number(count.rows[0]?.total ?? 0), pagination),
      trace: {
        sourceTable: 'statistics_snapshots',
        filters: query,
        note: 'Readonly snapshot API; khong tu tinh cong thuc moi.'
      }
    });
  });

  app.get('/statistics/kpi-values', async (request, reply) => {
    const query = request.query as Record<string, string | undefined>;
    const pagination = paginationSchema.parse(query);
    const values: unknown[] = [];
    const where: string[] = [];
    for (const field of ['period_id', 'court_id', 'judge_id', 'metric_id']) {
      if (!query[field]) continue;
      values.push(query[field]);
      where.push(`v.${field} = $${values.length}`);
    }
    const whereSql = where.length ? `where ${where.join(' and ')}` : '';
    const count = await pool.query<{ total: string }>(`select count(*)::text as total from kpi_values v ${whereSql}`, values);
    values.push(pagination.pageSize, (pagination.page - 1) * pagination.pageSize);
    const result = await pool.query(
      `select v.kpi_value_id, v.metric_id, m.metric_code, m.metric_name, m.formula,
              v.period_id, v.court_id, v.judge_id, v.actual_value, v.target_value,
              v.status, v.calculated_at
       from kpi_values v
       join kpi_metrics m on m.metric_id = v.metric_id
       ${whereSql}
       order by v.calculated_at desc
       limit $${values.length - 1} offset $${values.length}`,
      values
    );
    return ok(reply, result.rows, {
      ...pageMeta(Number(count.rows[0]?.total ?? 0), pagination),
      trace: {
        sourceTable: 'kpi_values',
        formulaSource: 'kpi_metrics.formula',
        filters: query,
        note: 'Readonly KPI API; chi doc gia tri da tinh.'
      }
    });
  });
}
