import type { FastifyInstance } from 'fastify';
import { pool } from '../database/pool.js';
import { ok } from '../common/http.js';
import { tableConfigs } from '../common/table-config.js';
import { crudRoutes } from './generic-crud.js';

export async function catalogRoutes(app: FastifyInstance) {
  await crudRoutes(app, {
    prefix: '/courts',
    config: tableConfigs.courts,
    filterFields: ['parent_court_id', 'court_level', 'is_active']
  });
  await crudRoutes(app, {
    prefix: '/categories',
    config: tableConfigs.categories,
    filterFields: ['is_active', 'is_system']
  });
  await crudRoutes(app, {
    prefix: '/category-items',
    config: tableConfigs.categoryItems,
    filterFields: ['category_id', 'parent_item_id', 'is_active']
  });

  app.get('/categories/:categoryCode/items', async (request, reply) => {
    const { categoryCode } = request.params as { categoryCode: string };
    const result = await pool.query(
      `select i.item_id, i.category_id, i.item_code, i.item_name, i.parent_item_id, i.description,
              i.legal_basis, i.is_active, i.sort_order, i.metadata
       from dm_category_items i
       join dm_categories c on c.category_id = i.category_id
       where c.category_code = $1
       order by i.sort_order, i.item_code`,
      [categoryCode]
    );
    return ok(reply, result.rows, { categoryCode });
  });
}
