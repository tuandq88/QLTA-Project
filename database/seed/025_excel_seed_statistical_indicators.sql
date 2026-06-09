-- Seed 025: Excel-derived statistical indicators and dropdown options.
-- Source: database/seed/danh sach/*.xlsx

INSERT INTO statistical_categories (category_code, category_name, description, case_type_scope, sort_order) VALUES
    ('excel_input_dropdowns', 'Dropdown t? Excel danh s?ch ?n', 'C?c option UI tr?ch t? file Excel danh s?ch ?n, c?n r? so?t tr??c khi d?ng l?m catalog nghi?p v? ch?nh th?c.', NULL, 430)
ON CONFLICT (category_code) DO UPDATE SET category_name = EXCLUDED.category_name, description = EXCLUDED.description, sort_order = EXCLUDED.sort_order, updated_at = CURRENT_TIMESTAMP;

WITH category_ref AS (SELECT statistical_category_id FROM statistical_categories WHERE category_code = 'excel_input_dropdowns'),
indicators(indicator_code, indicator_name, input_control_type, value_type, allow_multiple, applies_to_entity, description, sort_order) AS (
    VALUES
        ('excel_hearing_format', 'H?nh th?c x?t x?/h?p', 'dropdown', 'option', FALSE, 'hearing', 'Dropdown t? c?t H?nh th?c x?t x? trong Excel.', 10),
        ('excel_appellate_result_detail', 'K?t qu? ph?c th?m/c?p tr?n chi ti?t', 'dropdown', 'option', FALSE, 'appellate_tracking', 'Dropdown t? c?t K?t qu? XXPT trong Excel; c?n r? so?t nghi?p v?.', 20)
)
INSERT INTO statistical_indicators (statistical_category_id, indicator_code, indicator_name, input_control_type, value_type, allow_multiple, applies_to_entity, description, sort_order)
SELECT c.statistical_category_id, i.indicator_code, i.indicator_name, i.input_control_type, i.value_type, i.allow_multiple, i.applies_to_entity, i.description, i.sort_order
FROM indicators i CROSS JOIN category_ref c
ON CONFLICT (indicator_code) DO UPDATE SET indicator_name = EXCLUDED.indicator_name, input_control_type = EXCLUDED.input_control_type, value_type = EXCLUDED.value_type, allow_multiple = EXCLUDED.allow_multiple, applies_to_entity = EXCLUDED.applies_to_entity, description = EXCLUDED.description, sort_order = EXCLUDED.sort_order, updated_at = CURRENT_TIMESTAMP;

WITH option_seed(indicator_code, option_code, option_name, sort_order, description) AS (
    VALUES
        ('excel_hearing_format', 'hearing_xu_hop_cong_khai_truc_tiep', 'Xử/Họp công khai trực tiếp', 1, 'H?nh th?c x?t x?/h?p t? Excel; count: 802'),
        ('excel_hearing_format', 'hearing_xu_hop_cong_khai_truc_tuyen', 'Xử/Họp công khai trực tuyến', 2, 'H?nh th?c x?t x?/h?p t? Excel; count: 35'),
        ('excel_hearing_format', 'hearing_xu_hop_kin_truc_tiep', 'Xử/Họp kín trực tiếp', 3, 'H?nh th?c x?t x?/h?p t? Excel; count: 24'),
        ('excel_hearing_format', 'hearing_xu_hop_kin_truc_tuyen', 'Xử/Họp kín trực tuyến', 4, 'H?nh th?c x?t x?/h?p t? Excel; count: 1'),
        ('excel_appellate_result_detail', 'appellate_result_giu_nguyen_ban_an_quyet_inh_so_tham', 'Giữ nguyên bản án, quyết định sơ thẩm', 5, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 397'),
        ('excel_appellate_result_detail', 'appellate_result_giu_nguyen_quyet_inh_cua_toa_an_cap_so_tham', 'Giữ nguyên quyết định của Tòa án cấp sơ thẩm', 6, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 12'),
        ('excel_appellate_result_detail', 'appellate_result_huy_ban_an_quyet_inh_so_tham_e_ieu_tra_lai', 'Hủy bản án, quyết định sơ thẩm để điều tra lại', 7, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 8'),
        ('excel_appellate_result_detail', 'appellate_result_huy_ban_an_quyet_inh_so_tham_va_inh_chi_giai_quyet_vu_an', 'Hủy bản án, quyết định sơ thẩm và đình chỉ giải quyết vụ án', 8, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 10'),
        ('excel_appellate_result_detail', 'appellate_result_huy_mot_phan_ban_an_quyet_inh_so_tham_e_giai_quyet_lai_vu_an_theo_thu_tuc_so_tham', 'Hủy một phần bản án, quyết định sơ thẩm để giải quyết lại vụ án theo thủ tục sơ thẩm', 9, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 24'),
        ('excel_appellate_result_detail', 'appellate_result_huy_quyet_inh_cua_toa_an_cap_so_tham_va_chuyen_ho_so_vu_an_cho_toa_an_cap_so_tham_e_tiep_tuc_giai_quyet_vu_an', 'Hủy quyết định của Tòa án cấp sơ thẩm và chuyển hồ sơ vụ án cho Tòa án cấp sơ thẩm để tiếp tục giải quyết vụ án', 10, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 3'),
        ('excel_appellate_result_detail', 'appellate_result_huy_toan_bo_ban_an_quyet_inh_so_tham_e_giai_quyet_lai_vu_an_theo_thu_tuc_so_tham', 'Hủy toàn bộ bản án, quyết định sơ thẩm để giải quyết lại vụ án theo thủ tục sơ thẩm', 11, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 68'),
        ('excel_appellate_result_detail', 'appellate_result_q_inh_chi', 'QĐ đình chỉ', 12, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 176'),
        ('excel_appellate_result_detail', 'appellate_result_quyet_inh_huy_ban_an_so_tham_va_inh_chi_giai_quyet_vu_an_dan_su', 'Quyết định huỷ bản án sơ thẩm và đình chỉ giải quyết vụ án dân sự', 13, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 10'),
        ('excel_appellate_result_detail', 'appellate_result_quyet_inh_huy_ban_an_so_tham_va_inh_chi_giai_quyet_vu_an_hanh_chinh', 'Quyết định huỷ bản án sơ thẩm và đình chỉ giải quyết vụ án hành chính', 14, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 1'),
        ('excel_appellate_result_detail', 'appellate_result_quyet_inh_phuc_tham_giai_quyet_viec_dan_su', 'Quyết định phúc thẩm giải quyết việc dân sự', 15, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 2'),
        ('excel_appellate_result_detail', 'appellate_result_sua_mot_phan_ban_an_quyet_inh_so_tham', 'Sửa một phần bản án, quyết định sơ thẩm', 16, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 114'),
        ('excel_appellate_result_detail', 'appellate_result_sua_quyet_inh_cua_toa_an_cap_so_tham', 'Sửa quyết định của Tòa án cấp sơ thẩm', 17, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 2'),
        ('excel_appellate_result_detail', 'appellate_result_sua_toan_bo_ban_an_quyet_inh_so_tham', 'Sửa toàn bộ bản án, quyết định sơ thẩm', 18, 'K?t qu? ph?c th?m/c?p tr?n chi ti?t t? Excel; c?n review tr??c khi map v?o dm_appellate_result_codes; count: 16')
)
INSERT INTO statistical_indicator_options (statistical_indicator_id, option_code, option_name, sort_order, description)
SELECT i.statistical_indicator_id, o.option_code, o.option_name, o.sort_order, o.description
FROM option_seed o JOIN statistical_indicators i ON i.indicator_code = o.indicator_code
ON CONFLICT (statistical_indicator_id, option_code) DO UPDATE SET option_name = EXCLUDED.option_name, sort_order = EXCLUDED.sort_order, description = EXCLUDED.description, updated_at = CURRENT_TIMESTAMP;
