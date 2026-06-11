# Skill: Danh sách án hình sự sơ thẩm trả hồ sơ cho Viện kiểm sát

## 1. Tên skill

`criminal_first_instance_return_to_procuracy_list`

## 2. Mục đích

Tạo danh sách chi tiết các vụ án hình sự sơ thẩm có lần giải quyết là Tòa án trả hồ sơ cho Viện kiểm sát để điều tra bổ sung trong một kỳ thống kê. Skill này dùng để list dữ liệu chi tiết, không chỉ đếm số lượng.

## 3. Phạm vi áp dụng

- Loại án: hình sự.
- Cấp xét xử: sơ thẩm.
- Kết quả/lần giải quyết: trả hồ sơ cho Viện kiểm sát để điều tra bổ sung.
- Đơn vị tính thống kê: `OCCURRENCE`, không phải `CASE_ID`.

## 4. Định nghĩa nghiệp vụ

- Hồ sơ vụ án gốc: `case_files.case_id`, đại diện cho cùng một vụ án về mặt quản lý hồ sơ.
- Lần thụ lý: một occurrence/vòng đời thống kê của vụ án. Mỗi lần thụ lý ban đầu hoặc thụ lý lại sau điều tra bổ sung là một dòng thụ lý riêng.
- Lần giải quyết: event kết thúc một occurrence. Trả hồ sơ cho Viện kiểm sát để điều tra bổ sung là một loại giải quyết.
- Lần trả hồ sơ: event/resolution có ngày quyết định trả hồ sơ. Mỗi lần trả hồ sơ được tính là một lần đã giải quyết một occurrence.
- Lần xét xử ra bản án: lần giải quyết bằng bản án/quyết định xét xử, không thuộc danh sách trả hồ sơ nếu skill đang lọc riêng trả hồ sơ.

Không được hiểu một `case_id` chỉ có một lần thụ lý và một lần giải quyết. Một `case_id` có thể có nhiều `case lifecycle occurrences` hoặc `statistical occurrences`.

## 5. Đơn vị tính

- `statistical_count_unit = OCCURRENCE`.
- Mỗi event trả hồ sơ hợp lệ là một dòng trong danh sách.
- Nếu một `case_id` có 2 lần trả hồ sơ trong kỳ thì danh sách phải có 2 dòng.
- Không group theo `case_id` nếu việc đó làm mất các lần trả hồ sơ.

## 6. Input

- `from_date`: ngày bắt đầu kỳ.
- `to_date`: ngày kết thúc kỳ/as-of date.
- `court_id`: tùy chọn.
- `case_type`: mặc định `HINH_SU` hoặc mã chuẩn hiện hành tương đương.
- `case_group`: mặc định `SO_THAM`.

## 7. Output columns

Thông tin hồ sơ gốc:

- `case_id`
- `case_code`
- `case_number`
- `case_type`
- `case_group`
- `court_id`
- `court_name`
- `summary`

Thông tin occurrence/vòng đời:

- `occurrence_id`
- `occurrence_no`
- `acceptance_date`
- `acceptance_type_code`
- `previous_return_date`
- `is_reaccepted_after_supplemental_investigation`

Thông tin trả hồ sơ:

- `return_event_id` hoặc `resolution_id`
- `return_decision_number`
- `return_decision_date`
- `return_reason`
- `return_to_agency`
- `resolution_type_code`
- `resolution_date`
- `counted_as_resolved`

Thông tin thống kê:

- `in_accepted_period`
- `in_resolved_period`
- `unresolved_as_of_to_date`
- `statistical_count_unit`
- `list_reason`

Thông tin hình sự nếu schema có:

- `crime_charge`
- `law_article`
- `defendant_count`
- `minor_defendant_count`
- `presiding_judge`
- `panel_judges`
- `hearing_clerks`

## 8. Required tables

Schema chuẩn cần có:

- `case_files`
- `case_occurrences` hoặc `case_lifecycle_occurrences`
- `case_resolution_events` hoặc bảng event tương đương có `occurrence_id`, `resolution_type_code`, `counted_as_resolved`
- `criminal_case_details`
- `defendants`
- `charges`
- `case_hearing_members`, `court_staff` nếu cần thông tin thành phần phiên tòa

### Trạng thái schema hiện tại

Schema chuẩn sau migration `007_case_occurrences_and_resolution_events.sql` có:

- `case_occurrences`: lưu từng lần thụ lý/vòng đời thống kê của `case_id`.
- `case_resolution_events`: lưu từng event giải quyết gắn với `occurrence_id`, bao gồm trả hồ sơ cho VKS và xét xử ra bản án.

Vẫn phải cảnh báo khi database chưa chạy migration 007 hoặc dữ liệu chỉ có:

- `case_files.acceptance_date`
- `case_files.closed_date`
- `case_events`
- `investigation_returns`

Vì các bảng/cột này không đủ để list đúng nhiều lần thụ lý - trả hồ sơ - thụ lý lại trên cùng một `case_id`.

Không được dùng `case_files.closed_date` để thay thế event trả hồ sơ nếu điều đó làm mất nhiều lần trả hồ sơ trên cùng một `case_id`.

## 9. Required categories/codes

Các mã chuẩn cần có hoặc cần seed bổ sung:

- Loại án: `HINH_SU` hoặc mã hiện hành tương đương `criminal`.
- Cấp xét xử: `SO_THAM`.
- Loại thụ lý:
  - `INITIAL_ACCEPTANCE`
  - `RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION`
- Loại sự kiện/kết quả:
  - `RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION`
  - `TRIAL_JUDGMENT`
- Cơ quan nhận hồ sơ:
  - `PROCURACY`
  - `VIEN_KIEM_SAT` nếu dự án chọn mã tiếng Việt không dấu.
- Đơn vị tính thống kê:
  - `OCCURRENCE`

Nếu các mã trên chưa có trong `dm_categories/dm_category_items`, phải bổ sung seed danh mục trước khi dùng trong báo cáo chính thức.

## 10. Calculation/list logic

Danh sách trả hồ sơ trong kỳ:

- Lấy occurrence của vụ án hình sự sơ thẩm.
- Join `case_files`.
- Join `case_occurrences` hoặc bảng tương đương.
- Join `case_resolution_events` hoặc bảng event tương đương.
- Lọc:
  - `case_type = HINH_SU` hoặc mã hiện hành tương đương.
  - `case_group = SO_THAM`.
  - `resolution_type_code = RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION`.
  - `counted_as_resolved = TRUE`.
  - `event_date BETWEEN from_date AND to_date`.
- Mỗi event trả hồ sơ là một dòng.
- Nếu cần group, chỉ group theo `event_id` hoặc `occurrence_id`, không group theo `case_id`.

Ảnh hưởng đến các list khác:

- Danh sách thụ lý trong kỳ: lấy `occurrence.acceptance_date BETWEEN from_date AND to_date`; mỗi occurrence là một dòng.
- Danh sách giải quyết trong kỳ: lấy event `counted_as_resolved = TRUE` và `event_date BETWEEN from_date AND to_date`; trả hồ sơ và xét xử ra bản án đều là giải quyết.
- Danh sách còn lại đến `to_date`: occurrence có `acceptance_date <= to_date` và chưa có event `counted_as_resolved = TRUE` với `event_date <= to_date`; nếu có giải quyết sau `to_date` thì vẫn là còn lại tại `to_date`.

## 11. SQL template

```sql
WITH params AS (
    SELECT :from_date::date AS from_date,
           :to_date::date AS to_date
),
base_returns AS (
    SELECT
        cf.case_id,
        co.occurrence_id,
        co.occurrence_no,
        cre.resolution_event_id,
        cf.case_number,
        cf.case_code,
        cf.case_type,
        cf.case_group,
        co.acceptance_date,
        co.acceptance_type_code,
        cre.event_date AS return_decision_date,
        cre.decision_number AS return_decision_number,
        cre.resolution_type_code,
        cre.return_to_agency_code,
        cre.reason,
        cre.counted_as_resolved
    FROM case_files cf
    JOIN case_occurrences co
        ON co.case_id = cf.case_id
    JOIN case_resolution_events cre
        ON cre.occurrence_id = co.occurrence_id
    JOIN params p ON TRUE
    WHERE cf.case_type IN ('HINH_SU', 'criminal')
      AND cf.case_group = 'SO_THAM'
      AND cre.resolution_type_code = 'RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION'
      AND cre.counted_as_resolved = TRUE
      AND cre.event_date BETWEEN p.from_date AND p.to_date
)
SELECT *
FROM base_returns
ORDER BY return_decision_date, case_number, occurrence_no;
```

Nếu schema dùng FK danh mục, thay điều kiện text bằng join `dm_category_items` và lọc theo `item_code`.

## 12. Edge cases

1. Một `case_id` có nhiều lần trả hồ sơ trong cùng kỳ: hiển thị nhiều dòng, mỗi dòng một lần trả hồ sơ.
2. Một `case_id` có trả hồ sơ trước kỳ, thụ lý lại trong kỳ: occurrence thụ lý lại tính vào thụ lý trong kỳ; lần trả hồ sơ trước kỳ không nằm trong danh sách trả hồ sơ của kỳ.
3. Một `case_id` thụ lý trước kỳ, trả hồ sơ trong kỳ: không tính thụ lý trong kỳ; tính giải quyết/trả hồ sơ trong kỳ.
4. Một `case_id` thụ lý trong kỳ, trả hồ sơ sau kỳ: tính thụ lý trong kỳ; chưa tính giải quyết trong kỳ; tính còn lại đến `to_date` nếu chưa có event giải quyết trước hoặc bằng `to_date`.
5. Có `case_files.closed_date` nhưng thiếu event chi tiết: cảnh báo schema/dữ liệu chưa đủ để tính occurrence; không dùng `closed_date` để thay event nếu sẽ làm mất lần trả hồ sơ.
6. Chưa có bảng occurrence/event: báo schema chưa đủ, đề xuất migration tối thiểu, không list bằng cách group theo `case_id`.

## 13. Validation rules

- `occurrence_no` phải duy nhất trong từng `case_id`.
- `acceptance_type_code` phải thuộc `INITIAL_ACCEPTANCE` hoặc `RE_ACCEPTANCE_AFTER_SUPPLEMENTAL_INVESTIGATION`.
- Event trả hồ sơ phải có `resolution_type_code = RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION`.
- Event trả hồ sơ phải có `return_to_agency_code` thuộc `PROCURACY` hoặc `VIEN_KIEM_SAT`.
- Event trả hồ sơ phải có `counted_as_resolved = TRUE`.
- Không được đếm distinct `case_id` cho chỉ tiêu/list này.
- Nếu `accepted_count` trong dữ liệu mẫu case A bằng 1 thay vì 2 thì logic sai.
- Nếu return event không làm tăng `resolved_count` thì logic sai.

## 14. Examples

Vụ án A:

- Occurrence 1: thụ lý 10/03/2026, trả hồ sơ 15/04/2026.
- Occurrence 2: thụ lý lại 05/05/2026, xét xử ra bản án 20/06/2026.

Kỳ 01/03/2026 - 30/06/2026:

- Thụ lý: 2 dòng.
- Giải quyết: 2 dòng.
- Còn lại cuối kỳ: 0.
- Danh sách trả hồ sơ: 1 dòng.

Kỳ 01/03/2026 - 31/05/2026:

- Thụ lý: 2 dòng.
- Giải quyết: 1 dòng.
- Còn lại cuối kỳ: 1 dòng.
- Danh sách trả hồ sơ: 1 dòng.

## 15. Related skills bị ảnh hưởng

- `knowledge_base/skills/statistics/skill_thong_ke_hinh_su.md`: các chỉ tiêu thụ lý, giải quyết, còn lại của hình sự sơ thẩm phải tính theo occurrence khi nghiệp vụ trả hồ sơ/thụ lý lại được bật.
- `knowledge_base/skills/core/skill_statistics_mapping.md`: công thức tồn cuối kỳ vẫn đúng, nhưng đơn vị đếm phải là `OCCURRENCE`.
- `knowledge_base/skills/core/skill_trial_level_classification.md`: vẫn dùng `case_group/case_group_id = SO_THAM` để lọc sơ thẩm.
