-- Seed 020: Excel-derived case category aliases and hearing formats.
-- Source: database/seed/danh sach/*.xlsx

INSERT INTO dm_categories (category_code, category_name, description, sort_order) VALUES
    ('excel_case_type_alias', 'Alias lo?i ?n t? Excel', 'Gi? tr? lo?i ?n xu?t hi?n trong file Excel danh s?ch ?n; d?ng ?? mapping/backfill, kh?ng thay th? catalog chu?n.', 410),
    ('excel_hearing_format', 'H?nh th?c x?t x?/h?p t? Excel', 'Dropdown h?nh th?c x?t x?/h?p ??c t? file Excel danh s?ch ?n.', 420)
ON CONFLICT (category_code) DO UPDATE SET category_name = EXCLUDED.category_name, description = EXCLUDED.description, sort_order = EXCLUDED.sort_order, updated_at = CURRENT_TIMESTAMP;

WITH items(category_code, item_code, item_name, sort_order, description, metadata) AS (
    VALUES
        ('excel_case_type_alias', 'case_alias_dan_su', 'Dân sự', 1, 'Alias lo?i ?n; c?n mapping v? case_type chu?n.', '{"source": "database/seed/danh sach", "count": 687, "requires_human_review": true}'::jsonb),
        ('excel_case_type_alias', 'case_alias_hanh_chinh', 'Hành chính', 2, 'Alias lo?i ?n; c?n mapping v? case_type chu?n.', '{"source": "database/seed/danh sach", "count": 388, "requires_human_review": true}'::jsonb),
        ('excel_case_type_alias', 'case_alias_hngd', 'HNGD', 3, 'Alias lo?i ?n; c?n mapping v? case_type chu?n.', '{"source": "database/seed/danh sach", "count": 48, "requires_human_review": true}'::jsonb),
        ('excel_case_type_alias', 'case_alias_hon_nhan_gia_inh', 'Hôn nhân gia đình', 4, 'Alias lo?i ?n; c?n mapping v? case_type chu?n.', '{"source": "database/seed/danh sach", "count": 63, "requires_human_review": true}'::jsonb),
        ('excel_case_type_alias', 'case_alias_kdtm', 'KDTM', 5, 'Alias lo?i ?n; c?n mapping v? case_type chu?n.', '{"source": "database/seed/danh sach", "count": 4, "requires_human_review": true}'::jsonb),
        ('excel_case_type_alias', 'case_alias_kinh_doanh_thuong_mai', 'Kinh doanh, thương mại', 6, 'Alias lo?i ?n; c?n mapping v? case_type chu?n.', '{"source": "database/seed/danh sach", "count": 33, "requires_human_review": true}'::jsonb),
        ('excel_case_type_alias', 'case_alias_lao_ong', 'Lao động', 7, 'Alias lo?i ?n; c?n mapping v? case_type chu?n.', '{"source": "database/seed/danh sach", "count": 2, "requires_human_review": true}'::jsonb),
        ('excel_hearing_format', 'hearing_format_xu_hop_cong_khai_truc_tiep', 'Xử/Họp công khai trực tiếp', 8, 'H?nh th?c x?t x?/h?p ??c t? Excel.', '{"source": "database/seed/danh sach", "count": 802, "requires_human_review": false}'::jsonb),
        ('excel_hearing_format', 'hearing_format_xu_hop_cong_khai_truc_tuyen', 'Xử/Họp công khai trực tuyến', 9, 'H?nh th?c x?t x?/h?p ??c t? Excel.', '{"source": "database/seed/danh sach", "count": 35, "requires_human_review": false}'::jsonb),
        ('excel_hearing_format', 'hearing_format_xu_hop_kin_truc_tiep', 'Xử/Họp kín trực tiếp', 10, 'H?nh th?c x?t x?/h?p ??c t? Excel.', '{"source": "database/seed/danh sach", "count": 24, "requires_human_review": false}'::jsonb),
        ('excel_hearing_format', 'hearing_format_xu_hop_kin_truc_tuyen', 'Xử/Họp kín trực tuyến', 11, 'H?nh th?c x?t x?/h?p ??c t? Excel.', '{"source": "database/seed/danh sach", "count": 1, "requires_human_review": false}'::jsonb)
)
INSERT INTO dm_category_items (category_id, item_code, item_name, sort_order, description, metadata)
SELECT c.category_id, i.item_code, i.item_name, i.sort_order, i.description, i.metadata
FROM items i JOIN dm_categories c ON c.category_code = i.category_code
ON CONFLICT (category_id, item_code) DO UPDATE SET item_name = EXCLUDED.item_name, sort_order = EXCLUDED.sort_order, description = EXCLUDED.description, metadata = EXCLUDED.metadata, updated_at = CURRENT_TIMESTAMP;
