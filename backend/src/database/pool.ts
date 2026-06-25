import pg from 'pg';
import { env } from '../config/env.js';

const { Pool } = pg;

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
