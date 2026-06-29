# AI Agent Rules

## 1. General Principles

- Đọc `AGENTS.md`, `README.md` và `knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md` trước khi làm task.
- Không tự bịa luật, biểu mẫu, chỉ tiêu, công thức, căn cứ pháp lý hoặc dữ liệu nghiệp vụ.
- Không làm mất file nguồn trong `Documents/`, `bieu_mau/`, JSON mapping/formula/validation, diagram hoặc asset.
- Không ghi đè audit log, kết quả phân công án, kết quả cấp trên hoặc dữ liệu chính khi chưa có workflow xác nhận.
- Không sửa schema nghiệp vụ nếu task chỉ là cleanup/tài liệu, trừ cập nhật tài liệu hoặc index an toàn.

## 1.1. Court Working Year Rule

- Năm công tác của Tòa án được tính từ ngày 01/10 của năm trước đến ngày 30/09 của năm công tác.
- Ví dụ: năm công tác 2026 được tính từ ngày 01/10/2025 đến hết ngày 30/09/2026.
- Khi API, báo cáo, dashboard, KPI hoặc bộ lọc dùng `working_year = Y`, phải quy đổi thành `from_date = (Y - 1)-10-01` và `to_date = Y-09-30`.
- Không dùng mặc định năm dương lịch 01/01-31/12 cho báo cáo theo năm công tác Tòa án nếu không có yêu cầu rõ.

## 2. Database Naming Convention

- Technical object names phải dùng tiếng Anh: table, column, enum, index, constraint, function, view, trigger, migration file.
- Không dùng tiếng Việt có dấu trong tên object kỹ thuật.
- Code danh mục dùng ASCII/English hoặc tiếng Việt không dấu dạng code ổn định, ví dụ `HINH_SU`, `SO_THAM`, `PHUC_THAM`.
- Constraint/index nên ngắn, ổn định và dưới giới hạn tên object của PostgreSQL.

## 3. UTF-8 Vietnamese Data Rule

- Dữ liệu hiển thị, nhãn UI, tên biểu mẫu, tên chỉ tiêu thống kê, tên tội danh, quan hệ pháp luật và mô tả nghiệp vụ dùng tiếng Việt UTF-8.
- Báo cáo, README, checklist và tài liệu database phải lưu UTF-8.
- Nếu xuất DOCX/PDF/HTML in ấn, dùng font Tahoma.
- PowerShell/psql runtime nên ưu tiên code danh mục hoặc thông điệp không dấu nếu console gây mojibake; file tài liệu vẫn viết tiếng Việt UTF-8.

## 4. Schema Design Rule

- `database/schema/unified_postgresql_schema.sql` là source of truth cho database mới.
- `case_files` là bảng trung tâm; không tạo bảng riêng cho tranh chấp nhỏ nếu có thể chuẩn hóa bằng danh mục.
- Không dùng text tự do thay cho enum/danh mục đã chuẩn hóa.
- Schema thay đổi phải đi kèm data dictionary, migration hoặc ghi rõ lý do không cần migration, seed/test phù hợp và README liên quan.

## 5. Migration Rule

- Migration dùng cho nâng cấp database đã tồn tại, không dùng lẫn với unified schema trên cùng database test.
- Migration nên additive/idempotent nếu phù hợp.
- Không xóa migration chỉ vì đã merge vào unified schema; phân loại thành active, merged, test-only, legacy hoặc pending review.
- Không xóa constraint/index để làm test pass.

## 6. Seed Rule

- Seed production/reference nằm trong `database/seed/*.sql`.
- Seed test-only nằm trong `database/seed/test/` và không được thêm vào luồng production.
- Seed phải chạy lại được nhiều lần bằng `ON CONFLICT` hoặc cơ chế tương đương.
- Không đưa secret, dữ liệu cá nhân thật hoặc dữ liệu nguồn chưa kiểm chứng vào seed production.

## 7. Test Rule

- Sau thay đổi database, chạy tối thiểu empty PostgreSQL check, seed validation và statistics precheck.
- Nếu task chạm logic hình sự trả hồ sơ VKS, chạy wrapper lifecycle tương ứng.
- Nếu task chạm logic hình sự phúc thẩm theo bị cáo, chạy wrapper appellate defendant result.
- Nếu task chạm cấp xét xử/thành phần phiên tòa, chạy wrapper trial level/hearing members.
- Test fail thì không sửa test để che lỗi; phải sửa schema/seed/logic hoặc ghi rõ blocker.

## 8. Skill Update Rule

Sau mỗi task, AI Agent phải tự hỏi:

```text
Có quy tắc, logic, công thức, mapping, validation, SQL template, API contract hoặc UI pattern nào cần ghi lại thành skill để dùng lại không?
```

Nếu có, cập nhật skill hiện có hoặc tạo skill mới trong `knowledge_base/skills/`. Không để skill cũ gây hiểu nhầm; nếu bị thay thế, thêm trạng thái `DEPRECATED` hoặc `replaced_by`.

## 9. Backend/API Design Follow-up Rule

Sau mỗi task thiết kế database, AI Agent phải cân nhắc backend follow-up:

- entity/model/repository/service tương ứng;
- DTO/request/response;
- API list/detail/create/update;
- endpoint thống kê có `from_date`, `to_date`, `as_of_date` nếu nghiệp vụ cần;
- validation và permission;
- audit log cho hành động quan trọng.

## 10. Frontend Design Follow-up Rule

Sau mỗi task thiết kế database hoặc nghiệp vụ, AI Agent phải cân nhắc frontend follow-up:

- form nhập liệu;
- list/detail/report;
- bộ lọc thời gian và đơn vị;
- hiển thị danh mục từ API, không hard-code text lặp;
- cảnh báo validation;
- trường hợp thống kê theo occurrence/defendant-level.
- Khi dùng TasteSkill, phải áp dụng wrapper `skills/design_taste_frontend_skill.md`, giữ giao diện nghiêm túc phù hợp cơ quan nhà nước và không dùng TasteSkill để tạo nghiệp vụ, chỉ tiêu, công thức hoặc biểu mẫu.

## 11. Reporting Rule

- Task cleanup/refactor phải có báo cáo ngắn trong `docs/review/` nếu thay đổi nhiều file hoặc thay đổi workflow.
- Báo cáo phải nêu file đã xóa, archive, cập nhật, file giữ lại và lý do.
- Báo cáo test phải ghi lệnh chạy lại và kết quả pass/fail.

## 12. Cleanup/Archive Rule

- Trước khi xóa, dùng `rg` kiểm tra tham chiếu trong README/docs/tests/scripts/seed/CI nếu có.
- Nếu chưa chắc chắn, không xóa; ghi đề xuất trong báo cáo.
- File nguồn pháp luật, Excel gốc, JSON thống kê, diagram và report kiểm chứng quan trọng phải giữ.
- File lock/tạm rõ ràng như `~$*.xlsx` có thể xóa nếu không được tham chiếu.

## 13. Checklist/Plan Rule

Mỗi báo cáo cleanup hoặc task lớn phải có:

- checklist việc đã làm;
- migration/seed/test/skill status nếu liên quan;
- plans đã phê duyệt;
- plans đề xuất tiếp theo;
- lệnh test đã chạy.
