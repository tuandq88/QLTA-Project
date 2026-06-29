import pg from 'pg';
import { env } from '../config/env.js';

const { Pool, types } = pg;

// PostgreSQL DATE không có múi giờ. Giữ nguyên YYYY-MM-DD để tránh lệch một ngày
// khi JSON/PDF/Excel được tạo trên máy chủ có timezone khác với database.
types.setTypeParser(1082, (value) => value);

export const pool = new Pool(
  env.DATABASE_URL
    ? { connectionString: env.DATABASE_URL }
    : {
        host: env.PGHOST,
        port: env.PGPORT,
        user: env.PGUSER,
        password: env.PGPASSWORD,
        database: env.PGDATABASE
      }
);

export async function checkDatabase(): Promise<void> {
  await pool.query('select 1');
}
