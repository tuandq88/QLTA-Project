import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config({ path: '../.env.local', override: true });
dotenv.config();

const envSchema = z.object({
  NODE_ENV: z.string().default('development'),
  PORT: z.coerce.number().int().positive().default(3000),
  HOST: z.string().default('127.0.0.1'),
  DATABASE_URL: z.string().optional(),
  PGHOST: z.string().optional(),
  PGPORT: z.coerce.number().int().positive().optional(),
  PGUSER: z.string().optional(),
  PGPASSWORD: z.string().optional(),
  PGDATABASE: z.string().optional(),
  AUTH_REQUIRED: z
    .enum(['true', 'false'])
    .default('false')
    .transform((value) => value === 'true'),
  JWT_SECRET: z.string().min(16).default('local-development-secret-change-me'),
  JWT_EXPIRES_IN: z.string().default('8h')
});

export const env = envSchema.parse(process.env);
