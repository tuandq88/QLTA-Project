# AGENTS.md

## Mục tiêu dự án

Xây dựng và phát triển ứng dụng miễn phí dùng để quản lý, điều hành hoạt động của TAND hai cấp tỉnh Quảng Ngãi.

Hệ thống phục vụ lãnh đạo theo dõi:

- tiến độ làm việc của từng Thẩm phán;
- thông tin thụ lý, giải quyết, tồn đọng, quá hạn của từng hồ sơ;
- vòng đời hồ sơ vụ án, vụ việc;
- kết quả phúc thẩm, giám đốc thẩm, tái thẩm của Tòa án cấp trên;
- chất lượng giải quyết, xét xử theo loại án, Thẩm phán và đơn vị;
- phân công án ngẫu nhiên theo đúng quy định.

## Nguyên tắc bắt buộc

- Không xóa file hiện có nếu không có yêu cầu rõ ràng.
- Không đổi nội dung nghiệp vụ của skill/rule khi chỉ làm nhiệm vụ sắp xếp cấu trúc.
- Mọi rule pháp lý phải có căn cứ từ tài liệu trong `Documents/` hoặc `docs/legal/`.
- Không tự bịa luật, biểu mẫu, chỉ tiêu hoặc công thức.
- Không cho phép đếm trùng số liệu thống kê.
- AI chỉ được ghi đề xuất, cảnh báo, validation; không tự ý ghi đè dữ liệu chính.
- Khi thay đổi schema, phải cập nhật tài liệu trong `database/` và README liên quan.

## Cấu trúc chuẩn

```text
knowledge_base/  Rule, skill, data dictionary, formula catalog, validation
database/        Diagram, schema, migration
backend/         Mã nguồn backend khi bắt đầu triển khai app
frontend/        Mã nguồn frontend khi bắt đầu triển khai app
tests/           Test nghiệp vụ, test database, test API/UI
docs/            Kế hoạch, tài liệu pháp lý, review, hướng dẫn triển khai
Documents/       PDF nguồn gốc ban đầu do dự án cung cấp
bieu_mau/        Biểu mẫu Excel gốc
```

## Quy trình làm việc cho AI Agent

1. Đọc `README.md`.
2. Đọc rule tổng tại `knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md`.
3. Nếu task liên quan nghiệp vụ, đọc skill tương ứng trong `knowledge_base/skills/`.
4. Nếu task liên quan database, đọc `database/diagrams/` và `database/schema/`.
5. Nếu task liên quan quy định pháp luật hoặc biểu mẫu, đối chiếu tài liệu trong `Documents/` hoặc `docs/legal/`.
6. Sau khi sửa, kiểm tra không làm mất file nguồn và không đổi nội dung nghiệp vụ ngoài phạm vi task.

## Định dạng task khuyến nghị

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
