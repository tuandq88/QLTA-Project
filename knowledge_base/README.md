# Knowledge Base

Thư mục này chứa nền tảng tri thức nghiệp vụ cho hệ thống quản lý, thống kê, giám sát và điều hành TAND hai cấp tỉnh Quảng Ngãi.

```text
knowledge_base/
├── rules/            Bộ quy tắc bắt buộc cho AI Agent
├── skills/           Skill nghiệp vụ đã gom theo nhóm
└── data/             Dữ liệu cấu hình nghiệp vụ dạng JSON
```

## Rules

Rule tổng:

```text
knowledge_base/rules/TAND_QUANGNGAI_AI_AGENT_RULES_V1.1.md
```

AI Agent phải đọc file này trước khi thực hiện task nghiệp vụ.

## Skills

```text
skills/core/                       Skill nền: tố tụng, KPI, validation, deadline
skills/statistics/                 Skill thống kê theo loại án
skills/random_assignment/          Skill phân công án ngẫu nhiên
skills/appeal_protest_tracking/    Skill theo dõi kháng cáo, kháng nghị, án hủy/sửa
```

## Data

Các JSON thống kê nằm tại:

```text
data/statistics/
├── all_case_types/
├── civil/
├── criminal/
├── administrative/
├── marriage_family/
├── business_commercial/
└── labor/
```

Tên file đã chuẩn hóa theo chức năng:

```text
formula_catalog.json
data_dictionary.json
column_mapping.json
input_mapping.json
validation_rules.json
```

Không phải nhóm án nào cũng có đủ tất cả các file trên. Khi thêm dữ liệu mới, giữ nguyên quy ước tên file này để backend, test và AI Agent dễ đọc.
