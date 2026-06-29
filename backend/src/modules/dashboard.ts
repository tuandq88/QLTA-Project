import type { FastifyInstance } from 'fastify';
import { pool } from '../database/pool.js';
import { ok } from '../common/http.js';
import { buildCasePeriodCte, reportPeriodQuerySchema } from '../common/report-period.js';

export async function dashboardRoutes(app: FastifyInstance) {
  app.get('/dashboard/case-progress', async (request, reply) => {
    const query = reportPeriodQuerySchema.parse(request.query);
    const period = buildCasePeriodCte(query);

    const [totals, byType, byMonth, judgeProgress, appellateQuality] = await Promise.all([
      pool.query(
        `${period.sql}
         select count(*)::int as total_cases,
                count(*) filter (where is_accepted_in_period)::int as accepted_in_period_cases,
                count(*) filter (where is_opening_pending)::int as opening_pending_cases,
                count(*) filter (where is_resolved_in_period)::int as resolved_cases,
                count(*) filter (where is_pending_at_period_end)::int as pending_cases,
                count(*) filter (where is_pending_at_period_end and case_status = 'overdue')::int as overdue_cases,
                coalesce(sum(open_validation_count), 0)::int as open_validation_count,
                count(*) filter (where assignment_method = 'RANDOM')::int as random_assigned_cases
         from period_cases`,
        period.values
      ),
      pool.query(
        `${period.sql}
         select case_type,
                count(*) filter (where is_accepted_in_period)::int as accepted_count,
                count(*) filter (where is_resolved_in_period)::int as resolved_count,
                count(*) filter (where is_pending_at_period_end and case_status = 'overdue')::int as overdue_count
         from period_cases
         group by case_type
         having count(*) filter (where is_accepted_in_period or is_resolved_in_period or is_pending_at_period_end) > 0
         order by accepted_count desc, case_type`,
        period.values
      ),
      pool.query(
        `${period.sql},
         monthly_events as (
           select date_trunc('month', acceptance_date) as event_month, count(*)::int as accepted_count, 0::int as resolved_count
           from period_cases
           where is_accepted_in_period
           group by date_trunc('month', acceptance_date)
           union all
           select date_trunc('month', closed_date) as event_month, 0::int, count(*)::int
           from period_cases
           where is_resolved_in_period
           group by date_trunc('month', closed_date)
         )
         select to_char(event_month, 'YYYY-MM') as period,
                sum(accepted_count)::int as accepted_count,
                sum(resolved_count)::int as resolved_count
         from monthly_events
         group by event_month
         order by event_month`,
        period.values
      ),
      pool.query(
        `${period.sql}
         select judge_id,
                judge_name,
                count(*)::int as assigned_count,
                count(*) filter (where is_resolved_in_period)::int as resolved_count,
                count(*) filter (where is_pending_at_period_end and case_status = 'overdue')::int as overdue_count,
                coalesce(sum(open_validation_count), 0)::int as open_validation_count
         from period_cases
         group by judge_id, judge_name
         order by assigned_count desc, judge_name
         limit 20`,
        period.values
      ),
      pool.query(
        `${period.sql},
         latest_appellate_results as (
           select distinct on (appellate_tracking_id)
                  appellate_result_id, appellate_tracking_id, result_code, result_date
           from appellate_results
           order by appellate_tracking_id, result_date desc, created_at desc
         ),
         latest_fault_assessments as (
           select distinct on (appellate_result_id)
                  appellate_result_id, fault_classification
           from appellate_fault_assessments
           order by appellate_result_id, assessment_date desc nulls last, fault_assessment_id desc
         )
         select coalesce(ar.result_code, at.final_result_code, 'unknown') as result_code,
                coalesce(afa.fault_classification::text, at.fault_classification::text, 'unknown') as fault_classification,
                count(distinct at.appellate_tracking_id)::int as tracking_count
         from appellate_trackings at
         join period_cases pc on pc.case_id = at.original_case_id
         left join latest_appellate_results ar on ar.appellate_tracking_id = at.appellate_tracking_id
         left join latest_fault_assessments afa on afa.appellate_result_id = ar.appellate_result_id
         where coalesce(ar.result_date, at.resolved_date) between $1::date and $2::date
         group by coalesce(ar.result_code, at.final_result_code, 'unknown'),
                  coalesce(afa.fault_classification::text, at.fault_classification::text, 'unknown')
         order by tracking_count desc, result_code`,
        period.values
      )
    ]);

    const totalRow = totals.rows[0] ?? {
      total_cases: 0,
      accepted_in_period_cases: 0,
      opening_pending_cases: 0,
      resolved_cases: 0,
      pending_cases: 0,
      overdue_cases: 0,
      open_validation_count: 0,
      random_assigned_cases: 0
    };

    return ok(reply, {
      totals: totalRow,
      byType: byType.rows,
      byMonth: byMonth.rows,
      judgeProgress: judgeProgress.rows,
      appellateQuality: appellateQuality.rows
    }, {
      trace: {
        sourceTables: [
          'case_files', 'courts', 'case_assignments', 'users', 'validation_results',
          'appellate_trackings', 'appellate_results', 'appellate_fault_assessments'
        ],
        filters: query,
        note: 'Số liệu được xác định tại to_date; from_date và to_date đều được tính bao gồm.'
      }
    });
  });
}
