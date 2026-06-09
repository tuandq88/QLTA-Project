# Hệ thống quản lý và điều hành TAND hai cấp tỉnh Quảng Ngãi

Dự án này là bộ nền tảng tri thức, thiết kế dữ liệu và rule nghiệp vụ để xây dựng một ứng dụng miễn phí phục vụ lãnh đạo Tòa án nhân dân hai cấp tỉnh Quảng Ngãi theo dõi, điều hành và đánh giá hoạt động giải quyết án.

Mục tiêu chính là giúp lãnh đạo nhìn được tình hình thụ lý, giải quyết, tồn đọng, quá hạn, chất lượng xét xử và tiến độ từng hồ sơ, từng Thẩm phán, từng đơn vị. Về sau hệ thống sẽ tích hợp AI để hỏi đáp số liệu bằng ngôn ngữ tự nhiên, xuất báo cáo, vẽ biểu đồ và cảnh báo rủi ro.

## Dự án đang có gì

```text
.
├── bieu_mau/                         Bộ biểu mẫu Excel theo từng loại án
├── database/                         Cấu trúc database chuẩn để triển khai
│   ├── diagrams/                     ERD và tài liệu thiết kế dữ liệu
│   ├── schema/                       Schema PostgreSQL hợp nhất
│   └── migrations/                   SQL mở rộng theo module
├── backend/                          Mã nguồn backend khi bắt đầu triển khai app
├── frontend/                         Mã nguồn frontend khi bắt đầu triển khai app
├── tests/                            Test nghiệp vụ và kỹ thuật
├── docs/                             Kế hoạch, review, tài liệu pháp lý
├── Documents/                        Văn bản pháp luật, hướng dẫn biểu mẫu PDF
├── knowledge_base/                   Rule nền, kiến trúc skill, KPI, validation
│   ├── data/statistics/              JSON thống kê: formula, mapping, dictionary, validation
│   ├── rules/                        Rule tổng cho AI Agent
│   └── skills/                       Skill đã gom theo nhóm nghiệp vụ
├── AGENTS.md                         Hướng dẫn làm việc cho AI Agent
└── .gitignore                        Quy tắc bỏ qua file môi trường/build
```

Đây chưa phải là một app hoàn chỉnh có backend/frontend. Repo hiện đóng vai trò như "bản thiết kế nghiệp vụ" cho Vibe Coder hoặc AI Agent triển khai thành sản phẩm.

## Các phân hệ nghiệp vụ

Hệ thống hướng tới các phân hệ sau:

- Quản lý hồ sơ vụ án, vụ việc từ lúc thụ lý đến khi kết thúc.
- Theo dõi vòng đời hồ sơ: thụ lý, phân công, chuẩn bị xét xử, phiên tòa, quyết định, bản án, kháng cáo, phúc thẩm, giám đốc thẩm, tái thẩm.
- Thống kê nghiệp vụ theo biểu mẫu ngành Tòa án.
- Dashboard lãnh đạo: thụ lý, giải quyết, tồn, quá hạn, chất lượng xét xử, án hủy/sửa.
- KPI theo đơn vị, loại án và Thẩm phán.
- Cảnh báo án sắp hết hạn, quá hạn, thiếu dữ liệu bắt buộc.
- Phân công án ngẫu nhiên, có audit log, theo Thông tư 01/2022/TT-TANDTC.
- Theo dõi kết quả Tòa án cấp trên đối với án bị kháng cáo, kháng nghị.
- AI hỏi đáp, phân tích, xuất báo cáo và biểu đồ.

## Nguồn quy định đang dùng

Các rule trong dự án đang dựa trên:

- `Documents/huong_dan_bm.pdf`: hướng dẫn sử dụng biểu mẫu thống kê nghiệp vụ theo Quyết định 287/QĐ-TANDTC.
- `Documents/Thông tư 01_2022_TT-TANDTC...pdf`: quy định phân công Thẩm phán giải quyết, xét xử vụ án, vụ việc.
- `Documents/99-vbhn-vpqh.pdf`: Bộ luật Tố tụng dân sự hợp nhất.
- `Documents/104-vbhn-vpqh.pdf`: Bộ luật Tố tụng hình sự hợp nhất.
- `Documents/109-vbhn-vpqh.pdf`: Luật Tố tụng hành chính hợp nhất.

Khi Vibe Coder sửa rule, công thức hoặc schema, nên đối chiếu lại các PDF này trước khi code.

## Các skill quan trọng

`knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md` là rule tổng cho AI Agent. File này quy định nguyên tắc không bịa luật, không đếm trùng số liệu, không ghi đè lịch sử, không để AI ghi trực tiếp vào dữ liệu chính nếu chưa có xác nhận.

`knowledge_base/skills/random_assignment/SKILL_PHAN_CONG_AN_NGAU_NHIEN_V1.md` mô tả cách lập danh sách vụ việc, danh sách Thẩm phán, tiêu chí loại trừ, tiêu chí sắp xếp và audit log khi phân công án.

`knowledge_base/skills/appeal_protest_tracking/SKILL_THEO_DOI_AN_KHANG_CAO_KHANG_NGHI_V1.md` mô tả cách theo dõi án bị kháng cáo, kháng nghị, kết quả cấp trên, phân loại hủy/sửa khách quan/chủ quan và tác động tới KPI.

`knowledge_base/skills/statistics/` chứa các skill thống kê đã gom theo từng nhóm án.

`knowledge_base/data/statistics/` chứa các file JSON dùng cho thống kê:

```text
all_case_types/        Formula tổng cho tất cả loại án
civil/                 Dân sự
criminal/              Hình sự
administrative/        Hành chính
marriage_family/       Hôn nhân gia đình
business_commercial/   Kinh doanh thương mại
labor/                 Lao động
```

Tên file trong từng nhóm đã được chuẩn hóa:

```text
formula_catalog.json
data_dictionary.json
column_mapping.json
input_mapping.json
validation_rules.json
```

Không phải nhóm nào cũng có đủ 5 file; ví dụ dân sự hiện có `formula_catalog.json` và `validation_rules.json`, hình sự hiện có `formula_catalog.json` và `data_dictionary.json`.

## Database

Schema hợp nhất để tạo database nằm tại:

```text
database/schema/unified_postgresql_schema.sql
```

Core schema độc lập cho phần lõi nằm tại:

```text
database/schema/core_database_schema.sql
database/migrations/001_core_database_schema.sql
```

Chạy riêng core schema trên database trống:

```bash
psql -d tand_quangngai -f database/migrations/001_core_database_schema.sql
```

File này gom mô hình từ:

- `database/schema/postgresql_starter_schema.sql`
- `database/diagrams/DATABASE_DIAGRAM_TAND_QUANGNGAI.md`
- `database/migrations/random_assignment_schema_extension.sql`
- `database/migrations/appeal_protest_tracking_schema_extension.sql`

Triển khai PostgreSQL:

```bash
psql -d tand_quangngai -f database/schema/unified_postgresql_schema.sql
```

Schema chia thành 5 lớp:

- Master data: `courts`, `users`, `judge_profiles`.
- Case core: `case_files`, `participants`, `documents`, `hearings`, `decisions`, `case_assignments`, `case_events`.
- Specialized modules: dân sự, hình sự, hành chính.
- Rule/AI layer: `deadlines`, `validation_results`, `assignment_*`, `appellate_*`, `ai_suggestions`, `case_risk_flags`, `audit_logs`.
- Analytics layer: `statistics_periods`, `statistics_snapshots`, `kpi_metrics`, `kpi_values`.

## Gợi ý triển khai app

Nếu bắt đầu code app từ repo này, nên đi theo thứ tự:

1. Tạo database bằng schema hợp nhất.
2. Tạo backend CRUD cho hồ sơ, người tham gia tố tụng, tài liệu, phiên tòa, bản án/quyết định.
3. Làm màn hình nhập liệu hồ sơ theo từng loại án.
4. Làm module phân công án ngẫu nhiên trước khi mở rộng KPI Thẩm phán.
5. Làm module theo dõi kháng cáo, kháng nghị, án hủy/sửa.
6. Tạo job tổng hợp `statistics_snapshots` và `kpi_values`.
7. Tích hợp AI ở tầng đọc dữ liệu, gợi ý, kiểm tra validation; không cho AI tự ý sửa dữ liệu chính.

## Lưu ý cho Vibe Coder

- Đừng tính dashboard trực tiếp từ text tự do. Hãy chuẩn hóa enum, mã trạng thái và bảng danh mục.
- Đừng xóa hoặc ghi đè audit log, kết quả phân công án, kết quả cấp trên.
- Mọi chỉ tiêu thống kê cần có công thức và nguồn biểu mẫu.
- Mọi validation liên quan thời hạn hoặc quyền tố tụng cần có `legal_basis`.
- Khi sửa schema lõi, cập nhật lại ERD, migration và README.
- Các formula sinh từ OCR trong `knowledge_base/data/statistics/all_case_types/formula_catalog.json` cần được rà soát kỹ trước khi đưa vào code tính toán.

## Tình trạng hiện tại

Repo đã có nền tảng tri thức và schema để bắt đầu triển khai database. Việc tiếp theo nên là biến các rule thành migration, seed danh mục, API và giao diện nhập liệu/dashboard.

## Checklist Task Format

Mỗi task nên có đủ:

- [ ] `Task`
- [ ] `Objective`
- [ ] `Input`
- [ ] `Output`
- [ ] `Dependencies`
- [ ] `Validation`
- [ ] `Owner Agent`
- [ ] `Priority`
