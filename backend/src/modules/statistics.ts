import type { FastifyInstance } from 'fastify';
import { pool } from '../database/pool.js';
import { ok } from '../common/http.js';
import { paginationSchema, pageMeta } from '../common/pagination.js';
import {
  casePeriodCategorySchema,
  reportPeriodQuerySchema
} from '../common/report-period.js';
import {
  categoryLabels,
  createCasePeriodExcel,
  createCasePeriodPdf,
  getCasePeriodRows
} from './case-period-report.js';
import {
  listStatisticalForms,
  statisticalMappingMetadata
} from './statistical-form-config.js';
import { createStatisticalFormExcel } from './statistical-form-excel.js';
import {
  calculateStatisticalReport,
  statisticalReportQuerySchema
} from './statistical-form-report.js';

export async function statisticsRoutes(app: FastifyInstance) {
  app.get('/statistics/forms', async (_request, reply) => {
    const forms = listStatisticalForms().map((form) => ({
      formCode: form.form_code,
      templateCode: form.template_code,
      caseType: form.case_type,
      trialLevel: form.trial_level,
      templateFile: form.template_file,
      sheet: form.sheet,
      guideColumnCount: form.guide_column_count,
      workbookColumnCount: form.workbook_column_count,
      deferredColumns: form.deferred_columns.map((column) => `C${column}`),
      sourceProfile: form.source_profile,
      mappingVersion: form.mapping_version
    }));
    return ok(reply, forms, statisticalMappingMetadata());
  });

  app.get('/statistics/reports/:formCode', async (request, reply) => {
    const { formCode } = request.params as { formCode: string };
    const query = statisticalReportQuerySchema.parse(request.query);
    const report = await calculateStatisticalReport(formCode, query);
    return ok(reply, report, {
      status: report.status,
      traceableCellCount: Object.values(report.cells).filter((cell) => cell.status === 'source' || cell.status === 'formula').length,
      unmappedCellCount: report.unmappedCells.length
    });
  });

  app.get('/statistics/reports/:formCode/export', async (request, reply) => {
    const { formCode } = request.params as { formCode: string };
    const rawQuery = request.query as Record<string, string | undefined>;
    if (rawQuery.format && rawQuery.format !== 'xlsx') {
      return reply.status(400).send({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Chi ho tro xuat Excel theo bieu mau (format=xlsx).',
          details: { supportedFormats: ['xlsx'] }
        }
      });
    }
    const query = statisticalReportQuerySchema.parse(rawQuery);
    const report = await calculateStatisticalReport(formCode, query);
    const exported = await createStatisticalFormExcel(report);
    const filename = `${report.form.template_code}-${query.from_date}-${query.to_date}.xlsx`;
    return reply
      .header('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      .header('Content-Disposition', `attachment; filename="${filename}"`)
      .header('X-Report-Status', report.status)
      .header('X-Template-Source-SHA256', exported.sourceSha256)
      .send(exported.buffer);
  });

  app.get('/statistics/case-period', async (request, reply) => {
    const rawQuery = request.query as Record<string, string | undefined>;
    const query = reportPeriodQuerySchema.parse(rawQuery);
    const category = casePeriodCategorySchema.parse(rawQuery.category);
    const rows = await getCasePeriodRows(query, category);

    return ok(reply, rows, {
      total: rows.length,
      category,
      categoryLabel: categoryLabels[category],
      trace: {
        sourceTables: ['case_files', 'courts', 'case_assignments', 'users'],
        filters: query,
        note: 'Trạng thái và kết quả được xác định tại to_date; hồ sơ giải quyết sau kỳ vẫn nằm trong danh sách tồn phù hợp.'
      }
    });
  });

  app.get('/statistics/case-period/export', async (request, reply) => {
    const rawQuery = request.query as Record<string, string | undefined>;
    const query = reportPeriodQuerySchema.parse(rawQuery);
    const format = rawQuery.format === 'pdf' ? 'pdf' : 'xlsx';
    const filename = `bao-cao-vu-an-${query.from_date}-${query.to_date}.${format}`;
    const content = format === 'pdf'
      ? await createCasePeriodPdf(query)
      : await createCasePeriodExcel(query);

    return reply
      .header('Content-Type', format === 'pdf'
        ? 'application/pdf'
        : 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      .header('Content-Disposition', `attachment; filename="${filename}"`)
      .send(content);
  });

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
