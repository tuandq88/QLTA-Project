import type { Pool, PoolClient } from 'pg';
import { ApiError } from './http.js';
import { buildInsert, buildUpdate } from './sql.js';

export type TableConfig = {
  table: string;
  idColumn: string;
  selectable: readonly string[];
  writable: readonly string[];
  searchable?: readonly string[];
  defaultOrder?: string;
};

export class Repository {
  constructor(private readonly db: Pool | PoolClient, private readonly config: TableConfig) {}

  async list(options: { filters?: Record<string, unknown>; page?: number; pageSize?: number; search?: string }) {
    const where: string[] = [];
    const values: unknown[] = [];
    for (const [key, value] of Object.entries(options.filters ?? {})) {
      if (value === undefined || value === null || value === '') continue;
      if (!this.config.selectable.includes(key)) continue;
      values.push(value);
      where.push(`${key} = $${values.length}`);
    }
    if (options.search && this.config.searchable?.length) {
      values.push(`%${options.search}%`);
      const p = `$${values.length}`;
      where.push(`(${this.config.searchable.map((field) => `${field} ilike ${p}`).join(' or ')})`);
    }
    const whereSql = where.length ? `where ${where.join(' and ')}` : '';
    const count = await this.db.query<{ total: string }>(`select count(*)::text as total from ${this.config.table} ${whereSql}`, values);
    const page = options.page ?? 1;
    const pageSize = options.pageSize ?? 20;
    values.push(pageSize, (page - 1) * pageSize);
    const rows = await this.db.query(
      `select ${this.config.selectable.join(', ')}
       from ${this.config.table}
       ${whereSql}
       order by ${this.config.defaultOrder ?? this.config.idColumn} desc
       limit $${values.length - 1} offset $${values.length}`,
      values
    );
    return { rows: rows.rows, total: Number(count.rows[0]?.total ?? 0) };
  }

  async get(id: string) {
    const result = await this.db.query(
      `select ${this.config.selectable.join(', ')} from ${this.config.table} where ${this.config.idColumn} = $1`,
      [id]
    );
    if (!result.rowCount) throw new ApiError('NOT_FOUND', 'Khong tim thay ban ghi', 404);
    return result.rows[0];
  }

  async create(input: Record<string, unknown>) {
    const result = await this.db.query(buildInsert(this.config.table, input, this.config.writable));
    return result.rows[0];
  }

  async update(id: string, input: Record<string, unknown>) {
    const result = await this.db.query(buildUpdate(this.config.table, this.config.idColumn, id, input, this.config.writable));
    if (!result.rowCount) throw new ApiError('NOT_FOUND', 'Khong tim thay ban ghi', 404);
    return result.rows[0];
  }
}
