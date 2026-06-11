# Skill: Quy tắc án hình sự phúc thẩm theo từng bị cáo

## 1. Tên skill

`criminal_appellate_defendant_result_rules`

## 2. Mục đích

Quy định cách nhập dữ liệu, list danh sách và thống kê vụ án hình sự phúc thẩm theo từng bị cáo. Không áp dụng một kết quả phúc thẩm chung cho toàn bộ vụ án nếu các bị cáo có kết quả khác nhau.

## 3. Phạm vi

- Loại án: hình sự, mã hiện hành `criminal` hoặc mã tương đương `HINH_SU`.
- Cấp xét xử/nhóm án: phúc thẩm, `case_group = PHUC_THAM`.
- Đơn vị nghiệp vụ chi tiết: bị cáo trong vụ án hình sự phúc thẩm.
- Nguồn đối chiếu biểu mẫu: `knowledge_base/data/statistics/criminal/data_dictionary.json`, form `HS_PT_1B`.

## 4. Đơn vị dữ liệu

- Vụ án: `case_files.case_id`.
- Bị cáo: `defendants.defendant_id`, liên kết qua `criminal_case_details.case_id`.
- Kết quả giải quyết phúc thẩm theo bị cáo: `criminal_appellate_defendant_results.appellate_result_id`.
- Tiêu chí sửa án: `criminal_appellate_modify_criteria.id`.

## 5. Đơn vị thống kê

- Số vụ: tính theo `case_id`, nhưng chỉ coi vụ án đã giải quyết khi toàn bộ bị cáo thuộc phạm vi phúc thẩm đã có final result đến ngày chốt.
- Số bị cáo: tính theo `defendant_id` và final result.
- Số quyết định/kết quả theo loại: tính theo `appellate_result_id` hoặc `defendant_id` tùy chỉ tiêu.
- Đình chỉ, y án, sửa án, hủy án: thống kê theo bị cáo, không thống kê bằng cách gán một kết quả cho toàn vụ án.

## 6. Bảng nguồn

- `case_files`
- `criminal_case_details`
- `defendants`
- `criminal_appellate_defendant_results`
- `criminal_appellate_modify_criteria`
- `dm_categories`, `dm_category_items` nếu cần lọc bằng danh mục UUID.

## 7. Danh mục bắt buộc

- `case_type`: `criminal` hoặc mã tương đương `HINH_SU`.
- `case_group`: `PHUC_THAM`.
- `appellate_decision_stage`: `BEFORE_HEARING`, `AT_HEARING`, `AFTER_HEARING`.
- `appellate_defendant_result_group`: `TERMINATION`, `TRIAL`.
- `appellate_defendant_result_type`:
  - `WITHDRAWAL_BEFORE_HEARING`
  - `WITHDRAWAL_AT_HEARING`
  - `OTHER_TERMINATION`
  - `UPHOLD_FIRST_INSTANCE`
  - `MODIFY_FIRST_INSTANCE_SUBJECTIVE`
  - `MODIFY_FIRST_INSTANCE_OBJECTIVE`
  - `CANCEL_FIRST_INSTANCE_SUBJECTIVE`
  - `CANCEL_FIRST_INSTANCE_OBJECTIVE`
- `appellate_modify_criterion`:
  - `EXEMPT_CRIMINAL_LIABILITY_OR_PENALTY`
  - `SUSPENDED_SENTENCE_GRANTED`
  - `SUSPENDED_SENTENCE_NOT_GRANTED`
  - `REDUCE_PENALTY`
  - `CHANGE_TO_LIGHTER_PENALTY`
  - `INCREASE_PENALTY`
  - `CHANGE_TO_HEAVIER_PENALTY`
  - `CHANGE_CHARGE`

## 8. Quy tắc nhập dữ liệu

- Mỗi bị cáo chỉ có đúng một kết quả cuối cùng trong cùng một vụ án phúc thẩm: `UNIQUE (case_id, defendant_id) WHERE is_final_result IS TRUE`.
- `decision_stage_code = BEFORE_HEARING` chỉ dùng cho `WITHDRAWAL_BEFORE_HEARING` hoặc `OTHER_TERMINATION`.
- `decision_stage_code = AT_HEARING` dùng cho rút tại phiên tòa, đình chỉ khác tại phiên tòa, y án, sửa án, hủy án.
- `result_group_code = TERMINATION` chỉ gồm các loại đình chỉ.
- `result_group_code = TRIAL` chỉ gồm y án, sửa án, hủy án.
- Nếu `result_type_code` thuộc `MODIFY_FIRST_INSTANCE_*`, phải nhập ít nhất một dòng trong `criminal_appellate_modify_criteria`.
- `counted_as_defendant_resolved = TRUE` khi bị cáo có kết quả cuối cùng: đình chỉ, y án, sửa án hoặc hủy án.
- Không tự đặt `counted_as_case_resolved = TRUE` cho toàn vụ nếu vẫn còn bị cáo chưa có final result; cờ này chỉ là thông tin hỗ trợ, công thức chuẩn phải kiểm tra toàn bộ bị cáo.

## 9. Quy tắc list danh sách

Danh sách theo bị cáo phải xuất các cột tối thiểu:

- `case_id`, `case_code`, `case_number`
- `defendant_id`, `full_name`
- `appellate_result_id`
- `decision_stage_code`
- `result_group_code`
- `result_type_code`
- `result_date`
- `decision_number`
- `modify_criteria`

Không được group theo `case_id` nếu việc đó làm mất kết quả của từng bị cáo.

## 10. Quy tắc thống kê số vụ

Một vụ án phúc thẩm đã giải quyết tại `to_date` khi không còn bị cáo nào thuộc vụ án thiếu final result có `result_date <= to_date`.

```sql
NOT EXISTS (
    SELECT 1
    FROM criminal_case_details ccd
    JOIN defendants d ON d.criminal_detail_id = ccd.criminal_detail_id
    WHERE ccd.case_id = cf.case_id
      AND NOT EXISTS (
          SELECT 1
          FROM criminal_appellate_defendant_results r
          WHERE r.case_id = ccd.case_id
            AND r.defendant_id = d.defendant_id
            AND r.is_final_result = TRUE
            AND r.result_date <= :to_date
      )
)
```

## 11. Quy tắc thống kê số bị cáo

Một bị cáo đã giải quyết khi có đúng một final result đến ngày chốt:

```sql
SELECT COUNT(DISTINCT r.defendant_id)
FROM criminal_appellate_defendant_results r
JOIN case_files cf ON cf.case_id = r.case_id
WHERE cf.case_type IN ('criminal', 'HINH_SU')
  AND cf.case_group = 'PHUC_THAM'
  AND r.is_final_result = TRUE
  AND r.result_date <= :to_date;
```

## 12. Vụ án còn lại

Vụ án còn lại nếu còn ít nhất một bị cáo chưa có final result đến ngày chốt:

```sql
EXISTS (
    SELECT 1
    FROM criminal_case_details ccd
    JOIN defendants d ON d.criminal_detail_id = ccd.criminal_detail_id
    WHERE ccd.case_id = cf.case_id
      AND NOT EXISTS (
          SELECT 1
          FROM criminal_appellate_defendant_results r
          WHERE r.case_id = ccd.case_id
            AND r.defendant_id = d.defendant_id
            AND r.is_final_result = TRUE
            AND r.result_date <= :to_date
      )
)
```

## 13. Vụ án đã giải quyết

Vụ án đã giải quyết chỉ khi tất cả bị cáo trong phạm vi phúc thẩm đều có final result với `result_date <= :to_date`. Bị cáo rút kháng cáo trước phiên tòa được tính là bị cáo đã giải quyết nhưng không làm toàn vụ án đã giải quyết nếu còn bị cáo khác chưa có kết quả.

## 14. Quy tắc đình chỉ

- Rút kháng cáo/kháng nghị trước phiên tòa: `decision_stage_code = BEFORE_HEARING`, `result_type_code = WITHDRAWAL_BEFORE_HEARING`, `result_group_code = TERMINATION`.
- Rút kháng cáo/kháng nghị tại phiên tòa: `decision_stage_code = AT_HEARING`, `result_type_code = WITHDRAWAL_AT_HEARING`, `result_group_code = TERMINATION`.
- Đình chỉ khác: `result_type_code = OTHER_TERMINATION`; giai đoạn phụ thuộc thời điểm quyết định.

## 15. Quy tắc y án, sửa án, hủy án

- Y án sơ thẩm: `UPHOLD_FIRST_INSTANCE`.
- Sửa bản án sơ thẩm do nguyên nhân chủ quan: `MODIFY_FIRST_INSTANCE_SUBJECTIVE`.
- Sửa bản án sơ thẩm do nguyên nhân khách quan: `MODIFY_FIRST_INSTANCE_OBJECTIVE`.
- Hủy bản án sơ thẩm do nguyên nhân chủ quan: `CANCEL_FIRST_INSTANCE_SUBJECTIVE`.
- Hủy bản án sơ thẩm do nguyên nhân khách quan: `CANCEL_FIRST_INSTANCE_OBJECTIVE`.
- Không tự kết luận chủ quan/khách quan nếu hồ sơ không có căn cứ nghiệp vụ.

## 16. Quy tắc tiêu chí sửa án

Khi kết quả là sửa án, gắn một hoặc nhiều tiêu chí trong `criminal_appellate_modify_criteria`. Các tiêu chí này đối chiếu với `HS_PT_1B` trong `data_dictionary.json`, gồm các cột phân tích số bị cáo đã xét xử: miễn trách nhiệm hình sự/miễn hình phạt, án treo, không cho án treo, giảm/tăng hình phạt, chuyển hình phạt nhẹ hơn/nặng hơn, thay đổi tội danh.

## 17. SQL template

Danh sách bị cáo đình chỉ trước phiên tòa trong kỳ:

```sql
SELECT cf.case_code, cf.case_number, d.defendant_id, d.full_name, r.*
FROM case_files cf
JOIN criminal_case_details ccd ON ccd.case_id = cf.case_id
JOIN defendants d ON d.criminal_detail_id = ccd.criminal_detail_id
JOIN criminal_appellate_defendant_results r
  ON r.case_id = cf.case_id AND r.defendant_id = d.defendant_id
WHERE cf.case_type IN ('criminal', 'HINH_SU')
  AND cf.case_group = 'PHUC_THAM'
  AND r.result_type_code IN ('WITHDRAWAL_BEFORE_HEARING', 'OTHER_TERMINATION')
  AND r.decision_stage_code = 'BEFORE_HEARING'
  AND r.result_date BETWEEN :from_date AND :to_date;
```

Danh sách bị cáo đình chỉ tại phiên tòa:

```sql
SELECT cf.case_code, d.defendant_id, d.full_name, r.*
FROM case_files cf
JOIN criminal_case_details ccd ON ccd.case_id = cf.case_id
JOIN defendants d ON d.criminal_detail_id = ccd.criminal_detail_id
JOIN criminal_appellate_defendant_results r
  ON r.case_id = cf.case_id AND r.defendant_id = d.defendant_id
WHERE cf.case_type IN ('criminal', 'HINH_SU')
  AND cf.case_group = 'PHUC_THAM'
  AND r.result_type_code IN ('WITHDRAWAL_AT_HEARING', 'OTHER_TERMINATION')
  AND r.decision_stage_code = 'AT_HEARING'
  AND r.result_date BETWEEN :from_date AND :to_date;
```

Danh sách y án, sửa án, hủy án:

```sql
SELECT cf.case_code, d.defendant_id, d.full_name, r.result_type_code, r.result_date,
       string_agg(mc.criterion_code, ', ' ORDER BY mc.criterion_code) AS modify_criteria
FROM case_files cf
JOIN criminal_case_details ccd ON ccd.case_id = cf.case_id
JOIN defendants d ON d.criminal_detail_id = ccd.criminal_detail_id
JOIN criminal_appellate_defendant_results r
  ON r.case_id = cf.case_id AND r.defendant_id = d.defendant_id
LEFT JOIN criminal_appellate_modify_criteria mc
  ON mc.appellate_result_id = r.appellate_result_id
WHERE cf.case_type IN ('criminal', 'HINH_SU')
  AND cf.case_group = 'PHUC_THAM'
  AND r.result_type_code IN (
      'UPHOLD_FIRST_INSTANCE',
      'MODIFY_FIRST_INSTANCE_SUBJECTIVE',
      'MODIFY_FIRST_INSTANCE_OBJECTIVE',
      'CANCEL_FIRST_INSTANCE_SUBJECTIVE',
      'CANCEL_FIRST_INSTANCE_OBJECTIVE'
  )
  AND r.result_date BETWEEN :from_date AND :to_date
GROUP BY cf.case_code, d.defendant_id, d.full_name, r.result_type_code, r.result_date;
```

## 18. Edge cases

1. Một vụ có nhiều bị cáo, chỉ một bị cáo rút kháng cáo trước phiên tòa: bị cáo đó đã giải quyết, vụ án vẫn còn lại nếu bị cáo khác chưa có kết quả.
2. Tại cùng một phiên tòa có bị cáo đình chỉ, bị cáo y án, bị cáo sửa án, bị cáo hủy án: phải lưu từng dòng theo `defendant_id`.
3. Kết quả sau ngày chốt không được làm vụ án đã giải quyết tại ngày chốt.
4. Một bị cáo có nhiều hơn một final result là lỗi dữ liệu.
5. Sửa án không có tiêu chí sửa án là lỗi dữ liệu thống kê.

## 19. Test cases

Test chuẩn nằm tại:

- `database/seed/test/050_test_criminal_appellate_defendant_results.sql`
- `tests/database/test_criminal_appellate_defendant_result_skill.sql`
- `tests/database/run_criminal_appellate_defendant_result_skill_check.ps1`

Dữ liệu kiểm tra gồm `HSPT-001` đến `HSPT-005`, chứng minh các trường hợp rút kháng cáo trước phiên tòa, rút tại phiên tòa, y án, sửa án, hủy án và vụ còn bị cáo chưa có kết quả.

## 20. Liên kết với data_dictionary.json

`knowledge_base/data/statistics/criminal/data_dictionary.json` form `HS_PT_1B` có các cột phúc thẩm hình sự theo bị cáo, đặc biệt:

- Đình chỉ/rút kháng cáo, kháng nghị: cột P-W.
- Xét xử: cột X-AC.
- Còn lại: cột AD-AI.
- Phân tích số bị cáo đã xét xử và tiêu chí sửa án: cột AO-AW.
- Sửa/hủy do cấp sơ thẩm sai hoặc do tình tiết mới: cột BB-BK.

Khi mở rộng công thức chi tiết theo biểu mẫu, phải đối chiếu lại từng cột với PDF nguồn và không tự tạo chỉ tiêu ngoài tài liệu.
