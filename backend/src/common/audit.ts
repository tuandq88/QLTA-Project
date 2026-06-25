import type { PoolClient } from 'pg';
import type { CurrentUser } from './auth.js';

export async function writeAudit(
  client: PoolClient,
  params: {
    tableName: string;
    recordId?: string | null;
    action: string;
    actor?: CurrentUser | null;
    oldData?: unknown;
    newData?: unknown;
  }
) {
  await client.query(
    `insert into audit_logs (table_name, record_id, action, actor_id, old_data, new_data)
     values ($1, $2, $3, $4, $5, $6)`,
    [
      params.tableName,
      params.recordId ?? null,
      params.action,
      params.actor?.userId || null,
      params.oldData ? JSON.stringify(params.oldData) : null,
      params.newData ? JSON.stringify(params.newData) : null
    ]
  );
}
