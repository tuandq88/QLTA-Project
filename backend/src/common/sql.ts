import { ApiError } from './http.js';

export function assertColumn(column: string, allowed: readonly string[]) {
  if (!allowed.includes(column)) {
    throw new ApiError('BAD_REQUEST', `Cot du lieu khong hop le: ${column}`, 400);
  }
}

export function selectFields(alias: string, fields: readonly string[]) {
  return fields.map((field) => `${alias}.${field}`).join(', ');
}

export function buildInsert(table: string, input: Record<string, unknown>, allowed: readonly string[]) {
  const entries = Object.entries(input).filter(([, value]) => value !== undefined);
  for (const [column] of entries) assertColumn(column, allowed);
  if (entries.length === 0) throw new ApiError('VALIDATION_ERROR', 'Khong co du lieu de ghi', 400);
  const columns = entries.map(([column]) => column);
  const values = entries.map(([, value]) => value);
  const params = values.map((_, index) => `$${index + 1}`);
  return {
    text: `insert into ${table} (${columns.join(', ')}) values (${params.join(', ')}) returning *`,
    values
  };
}

export function buildUpdate(
  table: string,
  idColumn: string,
  id: string,
  input: Record<string, unknown>,
  allowed: readonly string[]
) {
  const entries = Object.entries(input).filter(([, value]) => value !== undefined);
  for (const [column] of entries) assertColumn(column, allowed);
  if (entries.length === 0) throw new ApiError('VALIDATION_ERROR', 'Khong co du lieu de cap nhat', 400);
  const setSql = entries.map(([column], index) => `${column} = $${index + 2}`).join(', ');
  return {
    text: `update ${table} set ${setSql} where ${idColumn} = $1 returning *`,
    values: [id, ...entries.map(([, value]) => value)]
  };
}
