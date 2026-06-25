# TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md

## 0. Thông tin phiên bản

```yaml
version: 1.1
created_date: 2026-06-08
project: Hệ thống quản lý và điều hành TAND hai cấp tỉnh Quảng Ngãi
basis:
  - MASTER_PLAN_TAND_QUANG_NGAI_AI_AGENT_v1.docx
  - Knowledge Base tố tụng dân sự, hình sự, hành chính
  - Database Diagram TAND Quảng Ngãi
  - Skill phân công án ngẫu nhiên
  - Skill theo dõi án kháng cáo/kháng nghị
```

---

## 1. Mục đích

File này là **rule bắt buộc** dành cho các AI Agent khi tham gia dự án hệ thống quản lý, thống kê và điều hành hoạt động xét xử của TAND hai cấp tỉnh Quảng Ngãi.

Mọi AI Agent phải đọc file này trước khi thực hiện task.

---

## 2. Phạm vi dự án

Dự án tập trung xây dựng hệ thống:

1. Theo dõi thụ lý, giải quyết, tồn đọng, quá hạn.
2. Quản lý hồ sơ vụ án, vụ việc.
3. Dashboard điều hành cho lãnh đạo.
4. Hệ thống KPI.
5. Cảnh báo án sắp hết hạn/quá hạn.
6. Báo cáo tự động.
7. Nền tảng AI hỏi đáp dữ liệu thống kê.
8. Theo dõi án hủy/sửa.
9. Phân công án ngẫu nhiên cho Thẩm phán.
10. Theo dõi án bị kháng cáo/kháng nghị lên Tòa án cấp trên.

---

## 3. Nguyên tắc bắt buộc từ Master Plan

AI Agent phải tuân thủ tuyệt đối:

```text
- Bám sát hệ thống biểu mẫu thống kê ngành Tòa án.
- Bám sát Quyết định 287/QĐ-TANDTC.
- Mỗi loại án phải có Data Dictionary.
- Mỗi chỉ tiêu phải có Formula Catalog.
- Mỗi dữ liệu phải có Validation Rules.
- Không cho phép đếm trùng số liệu.
- Kiểm tra chéo giữa các biểu mẫu.
```

---

## 4. Các phân hệ mục tiêu

```text
A. Quản lý hồ sơ vụ án.
B. Thống kê nghiệp vụ.
C. Dashboard điều hành.
D. KPI lãnh đạo.
E. Cảnh báo thời hạn.
F. Theo dõi án hủy/sửa.
G. Báo cáo tự động.
H. AI hỏi đáp dữ liệu.
I. Phân công án ngẫu nhiên.
J. Theo dõi kháng cáo/kháng nghị.
```

---

## 5. Backlog bắt buộc

```text
1. Framework Skill thống kê.
2. Skill Hình sự.
3. Skill Dân sự.
4. Skill Kinh doanh thương mại.
5. Skill Hôn nhân gia đình.
6. Skill Lao động.
7. Skill Hành chính.
8. Formula Catalog.
9. Validation Rules.
10. Data Dictionary.
11. KPI Dashboard.
12. Random Assignment Skill.
13. Appeal/Protest Tracking Skill.
14. Database Diagram v2.
15. Reporting Engine.
16. AI Analytics Layer.
```

---

## 6. Kiến trúc AI Agent

### Agent-01: Chief Architect

Nhiệm vụ:

```text
- Quản lý backlog.
- Kiểm soát kiến trúc.
- Kiểm tra tính nhất quán.
- Phê duyệt thay đổi lớn về schema, module, rule.
```

### Agent-02: Data Dictionary Agent

Nhiệm vụ:

```text
- Chuẩn hóa dữ liệu.
- Quản lý danh mục dữ liệu.
- Đảm bảo mỗi loại án có bộ trường nhập liệu riêng.
- Kiểm tra trùng tên trường, trùng ý nghĩa, sai kiểu dữ liệu.
```

### Agent-03: Formula Catalog Agent

Nhiệm vụ:

```text
- Xây dựng công thức thống kê.
- Kiểm tra logic thống kê.
- Đảm bảo mỗi chỉ tiêu dashboard/KPI có công thức truy xuất nguồn gốc.
- Phòng chống đếm trùng số liệu.
```

### Agent-04: Validation Agent

Nhiệm vụ:

```text
- Xây dựng quy tắc kiểm tra dữ liệu.
- Kiểm tra chéo biểu mẫu.
- Kiểm tra thiếu trường bắt buộc.
- Kiểm tra quá hạn, sai trạng thái, sai logic nghiệp vụ.
```

### Agent-05: Dashboard Agent

Nhiệm vụ:

```text
- Thiết kế dashboard lãnh đạo.
- Thiết kế KPI.
- Thiết kế heatmap.
- Thiết kế cảnh báo.
```

### Agent-06: Reporting Agent

Nhiệm vụ:

```text
- Báo cáo tuần/tháng/quý/năm.
- Xuất Excel/PDF/Word.
- Tạo mẫu báo cáo tự động.
- Đảm bảo số liệu báo cáo khớp dashboard và biểu mẫu thống kê.
```

### Agent-07: AI Analytics Agent

Nhiệm vụ:

```text
- Truy vấn dữ liệu tự nhiên.
- Hỏi đáp thống kê.
- Phân tích xu hướng.
- Dự báo khối lượng án.
```

### Agent-08: QA Agent

Nhiệm vụ:

```text
- Kiểm thử dữ liệu.
- Kiểm thử nghiệp vụ.
- Kiểm thử công thức.
- Kiểm thử kiểm tra chéo biểu mẫu.
- Kiểm thử chống đếm trùng.
```

### Agent-09: Legal Skill Agent

Nhiệm vụ:

```text
- Chuyển hóa luật, thông tư, quy định thành rule.
- Kiểm tra legal_basis.
- Phát hiện suy luận thiếu căn cứ.
```

### Agent-10: Database Architect Agent

Nhiệm vụ:

```text
- Thiết kế ERD.
- Chuẩn hóa schema.
- Viết migration SQL.
- Kiểm tra khóa chính, khóa ngoại, index.
```

### Agent-11: Backend Agent

Nhiệm vụ:

```text
- Viết service.
- Viết API.
- Bảo đảm transaction, audit, permission.
```

### Agent-12: Frontend Agent

Nhiệm vụ:

```text
- Xây dựng màn hình nhập liệu.
- Xây dựng dashboard.
- Xây dựng màn hình phân công án.
- Xây dựng màn hình theo dõi kháng cáo/kháng nghị.
```

---

## 7. Kiến trúc dữ liệu chuẩn

AI Agent phải tuân theo mô hình 05 lớp:

```text
1. Master Data
   courts, users, judge_profiles, categories

2. Case Core
   case_files, participants, documents, hearings, decisions, case_events

3. Specialized Modules
   civil_case_details
   criminal_case_details
   administrative_case_details

4. Rule/AI Layer
   deadlines
   validation_results
   assignment_batches
   appellate_trackings
   appellate_fault_assessments
   ai_suggestions
   audit_logs

5. Analytics Layer
   statistics_snapshots
   kpi_metrics
   kpi_values
```

---

## 8. Quy tắc database

### 8.0. Quy tắc kết nối PostgreSQL và bảo mật môi trường

```text
- Khi chạy psql hoặc script database, AI Agent phải lấy cấu hình từ .env.local ở thư mục gốc repo hoặc environment variables.
- Các biến được phép đọc: PGHOST, PGPORT, PGUSER, PGPASSWORD, PGDATABASE, DATABASE_URL.
- Không hard-code mật khẩu PostgreSQL.
- Không ghi mật khẩu hoặc secret vào báo cáo, README, log hoặc file kết quả.
- Không commit .env.local.
- Script Windows PowerShell phải kiểm soát nguy cơ mojibake khi hiển thị tiếng Việt; nếu cần, dùng thông điệp runtime không dấu và ghi tài liệu UTF-8.
```

### 8.1. Quy tắc source of truth schema

```text
- database/schema/unified_postgresql_schema.sql là source of truth cho database mới.
- database/migrations/*.sql là lịch sử thay đổi và dùng cho database đã tồn tại.
- Chỉ gộp migration vào unified schema khi migration tương thích, ổn định, additive hoặc có thể chuyển thành idempotent an toàn.
- Không gộp migration legacy nếu có bảng trùng, không idempotent hoặc xung đột với unified schema.
- Không chạy unified schema và migrations trong cùng một mode kiểm tra.
- Không xóa constraint/index để làm test pass giả.
```

### 8.2. Quy tắc tài liệu database

```text
- Báo cáo, mô tả hoàn thành, README, checklist và tài liệu database phải viết bằng tiếng Việt UTF-8.
- Nếu xuất tài liệu định dạng có font chữ, dùng font Tahoma.
- Tài liệu database phải mô tả công dụng bảng, khóa chính, khóa ngoại và các cột liên kết quan trọng.
```

### 8.3. Quy tắc đặt tên kỹ thuật và dữ liệu tiếng Việt

```text
- Ngoại trừ dữ liệu nghiệp vụ bắt buộc phải lưu bằng tiếng Việt có dấu UTF-8, tất cả đối tượng kỹ thuật phải đặt tên bằng tiếng Anh.
- Tên bảng, tên cột, enum, index, constraint, function, view, trigger, file migration, API route, DTO, service, repository và component frontend phải dùng tiếng Anh.
- Không dùng tiếng Việt có dấu trong tên bảng/cột/constraint/index/function/API route.
- Dữ liệu hiển thị cho người dùng, tên biểu mẫu, tên chỉ tiêu thống kê, tên tội danh, quan hệ pháp luật, kết quả giải quyết và mô tả nghiệp vụ có thể dùng tiếng Việt UTF-8.
- Code danh mục nên dùng ASCII/English hoặc tiếng Việt không dấu dạng code ổn định, ví dụ HINH_SU, SO_THAM, PHUC_THAM, RETURN_TO_PROCURACY_FOR_SUPPLEMENTAL_INVESTIGATION.
- File SQL/script phải lưu UTF-8.
- Khi dùng PowerShell/psql cần tránh literal tiếng Việt trong câu lệnh trực tiếp nếu gây lỗi encoding; ưu tiên code danh mục.
```

### 8.1. Bảng trung tâm

`case_files` là bảng trung tâm cho mọi loại án.

Không tạo bảng riêng cho từng loại tranh chấp nhỏ nếu có thể chuẩn hóa bằng danh mục.

### 8.2. Không ghi đè lịch sử

Các dữ liệu sau phải lưu lịch sử:

```text
case_status
assignment_status
appeal_tracking_status
deadline_status
validation_result
kpi_value
```

### 8.4. AI không ghi trực tiếp vào dữ liệu chính

AI Agent chỉ được ghi vào:

```text
validation_results
ai_suggestions
case_risk_flags
assignment_audit_logs
appellate_status_history
```

Dữ liệu chính chỉ được cập nhật khi có xác nhận của người dùng hoặc workflow được cấp quyền.

### 8.5. Quy tắc cập nhật skill sau task

Sau mỗi task, AI Agent phải tự kiểm tra:

```text
Có quy tắc, logic, công thức, mapping, validation, SQL template, API contract hoặc UI pattern nào cần ghi lại thành skill để dùng lại không?
```

Nếu có, AI Agent phải cập nhật skill hiện có hoặc tạo skill mới trong `knowledge_base/skills/`.

Sau mỗi task thiết kế database, AI Agent phải cân nhắc tạo/cập nhật skill hoặc checklist cho:

```text
- backend entity/model/repository/service/API;
- frontend form/list/detail/report;
- validation rules;
- seed/test data;
- statistics/list report.
```

Quy tắc workflow chi tiết nằm tại:

```text
docs/AI_AGENT_RULES.md
```

---

## 9. Rule phân công án ngẫu nhiên

Phân hệ bắt buộc:

```text
SKILL_PHAN_CONG_AN_NGAU_NHIEN_V1.md
```

Bảng bắt buộc:

```text
assignment_batches
assignment_batch_cases
assignment_batch_judges
judge_profiles
judge_status_periods
judge_case_conflicts
judge_workload_snapshots
judge_replacement_history
assignment_audit_logs
```

Mỗi phiên phân công phải lưu:

```text
- danh sách vụ việc tại thời điểm phân công;
- danh sách Thẩm phán tại thời điểm phân công;
- tiêu chí xếp hạng;
- lý do loại trừ;
- kết quả phân công;
- người quyết định;
- thời điểm;
- hash toàn vẹn dữ liệu.
```

---

## 10. Rule theo dõi kháng cáo/kháng nghị

Phân hệ bắt buộc:

```text
SKILL_THEO_DOI_AN_KHANG_CAO_KHANG_NGHI_V1.md
```

Bảng bắt buộc:

```text
appellate_trackings
appeal_protest_items
appellate_results
appellate_fault_assessments
appellate_followup_actions
appellate_status_history
```

Nếu án bị hủy/sửa, bắt buộc phân loại:

```text
objective
subjective
mixed
unknown
```

Không được tự kết luận lỗi chủ quan nếu chưa có căn cứ.

---

## 11. Rule KPI và thống kê

### 11.1. Rule năm công tác Tòa án

Năm công tác của Tòa án được tính từ ngày 01/10 của năm trước đến ngày 30/09 của năm công tác.

Ví dụ:

```text
Năm công tác 2026 = từ ngày 01/10/2025 đến hết ngày 30/09/2026.
```

Khi API, báo cáo, dashboard, KPI, truy vấn AI hoặc bộ lọc dữ liệu dùng `working_year = Y`, AI Agent phải quy đổi:

```text
from_date = (Y - 1)-10-01
to_date   = Y-09-30
```

Không dùng mặc định năm dương lịch 01/01-31/12 cho báo cáo theo năm công tác Tòa án nếu không có yêu cầu rõ.

AI Agent phải tính KPI từ dữ liệu chuẩn hóa, không tính từ text tự do.

KPI bắt buộc:

```text
total_accepted_cases
resolved_cases
pending_cases
overdue_cases
clearance_rate
appeal_rate
protest_rate
upheld_rate
modified_rate
cancelled_rate
subjective_modified_cancelled_rate
objective_modified_cancelled_rate
withdrawn_appeal_protest_rate
returned_investigation_rate
mediation_success_rate
dialogue_success_rate
random_assignment_compliance_rate
```

Dữ liệu thống kê phải lưu vào:

```text
statistics_snapshots
kpi_metrics
kpi_values
```

---

## 12. Rule validation

Mọi module phải có validation tối thiểu:

```text
- thiếu ngày thụ lý;
- thiếu loại án;
- thiếu Thẩm phán được phân công;
- quá hạn chuẩn bị xét xử;
- quá hạn tạm giam;
- thiếu bản án/quyết định bị kháng cáo;
- thiếu kết quả cấp trên;
- án hủy/sửa nhưng chưa phân loại khách quan/chủ quan;
- phân công án không có audit log;
- phân công án không có danh sách Thẩm phán tại thời điểm phân công;
- số liệu dashboard không khớp biểu mẫu;
- dữ liệu bị đếm trùng;
- công thức không có nguồn gốc.
```

Validation result phải có:

```text
rule_code
severity
message
field_name
case_id
checked_at
checked_by
legal_basis
suggested_action
```

---

## 13. Định dạng giao việc cho AI

Mọi task phải dùng mẫu:

```yaml
Task:
Objective:
Input:
Output:
Dependencies:
Validation:
Owner Agent:
Priority:
```

Không nhận task thiếu `Objective`, `Output`, `Owner Agent`, `Validation`.

---

## 14. Kế hoạch triển khai

### Giai đoạn 1

```text
- Data Dictionary.
- Formula Catalog.
- Validation Rules.
- Framework Skill.
```

### Giai đoạn 2

```text
- Dashboard điều hành.
- Theo dõi tiến độ vụ án.
- Cảnh báo quá hạn.
```

### Giai đoạn 3

```text
- KPI.
- Báo cáo tự động.
- Theo dõi án hủy/sửa.
- Theo dõi kháng cáo/kháng nghị.
- Phân công án ngẫu nhiên.
```

### Giai đoạn 4

```text
- AI hỏi đáp dữ liệu.
- Dự báo khối lượng án.
- Phân tích xu hướng.
```

---

## 15. Tiêu chí hoàn thành

Một module chỉ được xem là hoàn thành khi đạt:

```text
- Số liệu dashboard khớp biểu mẫu.
- Không có đếm trùng.
- Truy xuất được nguồn gốc công thức.
- Có kiểm tra chéo tự động.
- Hỗ trợ lãnh đạo điều hành toàn tỉnh.
- Có Data Dictionary.
- Có Formula Catalog.
- Có Validation Rules.
- Có migration SQL nếu thay đổi database.
- Có test case tối thiểu.
- Có tài liệu hướng dẫn.
```

---

## 16. Điều cấm đối với AI Agent

AI Agent không được:

```text
- tự bịa luật, biểu mẫu, chỉ tiêu;
- xóa audit log;
- ghi đè kết quả phân công án;
- ghi đè kết quả cấp trên;
- tự kết luận lỗi chủ quan khi chưa có căn cứ;
- thay đổi schema lõi mà không cập nhật ERD và migration;
- tạo bảng trùng chức năng;
- dùng text tự do thay cho enum đã chuẩn hóa;
- bỏ qua validation pháp lý;
- bỏ qua phân quyền Chánh án/Phó Chánh án/Thẩm phán/Thư ký;
- bỏ qua kiểm tra đếm trùng;
- tạo KPI không có công thức.
```

---

## 17. Nội dung Master Plan đã hợp nhất

```text
MASTER PLAN - HỆ THỐNG QUẢN LÝ VÀ ĐIỀU HÀNH TÒA ÁN NHÂN DÂN HAI CẤP TỈNH QUẢNG NGÃI
Phiên bản: 1.0
Nguồn ngữ cảnh: Chỉ tổng hợp từ các nội dung đã được nghiên cứu trong các cuộc trao đổi của dự án.
Mục đích: Tài liệu điều phối cho AI Agent và đội phát triển triển khai song song.
1. Phạm vi dự án

Xây dựng hệ thống quản lý, thống kê và điều hành hoạt động xét xử cho TAND hai cấp tỉnh Quảng Ngãi.
Trọng tâm:
- Theo dõi thụ lý, giải quyết, tồn đọng, quá hạn.
- Dashboard điều hành cho lãnh đạo.
- Hệ thống KPI.
- Cảnh báo án sắp hết hạn/quá hạn.
- Báo cáo tự động.
- Nền tảng AI hỏi đáp dữ liệu thống kê.

2. Nguyên tắc bắt buộc

- Bám sát hệ thống biểu mẫu thống kê ngành Tòa án.
- Bám sát Quyết định 287/QĐ-TANDTC.
- Mọi loại án phải có Data Dictionary.
- Mọi chỉ tiêu phải có Formula Catalog.
- Mọi dữ liệu phải có Validation Rules.
- Không cho phép đếm trùng số liệu.
- Kiểm tra chéo giữa các biểu mẫu.

3. Các phân hệ mục tiêu

A. Quản lý hồ sơ vụ án.
B. Thống kê nghiệp vụ.
C. Dashboard điều hành.
D. KPI lãnh đạo.
E. Cảnh báo thời hạn.
F. Theo dõi án hủy sửa.
G. Báo cáo tự động.
H. AI hỏi đáp dữ liệu.

4. Backlog đã xác định

- Framework Skill thống kê.
- Skill Hình sự.
- Skill Dân sự.
- Skill Kinh doanh thương mại.
- Formula Catalog.
- Validation Rules.
- Data Dictionary.
- KPI Dashboard.

5. Kiến trúc AI Agent

Agent-01: Chief Architect
Nhiệm vụ:
- Quản lý backlog.
- Kiểm soát kiến trúc.
- Kiểm tra tính nhất quán.

Agent-02: Data Dictionary Agent
Nhiệm vụ:
- Chuẩn hóa dữ liệu.
- Quản lý danh mục dữ liệu.

Agent-03: Formula Catalog Agent
Nhiệm vụ:
- Xây dựng công thức.
- Kiểm tra logic thống kê.

Agent-04: Validation Agent
Nhiệm vụ:
- Quy tắc kiểm tra dữ liệu.
- Kiểm tra chéo biểu mẫu.

Agent-05: Dashboard Agent
Nhiệm vụ:
- Dashboard lãnh đạo.
- KPI.
- Heatmap.
- Cảnh báo.

Agent-06: Reporting Agent
Nhiệm vụ:
- Báo cáo tuần/tháng/quý/năm.
- Xuất Excel/PDF/Word.

Agent-07: AI Analytics Agent
Nhiệm vụ:
- Truy vấn dữ liệu tự nhiên.
- Hỏi đáp thống kê.
- Phân tích xu hướng.

Agent-08: QA Agent
Nhiệm vụ:
- Kiểm thử dữ liệu.
- Kiểm thử nghiệp vụ.

6. Kế hoạch triển khai

Giai đoạn 1:
- Data Dictionary.
- Formula Catalog.
- Validation Rules.
- Framework Skill.

Giai đoạn 2:
- Dashboard điều hành.
- Theo dõi tiến độ vụ án.
- Cảnh báo quá hạn.

Giai đoạn 3:
- KPI.
- Báo cáo tự động.
- Theo dõi án hủy sửa.

Giai đoạn 4:
- AI hỏi đáp dữ liệu.
- Dự báo khối lượng án.

7. Tiêu chí hoàn thành

- Số liệu dashboard khớp biểu mẫu.
- Không có đếm trùng.
- Truy xuất nguồn gốc công thức.
- Kiểm tra chéo tự động.
- Hỗ trợ lãnh đạo điều hành toàn tỉnh.

8. Định dạng giao việc cho AI

Task:
Objective:
Input:
Output:
Dependencies:
Validation:
Owner Agent:
Priority:

```
