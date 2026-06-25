import { z } from 'zod';

export const paginationSchema = z.object({
  page: z.coerce.number().int().positive().default(1),
  pageSize: z.coerce.number().int().positive().max(100).default(20),
  search: z.string().trim().optional()
});

export type Pagination = z.infer<typeof paginationSchema>;

export function pageMeta(total: number, pagination: Pagination) {
  return {
    total,
    page: pagination.page,
    pageSize: pagination.pageSize,
    pageCount: Math.ceil(total / pagination.pageSize)
  };
}
