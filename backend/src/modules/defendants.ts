import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { requireRoles } from '../common/auth.js';
import { writeAudit } from '../common/audit.js';
import { ApiError, ok } from '../common/http.js';
import { pool } from '../database/pool.js';

const defendantCreateSchema = z.object({
  case_id: z.string().uuid(),
  full_name: z.string().trim().min(1),
  date_of_birth: z.string().trim().optional().nullable(),
  gender: z.string().trim().optional().nullable(),
  nationality: z.string().trim().optional().nullable(),
  ethnicity: z.string().trim().optional().nullable(),
  occupation: z.string().trim().optional().nullable(),
  residence: z.string().trim().optional().nullable(),
  criminal_record_status: z.string().trim().optional().nullable(),
  is_minor: z.boolean().optional(),
  is_detained: z.boolean().optional(),
  detention_start_date: z.string().trim().optional().nullable(),
  detention_end_date: z.string().trim().optional().nullable()
});

const defendantQuerySchema = z.object({
  case_id: z.string().uuid().optional()
});

export async function defendantRoutes(app: FastifyInstance) {
  app.get('/defendants', async (request, reply) => {
    const query = defendantQuerySchema.parse(request.query);
    const values: unknown[] = [];
    const where: string[] = [];

    if (query.case_id) {
      values.push(query.case_id);
      where.push(`ccd.case_id = $${values.length}`);
    }

    const whereSql = where.length ? `where ${where.join(' and ')}` : '';
    const result = await pool.query(
      `select d.*,
              ccd.case_id
       from defendants d
       join criminal_case_details ccd on ccd.criminal_detail_id = d.criminal_detail_id
       ${whereSql}
       order by d.full_name`,
      values
    );
    return ok(reply, result.rows);
  });

  app.post('/defendants', async (request, reply) => {
    const user = requireRoles(request, ['admin', 'chief_judge', 'deputy_chief_judge']);
    const input = defendantCreateSchema.parse(request.body);
    const client = await pool.connect();

    try {
      await client.query('begin');
      const detail = await client.query(
        `select criminal_detail_id
         from criminal_case_details
         where case_id = $1
         limit 1`,
        [input.case_id]
      );
      if (!detail.rowCount) {
        throw new ApiError('BAD_REQUEST', 'Ho so chua co chi tiet an hinh su de nhap bi cao', 400);
      }

      const created = await client.query(
        `insert into defendants (
           criminal_detail_id,
           full_name,
           date_of_birth,
           gender,
           nationality,
           ethnicity,
           occupation,
           residence,
           criminal_record_status,
           is_minor,
           is_detained,
           detention_start_date,
           detention_end_date
         )
         values ($1, $2, $3, $4, $5, $6, $7, $8, $9, coalesce($10, false), coalesce($11, false), $12, $13)
         returning *`,
        [
          detail.rows[0].criminal_detail_id,
          input.full_name,
          input.date_of_birth,
          input.gender,
          input.nationality,
          input.ethnicity,
          input.occupation,
          input.residence,
          input.criminal_record_status,
          input.is_minor,
          input.is_detained,
          input.detention_start_date,
          input.detention_end_date
        ]
      );

      await writeAudit(client, {
        tableName: 'defendants',
        recordId: created.rows[0].defendant_id,
        action: 'defendants.create',
        actor: user,
        newData: { ...created.rows[0], case_id: input.case_id }
      });

      await client.query('commit');
      return reply.status(201).send({ success: true, data: created.rows[0], meta: {} });
    } catch (error) {
      await client.query('rollback');
      throw error;
    } finally {
      client.release();
    }
  });
}
