# Skill: Thành phần phiên tòa từ Excel

## Mục đích

Dùng khi import, kiểm tra hoặc báo cáo dữ liệu từ các cột Thẩm phán/Chủ tọa, Hội đồng/Thành viên và Thư ký trong Excel.

## Bảng dữ liệu

- `court_staff`: danh sách cán bộ xét xử/thư ký theo đơn vị khi chưa cần hoặc chưa có tài khoản `users`.
- `case_hearing_members`: thành phần phiên tòa gắn với từng `case_files`.
- Danh mục role dùng category `hearing_member_role`.

## Role chuẩn

- `PRESIDING_JUDGE`: Thẩm phán chủ tọa. Mỗi hồ sơ bắt buộc đúng 1 người.
- `PANEL_JUDGE`: Thẩm phán thành viên Hội đồng.
- `HEARING_CLERK`: Thư ký phiên tòa. Mỗi hồ sơ cần ít nhất 1 người.

## Quy tắc import Excel

- Cột "Thẩm phán" hoặc "Chủ tọa" map sang `PRESIDING_JUDGE`.
- Cột "Hội đồng" hoặc "Thành viên" map sang `PANEL_JUDGE`.
- Cột "Thư ký" map sang `HEARING_CLERK`.
- Ô trống là thiếu dữ liệu nguồn; chỉ ghi cảnh báo, không tạo tên giả hoặc placeholder.
- Khi một ô có nhiều người, tách theo dòng mới, dấu `;`, `|` hoặc `/` nếu nguồn thể hiện danh sách rõ.
- Tên cán bộ được chuẩn hóa để chống trùng, nhưng phải giữ `full_name` theo nguồn.

## Quy tắc nghiệp vụ cần kiểm tra

- Chủ tọa: đúng 1 `PRESIDING_JUDGE` cho mỗi hồ sơ.
- Sơ thẩm: `PANEL_JUDGE` có thể 0 hoặc 1 theo dữ liệu Excel hiện có.
- Phúc thẩm: phải có đúng 2 `PANEL_JUDGE`.
- Thư ký: phải có ít nhất 1 `HEARING_CLERK`.
- Các vi phạm từ nguồn Excel phải có file, sheet, dòng trong report để người dùng rà soát.

## Kiểm tra và báo cáo

- Seed sinh từ `database/seed/generate_excel_case_full_import.py` ra `database/seed/034_excel_seed_hearing_members.sql`.
- Report dòng lỗi nằm tại `tests/database/EXCEL_CASE_TRIAL_LEVEL_AND_HEARING_MEMBERS_RESULT.md`.
- Test toàn vẹn nằm tại `tests/database/trial_level_and_hearing_members_integrity_test.sql`; các vi phạm chất lượng nguồn có thể được ghi `NOTICE` thay vì làm fail khi Excel còn thiếu dữ liệu.
