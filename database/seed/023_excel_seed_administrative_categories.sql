-- Seed 023: Excel-derived administrative lawsuit categories.
-- Source: database/seed/danh sach/*.xlsx

WITH src(relationship_code, relationship_name, case_type_scope, source_document, notes, requires_human_review, sort_order) AS (
    VALUES
        ('excel_rel_hanh_vi_hanh_chinh', 'Hành vi hành chính', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 36', TRUE, 1),
        ('excel_rel_hanh_vi_hanh_chinh_quyet_inh_hanh_chinh', 'Hành vi hành chính, quyết định hành chính', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 3', TRUE, 2),
        ('excel_rel_hanh_vi_hanh_chinh_trong_linh_vuc_quan_ly_at_ai', 'Hành vi hành chính trong lĩnh vực quản lý đất đai', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 3),
        ('excel_rel_huy_quyet_inh_hanh_chinh', 'Hủy Quyết định hành chính', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 4),
        ('excel_rel_khieu_kien_hanh_vi_hanh_chinh', 'Khiếu kiện hành vi hành chính', 'administrative', 'Dân sự mở rộng - Phúc thẩm.xlsx; Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 71', TRUE, 5),
        ('excel_rel_khieu_kien_hanh_vi_hanh_chinh_cua_chu_tich_ubnd_xa_pho_phong', 'Khiếu kiện hành vi hành chính của Chủ tịch UBND xã Phổ Phong', 'administrative', 'Dân sự mở rộng - Phúc thẩm.xlsx', 'Sheet: Projects 3; count: 2', TRUE, 6),
        ('excel_rel_khieu_kien_hanh_vi_hanh_chinh_trong_linh_vuc_at_ai', 'Khiếu kiện hành vi hành chính trong lĩnh vực đất đai', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 2', TRUE, 7),
        ('excel_rel_khieu_kien_hanh_vi_hanh_chinh_trong_linh_vuc_quan_ly_at_ai', 'Khiếu kiện hành vi hành chính trong lĩnh vực quản lý đất đai', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 17', TRUE, 8),
        ('excel_rel_khieu_kien_hanh_vi_hanh_chinh_trong_linh_vuc_quan_ly_at_ai_va_yeu_cau_boi_thuong_thiet_hai', 'Khiếu kiện hành vi hành chính trong lĩnh vực quản lý đất đai và yêu cầu bồi thường thiệt hại', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 9),
        ('excel_rel_khieu_kien_hanh_vi_hanh_chinh_va_yeu_cau_boi_thuong_thiet_hai', 'Khiếu kiện hành vi hành chính và yêu cầu bồi thường thiệt hại', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 10),
        ('excel_rel_khieu_kien_q_hc', 'Khiếu kiện QĐHC', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 2', TRUE, 11),
        ('excel_rel_khieu_kien_qdhc', 'Khiếu kiện QDHC', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 2', TRUE, 12),
        ('excel_rel_khieu_kien_quyet_dinh_hanh_chinh_hanh_vi_hanh_chinh', 'Khiếu kiện quyết dịnh hành chính, hành vi hành chính', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 13),
        ('excel_rel_khieu_kien_quyet_inh_giai_quyet_khieu_nai', 'Khiếu kiện quyết định giải quyết khiếu nại', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 14),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh', 'Khiếu kiện quyết định hành chính', 'administrative', 'Dân sự mở rộng - Phúc thẩm.xlsx; Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 162', TRUE, 15),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_hanh_vi_hanh_chinh', 'Khiếu kiện quyết định hành chính, hành vi hành chính', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 7', TRUE, 16),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_hanh_vi_hanh_chinh_trong_linh_vuc_quan_ly_at_ai', 'Khiếu kiện quyết định hành chính, hành vi hành chính trong lĩnh vực quản lý đất đai', 'administrative', 'Dân sự mở rộng - Phúc thẩm.xlsx; Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 3', TRUE, 17),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_trong', 'Khiếu kiện quyết định hành chính trong', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 18),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_trong_linh_vuc_au_thau', 'Khiếu kiện quyết định hành chính trong lĩnh vực đấu thầu', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 19),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_trong_linh_vuc_chinh_sach_thuong_binh_xa_hoi', 'Khiếu kiện quyết định hành chính trong lĩnh vực chính sách thương binh - xã hội', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 20),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_trong_linh_vuc_quan_ly_at_ai', 'Khiếu kiện quyết định hành chính trong lĩnh vực quản lý đất đai', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 41', TRUE, 21),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_trong_linh_vuc_quan_ly_at_ai_va_yeu_cau_boi_thuong_thiet_hai', 'Khiếu kiện quyết định hành chính trong lĩnh vực quản lý đất đai và yêu cầu bồi thường thiệt hại', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 22),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_trong_linh_vuc_quan_ly_y_te', 'Khiếu kiện quyết định hành chính trong lĩnh vực quản lý y tế', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 23),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_va_yeu_cau_boi_thuong_thiet_hai', 'Khiếu kiện quyết định hành chính và yêu cầu bồi thường thiệt hại', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 24),
        ('excel_rel_khieu_kien_quyet_inh_hanh_chinh_ve_linh_vuc_quan_ly_at_ai', 'Khiếu kiện quyết định hành chính về lĩnh vực quản lý đất đai', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 25),
        ('excel_rel_khieu_kien_quyet_inh_phe_duyet_phuong_an_boi_thuong', 'Khiếu kiện quyết định phê duyệt phương án bồi thường', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 2', TRUE, 26),
        ('excel_rel_khieu_kien_quyet_inh_xu_phat_vi_pham_hanh_chinh', 'Khiếu kiện quyết định xử phạt vi phạm hành chính', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 2', TRUE, 27),
        ('excel_rel_khoi_kien_quyet_inh_hanh_chinh_trong_linh_vuc_quan_ly_at_ai', 'Khởi kiện quyết định hành chính trong lĩnh vực quản lý đất đai', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 28),
        ('excel_rel_linh_vuc_quan_ly_at_ai', 'lĩnh vực quản lý đất đai', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 29),
        ('excel_rel_quyet_inh_hanh_chinh', 'Quyết định hành chính', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 16', TRUE, 30),
        ('excel_rel_quyet_inh_hanh_chinh_hanh_vi_hanh_chinh', 'Quyết định hành chính, hành vi hành chính', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 3', TRUE, 31),
        ('excel_rel_quyet_inh_hanh_chinh_trong_linh_vuc_quan_ly_at_ai', 'Quyết định hành chính trong lĩnh vực quản lý đất đai', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 32),
        ('excel_rel_quyet_inh_hanh_chinh_trong_linh_vuc_quan_ly_thue', 'Quyết định hành chính trong lĩnh vực quản lý thuế', 'administrative', 'Dân sự mở rộng - Sơ thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 33),
        ('excel_rel_quyet_inh_xu_phat_vi_pham_hanh_chinh', 'Quyết định xử phạt vi phạm hành chính', 'administrative', 'Dân sự mở rộng - Phúc thẩm.xlsx', 'Sheet: Projects 3; count: 1', TRUE, 34)
)
INSERT INTO dm_legal_relationships (relationship_code, relationship_name, case_type_scope, source_document, notes, requires_human_review, sort_order)
SELECT s.relationship_code, s.relationship_name, s.case_type_scope, s.source_document, s.notes, s.requires_human_review, s.sort_order
FROM src s
WHERE NOT EXISTS (SELECT 1 FROM dm_legal_relationships r WHERE lower(btrim(r.relationship_name)) = lower(btrim(s.relationship_name)) AND COALESCE(r.case_type_scope, '') = COALESCE(s.case_type_scope, ''))
ON CONFLICT (relationship_code) DO UPDATE SET relationship_name = EXCLUDED.relationship_name, case_type_scope = EXCLUDED.case_type_scope, source_document = EXCLUDED.source_document, notes = EXCLUDED.notes, requires_human_review = EXCLUDED.requires_human_review, sort_order = EXCLUDED.sort_order, is_active = TRUE;
