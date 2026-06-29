import { z } from 'zod';

const isoDateSchema = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Ngày phải có định dạng YYYY-MM-DD');

export const reportPeriodQuerySchema = z
  .object({
    from_date: isoDateSchema.optional(),
    to_date: isoDateSchema.optional(),
    fromDate: isoDateSchema.optional(),
    toDate: isoDateSchema.optional(),
    court_id: z.string().uuid().optional(),
    case_type: z.string().optional(),
    judge_id: z.string().uuid().optional()
  })
  .superRefine((value, context) => {
    const fromDate = value.from_date ?? value.fromDate;
    const toDate = value.to_date ?? value.toDate;
    if (!fromDate) context.addIssue({ code: z.ZodIssueCode.custom, message: 'Thiếu from_date/fromDate', path: ['from_date'] });
    if (!toDate) context.addIssue({ code: z.ZodIssueCode.custom, message: 'Thiếu to_date/toDate', path: ['to_date'] });
    if (value.from_date && value.fromDate && value.from_date !== value.fromDate) {
      context.addIssue({ code: z.ZodIssueCode.custom, message: 'from_date và fromDate không được khác nhau', path: ['fromDate'] });
    }
    if (value.to_date && value.toDate && value.to_date !== value.toDate) {
      context.addIssue({ code: z.ZodIssueCode.custom, message: 'to_date và toDate không được khác nhau', path: ['toDate'] });
    }
    if (fromDate && toDate && fromDate > toDate) {
      context.addIssue({ code: z.ZodIssueCode.custom, message: 'from_date phải nhỏ hơn hoặc bằng to_date', path: ['to_date'] });
    }
  })
  .transform((value) => ({
    from_date: (value.from_date ?? value.fromDate)!,
    to_date: (value.to_date ?? value.toDate)!,
    court_id: value.court_id,
    case_type: value.case_type,
    judge_id: value.judge_id
  }));

export type ReportPeriodQuery = z.infer<typeof reportPeriodQuerySchema>;

export type CasePeriodCategory = 'accepted_in_period' | 'opening_pending' | 'resolved_in_period';

export const casePeriodCategorySchema = z.enum([
  'accepted_in_period',
  'opening_pending',
  'resolved_in_period'
]);

export function buildCasePeriodCte(query: ReportPeriodQuery) {
  const values: unknown[] = [query.from_date, query.to_date];
  const filters = [
    'c.acceptance_date <= $2',
    "(c.closed_date is null or c.closed_date >= $1)"
  ];

  function addFilter(sql: string, value: unknown) {
    if (value === undefined || value === null || value === '') return;
    values.push(value);
    filters.push(sql.replace('?', `$${values.length}`));
  }

  addFilter('c.court_id = ?', query.court_id);
  addFilter('c.case_type = ?', query.case_type);
  addFilter('pa.user_id = ?', query.judge_id);

  return {
    values,
    sql: `
      with primary_assignments as (
        select distinct on (ca.case_id)
               ca.case_id,
               ca.user_id,
               ca.assignment_method,
               ca.assigned_date
        from case_assignments ca
        where ca.is_primary = true
          and ca.assignment_role = 'primary_judge'
          and ca.status in ('active', 'completed', 'replaced')
        order by ca.case_id, ca.assigned_date desc
      ),
      period_cases as (
        select c.case_id,
               c.case_code,
               c.case_number,
               c.case_type,
               c.case_group,
               c.case_status,
               c.current_stage,
               c.acceptance_date,
               c.closed_date,
               c.resolution_status,
               c.court_id,
               court.court_code,
               court.court_name,
               pa.user_id as judge_id,
               pa.assignment_method,
               coalesce(u.full_name, 'Chưa phân công') as judge_name,
               coalesce(v.open_validation_count, 0) as open_validation_count,
               (c.acceptance_date between $1::date and $2::date) as is_accepted_in_period,
               (
                 c.acceptance_date < $1::date
                 and (c.closed_date is null or c.closed_date > $2::date)
               ) as is_opening_pending,
               (c.closed_date between $1::date and $2::date) as is_resolved_in_period,
               (
                 c.acceptance_date <= $2::date
                 and (c.closed_date is null or c.closed_date > $2::date)
               ) as is_pending_at_period_end,
               (c.closed_date > $2::date) as is_resolved_after_period,
               case when c.closed_date is null or c.closed_date > $2::date then null else c.closed_date end as report_resolution_date,
               case when c.closed_date is null or c.closed_date > $2::date then null else c.resolution_status end as report_resolution_status,
               case
                 when c.closed_date > $2::date
                   then 'Giải quyết sau kỳ báo cáo: ' || to_char(c.closed_date, 'DD/MM/YYYY')
                 else null
               end as report_note
        from case_files c
        join courts court on court.court_id = c.court_id
        left join primary_assignments pa on pa.case_id = c.case_id
        left join users u on u.user_id = pa.user_id
        left join (
          select case_id, count(*)::int as open_validation_count
          from validation_results
          where validation_status = 'open'
          group by case_id
        ) v on v.case_id = c.case_id
        where ${filters.join(' and ')}
      )
    `
  };
}

export function categoryCondition(category: CasePeriodCategory) {
  const conditions: Record<CasePeriodCategory, string> = {
    accepted_in_period: 'is_accepted_in_period',
    opening_pending: 'is_opening_pending',
    resolved_in_period: 'is_resolved_in_period'
  };
  return conditions[category];
}
