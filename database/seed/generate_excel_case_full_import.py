from __future__ import annotations

import csv
import hashlib
import json
import re
import unicodedata
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict
from dataclasses import dataclass
from datetime import date, timedelta
from pathlib import Path
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parents[2]
SOURCE_DIR = ROOT / "database" / "seed" / "danh_sach"
REPORT_PATH = ROOT / "tests" / "database" / "EXCEL_CASE_FULL_IMPORT_MAPPING_RESULT.md"
TRIAL_MEMBER_REPORT_PATH = ROOT / "tests" / "database" / "EXCEL_CASE_TRIAL_LEVEL_AND_HEARING_MEMBERS_RESULT.md"
CSV_PATH = ROOT / "docs" / "review" / "excel_case_full_import_records.csv"

OUT_CASES = ROOT / "database" / "seed" / "030_excel_seed_case_files.sql"
OUT_DETAILS = ROOT / "database" / "seed" / "031_excel_seed_case_details.sql"
OUT_PARTIES = ROOT / "database" / "seed" / "032_excel_seed_case_parties.sql"
OUT_EVENTS = ROOT / "database" / "seed" / "033_excel_seed_case_events_and_resolutions.sql"
OUT_HEARING_MEMBERS = ROOT / "database" / "seed" / "034_excel_seed_hearing_members.sql"

NS = {
    "a": "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
    "r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
}


@dataclass
class SourceRow:
    file_name: str
    sheet_name: str
    excel_row: int
    row_index: int
    case_code: str
    trial_level: str
    case_type: str
    case_group: str
    procedure_law: str
    case_number_raw: str
    acceptance_date: date
    decision_number: str | None
    decision_date: date | None
    hearing_date: date | None
    hearing_format: str | None
    chair_judge: str | None
    panel_members: str | None
    clerk: str | None
    plaintiff: str | None
    defendant: str | None
    defendants: str | None
    birth_years: str | None
    legal_relation_or_crime: str | None
    result_text: str | None
    appeal_text: str | None
    first_instance_court: str | None
    first_instance_decision_number: str | None
    first_instance_decision_date: date | None
    note: str | None
    source_json: dict


def col_number(ref: str) -> int:
    letters = "".join(ch for ch in ref if ch.isalpha())
    n = 0
    for ch in letters:
        n = n * 26 + ord(ch.upper()) - 64
    return n


def read_shared_strings(zf: ZipFile) -> list[str]:
    try:
        root = ET.fromstring(zf.read("xl/sharedStrings.xml"))
    except KeyError:
        return []
    strings: list[str] = []
    for item in root.findall("a:si", NS):
        strings.append("".join(t.text or "" for t in item.findall(".//a:t", NS)))
    return strings


def workbook_sheets(zf: ZipFile) -> list[tuple[str, str]]:
    workbook = ET.fromstring(zf.read("xl/workbook.xml"))
    rels = ET.fromstring(zf.read("xl/_rels/workbook.xml.rels"))
    id_to_target = {rel.attrib["Id"]: rel.attrib["Target"] for rel in rels}
    result: list[tuple[str, str]] = []
    for sheet in workbook.findall("a:sheets/a:sheet", NS):
        rid = sheet.attrib["{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id"]
        result.append((sheet.attrib["name"], "xl/" + id_to_target[rid].lstrip("/")))
    return result


def cell_value(cell: ET.Element, shared_strings: list[str]) -> str | None:
    kind = cell.attrib.get("t")
    if kind == "inlineStr":
        value = "".join(t.text or "" for t in cell.findall(".//a:t", NS))
        return value or None
    value_node = cell.find("a:v", NS)
    if value_node is None:
        return None
    value = value_node.text or ""
    if kind == "s":
        idx = int(value)
        return shared_strings[idx] if idx < len(shared_strings) else value
    return value


def read_xlsx(path: Path) -> dict[str, list[list[str | None]]]:
    sheets: dict[str, list[list[str | None]]] = {}
    with ZipFile(path) as zf:
        shared_strings = read_shared_strings(zf)
        for sheet_name, sheet_path in workbook_sheets(zf):
            root = ET.fromstring(zf.read(sheet_path))
            rows: list[list[str | None]] = []
            for row in root.findall("a:sheetData/a:row", NS):
                values: dict[int, str | None] = {}
                for cell in row.findall("a:c", NS):
                    values[col_number(cell.attrib["r"])] = cell_value(cell, shared_strings)
                max_col = max(values.keys(), default=0)
                rows.append([values.get(i) for i in range(1, max_col + 1)])
            sheets[sheet_name] = rows
    return sheets


def clean(value: object) -> str | None:
    if value is None:
        return None
    text = str(value).replace("\r\n", "\n").replace("\r", "\n")
    text = re.sub(r"[ \t]+\n", "\n", text)
    text = re.sub(r"\n{3,}", "\n\n", text)
    text = text.strip()
    return text or None


def split_people(value: str | None) -> list[str]:
    if not value:
        return []
    text = re.sub(r"\(Đầu vụ\)", "", value, flags=re.IGNORECASE)
    parts = re.split(r"\n|;|\|", text)
    result: list[str] = []
    seen: set[str] = set()
    for part in parts:
        name = re.sub(r"^\s*[-•]\s*", "", part).strip(" ,;")
        name = re.sub(r"\s+", " ", name)
        if name and name not in seen:
            seen.add(name)
            result.append(name)
    return result


def split_staff_names(value: str | None) -> list[str]:
    if not value:
        return []
    text = re.sub(r"\b(Thẩm\s*phán|TP\.?|Thư\s*ký|TK\.?)\b", "", value, flags=re.IGNORECASE)
    parts = re.split(r"\n|;|\||/", text)
    result: list[str] = []
    seen: set[str] = set()
    for part in parts:
        name = part.strip(" \t\r\n,;")
        name = re.sub(r"\s+", " ", name)
        if name and name not in seen:
            seen.add(name)
            result.append(name)
    return result


def normalize_staff_name(value: str) -> str:
    text = unicodedata.normalize("NFD", value)
    text = "".join(ch for ch in text if unicodedata.category(ch) != "Mn")
    text = text.replace("đ", "d").replace("Đ", "D").lower()
    text = re.sub(r"[^a-z0-9]+", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def split_parallel(value: str | None) -> list[str]:
    if not value:
        return []
    result: list[str] = []
    for part in re.split(r"\n|;|\|", value):
        item = re.sub(r"^\s*[-•]\s*", "", part).strip(" ,;")
        if item:
            result.append(re.sub(r"\s+", " ", item))
    return result


def excel_date_from_number(value: str | int | float | None) -> date | None:
    if value is None:
        return None
    try:
        number = float(str(value).strip())
    except ValueError:
        return None
    if number < 20000 or number > 60000:
        return None
    return date(1899, 12, 30) + timedelta(days=int(number))


def extract_date(value: str | int | float | None) -> date | None:
    if value is None:
        return None
    numeric = excel_date_from_number(value)
    if numeric:
        return numeric
    text = str(value)
    m = re.search(r"(\d{1,2})/(\d{1,2})/(\d{4})", text)
    if not m:
        return None
    day, month, year = map(int, m.groups())
    if year < 1900 or year > 2100:
        return None
    try:
        return date(year, month, day)
    except ValueError:
        return None


def first_line_before_date(value: str | None) -> str | None:
    if not value:
        return None
    text = str(value)
    text = re.sub(r"\d{1,2}/\d{1,2}/\d{4}", "", text)
    parts = [p.strip(" -;\n\t") for p in re.split(r"\n|\|", text) if p.strip(" -;\n\t")]
    return parts[0] if parts else None


def normalize_code(value: str, prefix: str = "") -> str:
    text = unicodedata.normalize("NFD", value)
    text = "".join(ch for ch in text if unicodedata.category(ch) != "Mn")
    text = text.replace("đ", "d").replace("Đ", "D").lower()
    text = re.sub(r"[^a-z0-9]+", "_", text).strip("_")
    if len(text) > 80:
        digest = hashlib.sha1(value.encode("utf-8")).hexdigest()[:8]
        text = text[:71].rstrip("_") + "_" + digest
    return f"{prefix}{text}" if prefix else text


def sql_string(value: str | None) -> str:
    if value is None or value == "":
        return "NULL"
    return "'" + value.replace("'", "''") + "'"


def sql_date(value: date | None) -> str:
    return "NULL" if value is None else f"DATE '{value.isoformat()}'"


def sql_bool(value: bool) -> str:
    return "TRUE" if value else "FALSE"


def is_appeal_text(value: str | None) -> bool:
    return bool(value and re.search(r"k/c|kháng cáo|khang cao", value, re.IGNORECASE))


def is_protest_text(value: str | None) -> bool:
    return bool(value and re.search(r"k/n|VKS|kháng nghị|khang nghi", value, re.IGNORECASE))


def appeal_type(value: str | None) -> str | None:
    has_appeal = is_appeal_text(value)
    has_protest = is_protest_text(value)
    if has_appeal and has_protest:
        return "BOTH"
    if has_protest:
        return "PROTEST"
    if has_appeal:
        return "APPEAL"
    return None


def appellate_result_code(value: str | None) -> str | None:
    if not value:
        return None
    lowered = value.lower()
    if "giữ nguyên" in lowered:
        return "upheld"
    if "sửa" in lowered:
        return "modified"
    if "hủy" in lowered or "huỷ" in lowered:
        return "cancelled"
    if "đình chỉ" in lowered:
        return "terminated"
    return "other_review_required"


def case_type_from_alias(alias: str | None, file_name: str) -> tuple[str, str, str]:
    value = (alias or file_name).lower()
    if "hình" in value:
        return "criminal", "criminal", "BLTTHS"
    if "hành chính" in value:
        return "administrative", "administrative", "LTTHC"
    if "hngđ" in value or "hôn nhân" in value or "hon nhan" in value:
        return "marriage_family", "marriage_family", "BLTTDS"
    if "kdtm" in value or "kinh doanh" in value:
        return "business_commercial", "business_commercial", "BLTTDS"
    if "lao" in value:
        return "labor", "labor", "BLTTDS"
    return "civil", "civil", "BLTTDS"


def parse_row(file_name: str, sheet_name: str, excel_row: int, headers: list[str | None], row: list[str | None], index: int) -> tuple[SourceRow | None, str | None]:
    h = [clean(x) or "" for x in headers]
    values = {h[i]: clean(row[i]) if i < len(row) else None for i in range(len(h))}
    trial_level = "phuc_tham" if "Phúc thẩm" in file_name else "so_tham"

    if file_name.startswith("Hình sự - Sơ thẩm"):
        raw = values.get("Số/ngày thụ lý")
        acceptance = extract_date(raw)
        if not acceptance:
            return None, "Thiếu hoặc không đọc được ngày thụ lý"
        case_type, source_group, procedure = "criminal", "criminal", "BLTTHS"
        decision_raw = values.get("Số/Ngày BA/QD")
        relation = values.get("Tội danh")
        defendants = values.get("Họ và tên bị cáo")
        result = values.get("Kết quả XXST")
        appeal = values.get("Kháng cáo/Kháng nghị")
        decision_date = extract_date(decision_raw)
        hearing_date = decision_date
        source = values
    elif file_name.startswith("Hình sự - Phúc thẩm"):
        raw = values.get("Số/Ngày TL")
        acceptance = extract_date(raw)
        if not acceptance:
            return None, "Thiếu hoặc không đọc được ngày thụ lý"
        case_type, source_group, procedure = "criminal", "criminal", "BLTTHS"
        decision_raw = values.get("Số BA/QĐ PT")
        relation = values.get("Tội danh")
        defendants = values.get("Họ và tên")
        result = values.get("Kết quả XXPT")
        appeal = values.get("KC/KN")
        decision_date = extract_date(values.get("Ngày BA/QĐ PT"))
        hearing_date = None
        source = values
    elif file_name.startswith("Dân sự mở rộng - Sơ thẩm"):
        raw = values.get("Số/ngày thụ lý")
        acceptance = extract_date(raw)
        if not acceptance:
            return None, "Thiếu hoặc không đọc được ngày thụ lý"
        case_type, source_group, procedure = case_type_from_alias(values.get("Loại án"), file_name)
        decision_raw = values.get("Số/Ngày BA/QD")
        relation = values.get("Quan hệ pháp luật")
        defendants = None
        result = values.get("Ghi chú")
        appeal = values.get("Kháng cáo/Kháng nghị")
        decision_date = extract_date(decision_raw)
        hearing_date = decision_date
        source = values
    else:
        raw = values.get("Số/Ngày TL")
        acceptance = extract_date(raw)
        if not acceptance:
            return None, "Thiếu hoặc không đọc được ngày thụ lý"
        case_type, source_group, procedure = case_type_from_alias(values.get("Loại án"), file_name)
        decision_raw = None
        relation = values.get("Vụ việc")
        defendants = None
        result = values.get("Kết quả XXPT")
        appeal = values.get("KC/KN")
        decision_date = None
        hearing_date = extract_date(values.get("Ngày xử"))
        source = values

    slug = normalize_code(file_name.replace(".xlsx", "").replace(" ", "_").replace("ở", "o").replace("ự", "u")).upper()
    case_code = f"EXCEL-{slug}-{excel_row:04d}"
    return SourceRow(
        file_name=file_name,
        sheet_name=sheet_name,
        excel_row=excel_row,
        row_index=index,
        case_code=case_code,
        trial_level=trial_level,
        case_type=case_type,
        case_group="PHUC_THAM" if trial_level == "phuc_tham" else "SO_THAM",
        procedure_law=procedure,
        case_number_raw=first_line_before_date(raw) or case_code,
        acceptance_date=acceptance,
        decision_number=first_line_before_date(decision_raw),
        decision_date=decision_date,
        hearing_date=hearing_date,
        hearing_format=values.get("Hình thức xét xử"),
        chair_judge=values.get("Chủ toạ") or values.get("Thẩm phán"),
        panel_members=values.get("Thành viên") or values.get("Hội đồng"),
        clerk=values.get("Thư ký"),
        plaintiff=values.get("Nguyên đơn") or values.get("Nguyên đơn/NKK"),
        defendant=values.get("Bị đơn") or values.get("Bị đơn/NBK"),
        defendants=defendants,
        birth_years=values.get("Năm sinh"),
        legal_relation_or_crime=relation,
        result_text=result,
        appeal_text=appeal,
        first_instance_court=values.get("Tòa án xét xử sơ thẩm") or values.get("Tòa án xét xử Sơ thẩm"),
        first_instance_decision_number=first_line_before_date(values.get("Số BA/QĐ ST")),
        first_instance_decision_date=extract_date(values.get("Ngày BA/QĐ ST")),
        note=values.get("Ghi chú"),
        source_json=source,
    ), None


def load_records() -> tuple[list[SourceRow], list[dict], list[dict]]:
    records: list[SourceRow] = []
    skipped: list[dict] = []
    workbook_report: list[dict] = []
    for workbook in sorted(SOURCE_DIR.glob("*.xlsx")):
        sheets = read_xlsx(workbook)
        for sheet_name, rows in sheets.items():
            if len(rows) < 4:
                continue
            headers = rows[2]
            data_rows = rows[3:]
            valid_before = len(records)
            skipped_before = len(skipped)
            for offset, row in enumerate(data_rows, start=4):
                if not any(clean(cell) for cell in row):
                    continue
                parsed, reason = parse_row(workbook.name, sheet_name, offset, headers, row, len(records) + 1)
                if parsed:
                    records.append(parsed)
                else:
                    skipped.append({"file": workbook.name, "sheet": sheet_name, "row": offset, "reason": reason or "Không đủ dữ liệu"})
            workbook_report.append(
                {
                    "file": workbook.name,
                    "sheet": sheet_name,
                    "columns": [clean(x) or "" for x in headers],
                    "total_rows": sum(1 for r in data_rows if any(clean(c) for c in r)),
                    "valid_rows": len(records) - valid_before,
                    "skipped_rows": len(skipped) - skipped_before,
                }
            )
    return records, skipped, workbook_report


def case_status(record: SourceRow) -> tuple[str, str, str | None]:
    if record.decision_date or record.result_text:
        return "resolved", "resolved", "resolved"
    if record.appeal_text and record.trial_level == "so_tham":
        return "appealed", "appeal_tracking", "appealed"
    if record.trial_level == "phuc_tham":
        return "accepted", "appeal_tracking", None
    return "accepted", "accepted", None


def source_summary(record: SourceRow) -> str:
    parts = [
        f"Nguồn Excel: {record.file_name} / {record.sheet_name} / dòng {record.excel_row}.",
        f"Cấp xét xử: {'phúc thẩm' if record.trial_level == 'phuc_tham' else 'sơ thẩm'}.",
        f"Loại án map: {record.case_type}.",
        f"Số/ngày thụ lý: {record.case_number_raw} / {record.acceptance_date.strftime('%d/%m/%Y')}.",
    ]
    if record.chair_judge:
        parts.append(f"Thẩm phán/Chủ tọa: {record.chair_judge}.")
    if record.plaintiff or record.defendant:
        parts.append(f"Đương sự: {record.plaintiff or ''} ; {record.defendant or ''}.")
    if record.defendants:
        parts.append(f"Bị cáo: {record.defendants}.")
    if record.legal_relation_or_crime:
        parts.append(f"Quan hệ pháp luật/Tội danh: {record.legal_relation_or_crime}.")
    if record.appeal_text:
        parts.append(f"Kháng cáo/kháng nghị: {record.appeal_text}.")
    if record.result_text:
        parts.append(f"Kết quả: {record.result_text}.")
    return "\n".join(parts)


def values_block(rows: list[tuple]) -> str:
    return ",\n".join("        (" + ", ".join(item for item in row) + ")" for row in rows)


def write_case_seed(records: list[SourceRow]) -> None:
    rows = []
    for r in records:
        status, stage, resolution = case_status(r)
        closed_date = r.decision_date if r.decision_date and r.decision_date >= r.acceptance_date else None
        rows.append(
            (
                sql_string(r.case_code),
                sql_string(r.case_code),
                f"'{r.case_type}'::case_type_enum",
                sql_string(r.case_group),
                sql_string(r.procedure_law),
                sql_date(r.acceptance_date),
                sql_date(r.acceptance_date),
                sql_string(stage),
                f"'{status}'::case_status_enum",
                sql_string(resolution),
                sql_date(closed_date),
                sql_string(source_summary(r)),
            )
        )
    sql = f"""-- Seed 030: Excel-derived case_files from database/seed/danh_sach/*.xlsx.
-- Generated by database/seed/generate_excel_case_full_import.py.
-- Each source row with a readable acceptance date becomes one case_files row.

BEGIN;

INSERT INTO courts (court_id, court_code, court_name, court_level, province, court_level_id)
SELECT
    uuid_generate_v5(uuid_ns_url(), 'qlta:excel_seed:tand_quang_ngai'),
    'EXCEL_SEED_TAND_QNG',
    'TAND tỉnh Quảng Ngãi - nguồn seed Excel',
    'province',
    'Quảng Ngãi',
    dci.item_id
FROM dm_categories dc
LEFT JOIN dm_category_items dci ON dci.category_id = dc.category_id AND dci.item_code = 'province'
WHERE dc.category_code = 'court_level'
ON CONFLICT (court_code) DO UPDATE SET
    court_name = EXCLUDED.court_name,
    court_level = EXCLUDED.court_level,
    province = EXCLUDED.province,
    court_level_id = EXCLUDED.court_level_id,
    updated_at = CURRENT_TIMESTAMP;

WITH source_rows(case_code, case_number, case_type, case_group, procedure_law, filing_date, acceptance_date, current_stage, case_status, resolution_status, closed_date, summary) AS (
    VALUES
{values_block(rows)}
),
resolved AS (
    SELECT
        sr.*,
        court.court_id,
        ct.item_id AS case_type_id,
        cg.item_id AS case_group_id,
        pl.item_id AS procedure_law_id,
        cs.item_id AS current_stage_id,
        st.item_id AS case_status_id,
        rs.item_id AS resolution_status_id
    FROM source_rows sr
    CROSS JOIN courts court
    LEFT JOIN dm_categories ct_cat ON ct_cat.category_code = 'case_type'
    LEFT JOIN dm_category_items ct ON ct.category_id = ct_cat.category_id AND ct.item_code = sr.case_type::text
    LEFT JOIN dm_categories cg_cat ON cg_cat.category_code = 'case_group'
    LEFT JOIN dm_category_items cg ON cg.category_id = cg_cat.category_id AND cg.item_code = sr.case_group
    LEFT JOIN dm_categories pl_cat ON pl_cat.category_code = 'procedure_law'
    LEFT JOIN dm_category_items pl ON pl.category_id = pl_cat.category_id AND pl.item_code = sr.procedure_law
    LEFT JOIN dm_categories cs_cat ON cs_cat.category_code = 'case_stage'
    LEFT JOIN dm_category_items cs ON cs.category_id = cs_cat.category_id AND cs.item_code = sr.current_stage
    LEFT JOIN dm_categories st_cat ON st_cat.category_code = 'case_status'
    LEFT JOIN dm_category_items st ON st.category_id = st_cat.category_id AND st.item_code = sr.case_status::text
    LEFT JOIN dm_categories rs_cat ON rs_cat.category_code = 'case_status'
    LEFT JOIN dm_category_items rs ON rs.category_id = rs_cat.category_id AND rs.item_code = sr.resolution_status
    WHERE court.court_code = 'EXCEL_SEED_TAND_QNG'
)
INSERT INTO case_files (
    court_id, case_code, case_number, case_type, case_group, procedure_law,
    filing_date, acceptance_date, current_stage, case_status, resolution_status,
    closed_date, summary, case_type_id, case_group_id, procedure_law_id,
    current_stage_id, case_status_id, resolution_status_id
)
SELECT
    court_id, case_code, case_number, case_type, case_group, procedure_law,
    filing_date, acceptance_date, current_stage, case_status, resolution_status,
    closed_date, summary, case_type_id, case_group_id, procedure_law_id,
    current_stage_id, case_status_id, resolution_status_id
FROM resolved
ON CONFLICT (case_code) DO UPDATE SET
    court_id = EXCLUDED.court_id,
    case_number = EXCLUDED.case_number,
    case_type = EXCLUDED.case_type,
    case_group = EXCLUDED.case_group,
    procedure_law = EXCLUDED.procedure_law,
    filing_date = EXCLUDED.filing_date,
    acceptance_date = EXCLUDED.acceptance_date,
    current_stage = EXCLUDED.current_stage,
    case_status = EXCLUDED.case_status,
    resolution_status = EXCLUDED.resolution_status,
    closed_date = EXCLUDED.closed_date,
    summary = EXCLUDED.summary,
    case_type_id = EXCLUDED.case_type_id,
    case_group_id = EXCLUDED.case_group_id,
    procedure_law_id = EXCLUDED.procedure_law_id,
    current_stage_id = EXCLUDED.current_stage_id,
    case_status_id = EXCLUDED.case_status_id,
    resolution_status_id = EXCLUDED.resolution_status_id,
    updated_at = CURRENT_TIMESTAMP;

COMMIT;
"""
    OUT_CASES.write_text(sql, encoding="utf-8")


def write_detail_seed(records: list[SourceRow]) -> None:
    civil_rows = []
    admin_rows = []
    criminal_rows = []
    claims_rows = []
    legal_rows = []
    defendant_rows = []
    charge_rows = []
    sentence_rows = []
    for r in records:
        if r.case_type == "criminal":
            criminal_rows.append((sql_string(r.case_code), sql_string(r.first_instance_court), sql_string(r.acceptance_date.isoformat()), sql_bool(any_minor(r))))
            defendants = split_people(r.defendants)
            birth_years = split_parallel(r.birth_years)
            crimes = split_parallel(r.legal_relation_or_crime)
            sentences = split_parallel(r.result_text)
            for idx, name in enumerate(defendants):
                birth_date = None
                if idx < len(birth_years) and re.fullmatch(r"\d{4}", birth_years[idx]):
                    birth_date = date(int(birth_years[idx]), 1, 1)
                defendant_rows.append((sql_string(r.case_code), sql_string(name), sql_date(birth_date), sql_bool(is_minor_year(birth_date, r.acceptance_date))))
                crime = crimes[idx] if idx < len(crimes) else (crimes[0] if crimes else None)
                if crime:
                    charge_rows.append((sql_string(r.case_code), sql_string(name), sql_date(birth_date), sql_string(crime)))
                sentence = sentences[idx] if idx < len(sentences) else (sentences[0] if sentences else None)
                if sentence:
                    sentence_rows.append((sql_string(r.case_code), sql_string(name), sql_date(birth_date), sql_string(sentence_type(sentence)), sql_string(sentence)))
        elif r.case_type == "administrative":
            admin_rows.append((sql_string(r.case_code), sql_string(r.legal_relation_or_crime), sql_string(flat_first(r.defendant)), sql_string(r.legal_relation_or_crime)))
        else:
            civil_rows.append((sql_string(r.case_code), sql_string(r.case_type), sql_string(r.legal_relation_or_crime), sql_bool(False), sql_string(None)))
            if r.plaintiff or r.defendant or r.legal_relation_or_crime:
                claims_rows.append((sql_string(r.case_code), sql_string(r.case_type), sql_string(flat_first(r.plaintiff)), sql_string(flat_first(r.defendant)), sql_string(r.legal_relation_or_crime), sql_string("resolved" if r.decision_date or r.result_text else "pending")))
        if r.legal_relation_or_crime and r.case_type != "criminal":
            legal_rows.append((sql_string(r.case_code), sql_string(r.legal_relation_or_crime), sql_string(r.case_type)))
    sql = f"""-- Seed 031: Excel-derived case detail tables.
-- Generated by database/seed/generate_excel_case_full_import.py.

BEGIN;

WITH src(case_code, civil_category, dispute_type, mediation_completed, mediation_result) AS (
    VALUES
{values_block(civil_rows) if civil_rows else "        (NULL, NULL, NULL, NULL, NULL)"}
)
INSERT INTO civil_case_details (case_id, civil_category, dispute_type, mediation_completed, mediation_result, civil_category_id, dispute_type_id, mediation_result_id)
SELECT cf.case_id, src.civil_category, src.dispute_type, src.mediation_completed, src.mediation_result,
       cat_item.item_id, rel.legal_relationship_id, med_item.item_id
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
LEFT JOIN dm_categories cat ON cat.category_code = 'case_type'
LEFT JOIN dm_category_items cat_item ON cat_item.category_id = cat.category_id AND cat_item.item_code = src.civil_category
LEFT JOIN dm_legal_relationships rel ON lower(btrim(rel.relationship_name)) = lower(btrim(src.dispute_type)) AND rel.case_type_scope = src.civil_category
LEFT JOIN dm_categories med_cat ON med_cat.category_code = 'item_status'
LEFT JOIN dm_category_items med_item ON med_item.category_id = med_cat.category_id AND med_item.item_code = src.mediation_result
WHERE src.case_code IS NOT NULL
ON CONFLICT (case_id) DO UPDATE SET
    civil_category = EXCLUDED.civil_category,
    dispute_type = EXCLUDED.dispute_type,
    mediation_completed = EXCLUDED.mediation_completed,
    mediation_result = EXCLUDED.mediation_result,
    civil_category_id = EXCLUDED.civil_category_id,
    dispute_type_id = EXCLUDED.dispute_type_id,
    mediation_result_id = EXCLUDED.mediation_result_id;

WITH src(case_code, civil_category, claimant_name, respondent_name, claim_content, claim_status) AS (
    VALUES
{values_block(claims_rows) if claims_rows else "        (NULL, NULL, NULL, NULL, NULL, NULL)"}
)
INSERT INTO civil_claims (civil_detail_id, claim_type, claimant_name, respondent_name, claim_content, claim_status)
SELECT d.civil_detail_id, src.civil_category, src.claimant_name, src.respondent_name, src.claim_content, src.claim_status
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
JOIN civil_case_details d ON d.case_id = cf.case_id
WHERE src.case_code IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM civil_claims c
      WHERE c.civil_detail_id = d.civil_detail_id
        AND COALESCE(c.claim_type, '') = COALESCE(src.civil_category, '')
        AND COALESCE(c.claimant_name, '') = COALESCE(src.claimant_name, '')
        AND COALESCE(c.respondent_name, '') = COALESCE(src.respondent_name, '')
  );

WITH src(case_code, lawsuit_type, defendant_agency_name, object_summary) AS (
    VALUES
{values_block(admin_rows) if admin_rows else "        (NULL, NULL, NULL, NULL)"}
)
INSERT INTO administrative_case_details (case_id, lawsuit_type, defendant_agency_name, jurisdiction_basis)
SELECT cf.case_id, src.lawsuit_type, src.defendant_agency_name, 'Nguồn Excel danh sách án'
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
WHERE src.case_code IS NOT NULL
ON CONFLICT (case_id) DO UPDATE SET
    lawsuit_type = EXCLUDED.lawsuit_type,
    defendant_agency_name = EXCLUDED.defendant_agency_name,
    jurisdiction_basis = EXCLUDED.jurisdiction_basis;

WITH src(case_code, lawsuit_type, defendant_agency_name, object_summary) AS (
    VALUES
{values_block(admin_rows) if admin_rows else "        (NULL, NULL, NULL, NULL)"}
)
INSERT INTO challenged_admin_objects (admin_detail_id, object_type, issuing_agency, object_summary, challenged_scope)
SELECT d.admin_detail_id, 'administrative_act_or_decision', src.defendant_agency_name, src.object_summary, src.lawsuit_type
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
JOIN administrative_case_details d ON d.case_id = cf.case_id
WHERE src.case_code IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM challenged_admin_objects obj
      WHERE obj.admin_detail_id = d.admin_detail_id
        AND COALESCE(obj.object_type, '') = 'administrative_act_or_decision'
        AND COALESCE(obj.object_summary, '') = COALESCE(src.object_summary, '')
  );

WITH src(case_code, procuracy_name, dossier_received_date_text, has_minor_defendant) AS (
    VALUES
{values_block(criminal_rows) if criminal_rows else "        (NULL, NULL, NULL, NULL)"}
)
INSERT INTO criminal_case_details (case_id, procuracy_name, dossier_received_date, has_minor_defendant, trial_panel_type)
SELECT cf.case_id, src.procuracy_name, src.dossier_received_date_text::date, src.has_minor_defendant, 'excel_seed'
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
WHERE src.case_code IS NOT NULL
ON CONFLICT (case_id) DO UPDATE SET
    procuracy_name = EXCLUDED.procuracy_name,
    dossier_received_date = EXCLUDED.dossier_received_date,
    has_minor_defendant = EXCLUDED.has_minor_defendant,
    trial_panel_type = EXCLUDED.trial_panel_type;

WITH src(case_code, full_name, date_of_birth, is_minor) AS (
    VALUES
{values_block(defendant_rows) if defendant_rows else "        (NULL, NULL, NULL, NULL)"}
)
INSERT INTO defendants (criminal_detail_id, full_name, date_of_birth, is_minor)
SELECT d.criminal_detail_id, src.full_name, src.date_of_birth, src.is_minor
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
JOIN criminal_case_details d ON d.case_id = cf.case_id
WHERE src.case_code IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM defendants old
      WHERE old.criminal_detail_id = d.criminal_detail_id
        AND lower(old.full_name) = lower(src.full_name)
        AND COALESCE(old.date_of_birth, DATE '0001-01-01') = COALESCE(src.date_of_birth, DATE '0001-01-01')
  );

WITH src(case_code, full_name, date_of_birth, crime_name) AS (
    VALUES
{values_block(charge_rows) if charge_rows else "        (NULL, NULL, NULL, NULL)"}
)
INSERT INTO charges (defendant_id, crime_name, crime_id)
SELECT def.defendant_id, src.crime_name, crime.crime_id
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
JOIN criminal_case_details d ON d.case_id = cf.case_id
JOIN defendants def ON def.criminal_detail_id = d.criminal_detail_id
    AND lower(def.full_name) = lower(src.full_name)
    AND COALESCE(def.date_of_birth, DATE '0001-01-01') = COALESCE(src.date_of_birth, DATE '0001-01-01')
LEFT JOIN dm_crimes crime ON lower(btrim(crime.crime_name)) = lower(btrim(src.crime_name))
WHERE src.case_code IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM charges old
      WHERE old.defendant_id = def.defendant_id
        AND COALESCE(old.crime_name, '') = COALESCE(src.crime_name, '')
  );

WITH src(case_code, full_name, date_of_birth, sentence_type, sentence_text) AS (
    VALUES
{values_block(sentence_rows) if sentence_rows else "        (NULL, NULL, NULL, NULL, NULL)"}
)
INSERT INTO sentences (defendant_id, sentence_type, additional_penalty)
SELECT def.defendant_id, src.sentence_type, src.sentence_text
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
JOIN criminal_case_details d ON d.case_id = cf.case_id
JOIN defendants def ON def.criminal_detail_id = d.criminal_detail_id
    AND lower(def.full_name) = lower(src.full_name)
    AND COALESCE(def.date_of_birth, DATE '0001-01-01') = COALESCE(src.date_of_birth, DATE '0001-01-01')
WHERE src.case_code IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM sentences old
      WHERE old.defendant_id = def.defendant_id
        AND COALESCE(old.additional_penalty, '') = COALESCE(src.sentence_text, '')
  );

WITH src(case_code, relationship_name, case_type_scope) AS (
    VALUES
{values_block(legal_rows) if legal_rows else "        (NULL, NULL, NULL)"}
)
INSERT INTO case_legal_relationships (case_id, legal_relationship_id, note)
SELECT cf.case_id, rel.legal_relationship_id, 'Nguồn Excel danh sách án'
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
JOIN dm_legal_relationships rel ON lower(btrim(rel.relationship_name)) = lower(btrim(src.relationship_name))
    AND rel.case_type_scope = src.case_type_scope
WHERE src.case_code IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM case_legal_relationships old
      WHERE old.case_id = cf.case_id AND old.legal_relationship_id = rel.legal_relationship_id
  );

COMMIT;
"""
    OUT_DETAILS.write_text(sql, encoding="utf-8")


def flat_first(value: str | None) -> str | None:
    people = split_people(value)
    return people[0] if people else clean(value)


def is_minor_year(birth_date: date | None, acceptance: date) -> bool:
    return bool(birth_date and acceptance.year - birth_date.year < 18)


def any_minor(record: SourceRow) -> bool:
    for raw in split_parallel(record.birth_years):
        if re.fullmatch(r"\d{4}", raw) and record.acceptance_date.year - int(raw) < 18:
            return True
    return False


def sentence_type(value: str) -> str:
    lowered = value.lower()
    if "án treo" in lowered:
        return "suspended_sentence"
    if "tù" in lowered:
        return "imprisonment"
    if "phạt tiền" in lowered:
        return "fine"
    return "other"


def write_party_seed(records: list[SourceRow]) -> None:
    rows = []
    for r in records:
        if r.plaintiff:
            for name in split_people(r.plaintiff):
                rows.append((sql_string(r.case_code), sql_string("plaintiff"), sql_string(name), "NULL", sql_string("Nguồn Excel: nguyên đơn/người khởi kiện")))
        if r.defendant:
            ptype = "agency" if r.case_type == "administrative" else "defendant"
            for name in split_people(r.defendant):
                if r.case_type == "administrative":
                    rows.append((sql_string(r.case_code), sql_string(ptype), "NULL", sql_string(name), sql_string("Nguồn Excel: người/cơ quan bị kiện")))
                else:
                    rows.append((sql_string(r.case_code), sql_string(ptype), sql_string(name), "NULL", sql_string("Nguồn Excel: bị đơn/người bị kiện")))
        if r.defendants:
            for name in split_people(r.defendants):
                rows.append((sql_string(r.case_code), sql_string("defendant"), sql_string(name), "NULL", sql_string("Nguồn Excel: bị cáo")))
        if r.appeal_text and appeal_type(r.appeal_text):
            rows.append((sql_string(r.case_code), sql_string("appellant"), "NULL", "NULL", sql_string(r.appeal_text)))
    sql = f"""-- Seed 032: Excel-derived participants/parties.
-- Generated by database/seed/generate_excel_case_full_import.py.

BEGIN;

WITH src(case_code, participant_type, full_name, organization_name, note) AS (
    VALUES
{values_block(rows) if rows else "        (NULL, NULL, NULL, NULL, NULL)"}
),
resolved AS (
    SELECT cf.case_id, src.*, item.item_id AS participant_type_id
    FROM src
    JOIN case_files cf ON cf.case_code = src.case_code
    LEFT JOIN dm_categories cat ON cat.category_code = 'participant_type'
    LEFT JOIN dm_category_items item ON item.category_id = cat.category_id AND item.item_code = src.participant_type
    WHERE src.case_code IS NOT NULL
)
INSERT INTO participants (case_id, participant_type, full_name, organization_name, note, participant_type_id)
SELECT case_id, participant_type, full_name, organization_name, note, participant_type_id
FROM resolved r
WHERE NOT EXISTS (
    SELECT 1 FROM participants p
    WHERE p.case_id = r.case_id
      AND p.participant_type = r.participant_type
      AND COALESCE(p.full_name, '') = COALESCE(r.full_name, '')
      AND COALESCE(p.organization_name, '') = COALESCE(r.organization_name, '')
);

COMMIT;
"""
    OUT_PARTIES.write_text(sql, encoding="utf-8")


def write_event_seed(records: list[SourceRow]) -> None:
    event_rows = []
    hearing_rows = []
    decision_rows = []
    appeal_rows = []
    tracking_rows = []
    result_rows = []
    for r in records:
        event_rows.append((sql_string(r.case_code), sql_string("accepted"), sql_string("accepted"), sql_date(r.acceptance_date), sql_string("Thụ lý từ dòng Excel nguồn")))
        if r.hearing_date or r.hearing_format:
            hearing_rows.append((sql_string(r.case_code), sql_string("trial"), sql_date(r.hearing_date), sql_string(r.panel_members), sql_string("closed" if r.decision_date else "scheduled"), sql_date(r.hearing_date), sql_string(r.hearing_format)))
        if r.decision_number or r.decision_date or r.result_text:
            dtype = "judgment" if r.decision_number else "decision"
            decision_rows.append((sql_string(r.case_code), sql_string(dtype), sql_string(r.decision_number), sql_date(r.decision_date), sql_string(appellate_result_code(r.result_text) or ("resolved" if r.decision_date else None)), sql_string(r.result_text), sql_bool(r.trial_level == "phuc_tham" or not r.appeal_text)))
        ap_type = appeal_type(r.appeal_text)
        if ap_type:
            appeal_rows.append((sql_string(r.case_code), sql_string(ap_type), sql_string(ap_type), sql_date(r.acceptance_date), sql_string(r.appeal_text), sql_string("resolved" if r.trial_level == "phuc_tham" and r.result_text else "received")))
        if r.trial_level == "phuc_tham" and ap_type and (r.decision_number or r.decision_date or r.result_text):
            code = appellate_result_code(r.result_text) or "other"
            tracking_rows.append((sql_string(r.case_code), sql_string(ap_type), sql_date(r.acceptance_date), sql_date(r.decision_date or r.acceptance_date), sql_string(code), sql_string("resolved" if r.result_text else "received"), sql_string(r.result_text)))
            if r.result_text:
                result_rows.append((sql_string(r.case_code), sql_string(ap_type), sql_string(r.decision_number), sql_date(r.decision_date or r.acceptance_date), sql_string(code), sql_string(r.result_text)))
    sql = f"""-- Seed 033: Excel-derived case events, hearings, decisions, appeals and appellate tracking.
-- Generated by database/seed/generate_excel_case_full_import.py.

BEGIN;

WITH src(case_code, event_type, event_stage, event_date, description) AS (
    VALUES
{values_block(event_rows)}
)
INSERT INTO case_events (case_id, event_type, event_stage, event_date, description)
SELECT cf.case_id, src.event_type, src.event_stage, src.event_date, src.description
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
WHERE NOT EXISTS (
    SELECT 1 FROM case_events e
    WHERE e.case_id = cf.case_id AND e.event_type = src.event_type AND e.event_date = src.event_date
);

WITH src(case_code, hearing_type, scheduled_date, panel_composition, hearing_status, actual_opened_date, note) AS (
    VALUES
{values_block(hearing_rows) if hearing_rows else "        (NULL, NULL, NULL, NULL, NULL, NULL, NULL)"}
)
INSERT INTO hearings (case_id, hearing_type, scheduled_date, panel_composition, hearing_status, actual_opened_date, actual_closed_date, note)
SELECT cf.case_id, src.hearing_type, src.scheduled_date, src.panel_composition, src.hearing_status, src.actual_opened_date, src.actual_opened_date, src.note
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
WHERE src.case_code IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM hearings h
      WHERE h.case_id = cf.case_id
        AND COALESCE(h.hearing_type, '') = COALESCE(src.hearing_type, '')
        AND COALESCE(h.scheduled_date, DATE '0001-01-01') = COALESCE(src.scheduled_date, DATE '0001-01-01')
  );

WITH src(case_code, decision_type, decision_number, decision_date, result_code, result_summary, is_final) AS (
    VALUES
{values_block(decision_rows) if decision_rows else "        (NULL, NULL, NULL, NULL, NULL, NULL, NULL)"}
),
resolved AS (
    SELECT cf.case_id, src.*, dtype.item_id AS decision_type_id, result_item.item_id AS result_code_id
    FROM src
    JOIN case_files cf ON cf.case_code = src.case_code
    LEFT JOIN dm_categories dtype_cat ON dtype_cat.category_code = 'decision_type'
    LEFT JOIN dm_category_items dtype ON dtype.category_id = dtype_cat.category_id AND dtype.item_code = src.decision_type
    LEFT JOIN dm_categories result_cat ON result_cat.category_code = 'appellate_result'
    LEFT JOIN dm_category_items result_item ON result_item.category_id = result_cat.category_id AND result_item.item_code = src.result_code
    WHERE src.case_code IS NOT NULL
)
INSERT INTO decisions (case_id, decision_type, decision_number, decision_date, result_code, result_summary, is_final, decision_type_id, result_code_id, trial_result_type_id)
SELECT case_id, decision_type, decision_number, decision_date, result_code, result_summary, is_final, decision_type_id, result_code_id, NULL
FROM resolved r
WHERE NOT EXISTS (
    SELECT 1 FROM decisions d
    WHERE d.case_id = r.case_id
      AND d.decision_type = r.decision_type
      AND COALESCE(d.decision_number, '') = COALESCE(r.decision_number, '')
);

WITH src(case_code, appeal_type, appellant_type, appeal_date, appeal_scope, appeal_status) AS (
    VALUES
{values_block(appeal_rows) if appeal_rows else "        (NULL, NULL, NULL, NULL, NULL, NULL)"}
)
INSERT INTO appeals (case_id, appeal_type, appellant_type, appeal_date, appeal_scope, appeal_status)
SELECT cf.case_id, src.appeal_type, src.appellant_type, src.appeal_date, src.appeal_scope, src.appeal_status
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
WHERE src.case_code IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM appeals a
      WHERE a.case_id = cf.case_id
        AND a.appeal_type = src.appeal_type
        AND COALESCE(a.appeal_date, DATE '0001-01-01') = COALESCE(src.appeal_date, DATE '0001-01-01')
        AND COALESCE(a.appeal_scope, '') = COALESCE(src.appeal_scope, '')
  );

WITH src(case_code, appeal_protest_type, received_date, resolved_date, final_result_code, tracking_status, note) AS (
    VALUES
{values_block(tracking_rows) if tracking_rows else "        (NULL, NULL, NULL, NULL, NULL, NULL, NULL)"}
),
base AS (
    SELECT
        cf.case_id,
        cf.court_id,
        d.decision_id,
        src.*,
        ap_type.appeal_protest_type_id AS appeal_protest_type_catalog_id,
        track.item_id AS tracking_status_id,
        final_item.item_id AS final_result_id,
        final_code.appellate_result_code_id AS final_result_code_id
    FROM src
    JOIN case_files cf ON cf.case_code = src.case_code
    JOIN decisions d ON d.case_id = cf.case_id
    LEFT JOIN dm_appeal_protest_types ap_type ON ap_type.type_code = src.appeal_protest_type
    LEFT JOIN dm_categories track_cat ON track_cat.category_code = 'tracking_status'
    LEFT JOIN dm_category_items track ON track.category_id = track_cat.category_id AND track.item_code = src.tracking_status
    LEFT JOIN dm_categories final_cat ON final_cat.category_code = 'appellate_result'
    LEFT JOIN dm_category_items final_item ON final_item.category_id = final_cat.category_id AND final_item.item_code = src.final_result_code
    LEFT JOIN dm_appellate_result_codes final_code ON final_code.result_code = src.final_result_code
    WHERE src.case_code IS NOT NULL
)
INSERT INTO appellate_trackings (
    original_case_id, original_decision_id, original_court_id, case_type, appeal_protest_type,
    received_date, tracking_status, resolved_date, final_result_code, note,
    appeal_protest_type_catalog_id, tracking_status_id, final_result_id, final_result_code_id
)
SELECT
    b.case_id, b.decision_id, b.court_id, cf.case_type, b.appeal_protest_type::appeal_protest_type_enum,
    b.received_date, b.tracking_status, b.resolved_date, b.final_result_code, b.note,
    b.appeal_protest_type_catalog_id, b.tracking_status_id, b.final_result_id, b.final_result_code_id
FROM base b
JOIN case_files cf ON cf.case_id = b.case_id
WHERE NOT EXISTS (
    SELECT 1 FROM appellate_trackings t
    WHERE t.original_case_id = b.case_id
      AND t.original_decision_id = b.decision_id
      AND t.appeal_protest_type = b.appeal_protest_type::appeal_protest_type_enum
);

WITH src(case_code, appeal_protest_type, result_number, result_date, result_code, summary) AS (
    VALUES
{values_block(result_rows) if result_rows else "        (NULL, NULL, NULL, NULL, NULL, NULL)"}
)
INSERT INTO appellate_results (appellate_tracking_id, result_number, result_date, result_code, summary, effective_date, requires_retrial, result_code_id)
SELECT t.appellate_tracking_id, src.result_number, src.result_date, src.result_code, src.summary, src.result_date,
       (src.result_code IN ('cancelled', 'cancelled_and_remanded')), item.item_id
FROM src
JOIN case_files cf ON cf.case_code = src.case_code
JOIN decisions d ON d.case_id = cf.case_id
JOIN appellate_trackings t ON t.original_case_id = cf.case_id AND t.original_decision_id = d.decision_id AND t.appeal_protest_type = src.appeal_protest_type::appeal_protest_type_enum
LEFT JOIN dm_categories result_cat ON result_cat.category_code = 'appellate_result'
LEFT JOIN dm_category_items item ON item.category_id = result_cat.category_id
    AND item.item_code = CASE
        WHEN src.result_code = 'upheld' THEN 'uphold'
        WHEN src.result_code = 'other_review_required' THEN 'other'
        ELSE src.result_code
    END
WHERE src.case_code IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM appellate_results old
      WHERE old.appellate_tracking_id = t.appellate_tracking_id
        AND old.result_date = src.result_date
        AND old.result_code = src.result_code
  );

COMMIT;
"""
    OUT_EVENTS.write_text(sql, encoding="utf-8")


def hearing_member_rows(records: list[SourceRow]) -> tuple[list[tuple], list[tuple], list[dict], Counter]:
    staff: dict[tuple[str, str], tuple[str, str, str]] = {}
    members: list[tuple] = []
    warnings: list[dict] = []
    stats: Counter = Counter()

    def add_staff(name: str, role_code: str) -> None:
        normalized = normalize_staff_name(name)
        if not normalized:
            return
        staff_type = "judge" if role_code in ("PRESIDING_JUDGE", "PANEL_JUDGE") else "clerk"
        staff.setdefault((normalized, staff_type), (name, normalized, staff_type))

    for r in records:
        presiding = split_staff_names(r.chair_judge)
        panel = split_staff_names(r.panel_members)
        clerks = split_staff_names(r.clerk)

        if len(presiding) == 0:
            warnings.append({"file": r.file_name, "sheet": r.sheet_name, "row": r.excel_row, "issue": "Thiếu thẩm phán chủ tọa"})
        elif len(presiding) > 1:
            warnings.append({"file": r.file_name, "sheet": r.sheet_name, "row": r.excel_row, "issue": f"Có {len(presiding)} thẩm phán chủ tọa, yêu cầu đúng 1"})
        if len(clerks) == 0:
            warnings.append({"file": r.file_name, "sheet": r.sheet_name, "row": r.excel_row, "issue": "Thiếu thư ký phiên tòa"})
        if r.trial_level == "phuc_tham" and len(panel) != 2:
            warnings.append({"file": r.file_name, "sheet": r.sheet_name, "row": r.excel_row, "issue": f"Phúc thẩm có {len(panel)} PANEL_JUDGE, yêu cầu đúng 2"})
        if r.trial_level == "so_tham" and len(panel) > 1:
            warnings.append({"file": r.file_name, "sheet": r.sheet_name, "row": r.excel_row, "issue": f"Sơ thẩm có {len(panel)} PANEL_JUDGE, yêu cầu 0 hoặc 1"})

        stats[f"{r.file_name}|{r.sheet_name}|rows"] += 1
        stats[f"{r.file_name}|{r.sheet_name}|presiding_present"] += int(len(presiding) > 0)
        stats[f"{r.file_name}|{r.sheet_name}|presiding_missing"] += int(len(presiding) == 0)
        stats[f"{r.file_name}|{r.sheet_name}|panel_present"] += int(len(panel) > 0)
        stats[f"{r.file_name}|{r.sheet_name}|panel_missing"] += int(len(panel) == 0)
        stats[f"{r.file_name}|{r.sheet_name}|panel_invalid_appeal"] += int(r.trial_level == "phuc_tham" and len(panel) != 2)
        stats[f"{r.file_name}|{r.sheet_name}|clerk_present"] += int(len(clerks) > 0)
        stats[f"{r.file_name}|{r.sheet_name}|clerk_missing"] += int(len(clerks) == 0)

        member_order = 1
        for name in presiding[:1]:
            add_staff(name, "PRESIDING_JUDGE")
            members.append((sql_string(r.case_code), sql_string(normalize_staff_name(name)), sql_string("judge"), sql_string("PRESIDING_JUDGE"), str(member_order), sql_string(r.file_name), sql_string(r.sheet_name), str(r.excel_row)))
            member_order += 1
        for name in panel:
            add_staff(name, "PANEL_JUDGE")
            members.append((sql_string(r.case_code), sql_string(normalize_staff_name(name)), sql_string("judge"), sql_string("PANEL_JUDGE"), str(member_order), sql_string(r.file_name), sql_string(r.sheet_name), str(r.excel_row)))
            member_order += 1
        for name in clerks:
            add_staff(name, "HEARING_CLERK")
            members.append((sql_string(r.case_code), sql_string(normalize_staff_name(name)), sql_string("clerk"), sql_string("HEARING_CLERK"), str(member_order), sql_string(r.file_name), sql_string(r.sheet_name), str(r.excel_row)))
            member_order += 1

    staff_rows = [
        (sql_string(name), sql_string(normalized), sql_string(staff_type), sql_string("Thẩm phán" if staff_type == "judge" else "Thư ký"))
        for name, normalized, staff_type in sorted(staff.values(), key=lambda item: (item[2], item[1]))
    ]
    return staff_rows, members, warnings, stats


def write_hearing_member_seed(records: list[SourceRow]) -> tuple[list[dict], Counter, int, int]:
    staff_rows, member_rows, warnings, stats = hearing_member_rows(records)
    sql = f"""-- Seed 034: Excel-derived court staff and hearing members.
-- Generated by database/seed/generate_excel_case_full_import.py.
-- Does not create placeholder staff for blank Excel cells.

BEGIN;

WITH src(full_name, normalized_name, staff_type, position_title) AS (
    VALUES
{values_block(staff_rows) if staff_rows else "        (NULL, NULL, NULL, NULL)"}
)
INSERT INTO court_staff (court_id, full_name, normalized_name, staff_type, position_title)
SELECT c.court_id, src.full_name, src.normalized_name, src.staff_type, src.position_title
FROM src
CROSS JOIN courts c
WHERE c.court_code = 'EXCEL_SEED_TAND_QNG'
  AND src.normalized_name IS NOT NULL
ON CONFLICT (court_id, normalized_name) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    staff_type = EXCLUDED.staff_type,
    position_title = EXCLUDED.position_title,
    is_active = TRUE,
    updated_at = CURRENT_TIMESTAMP;

WITH src(case_code, normalized_name, staff_type, role_code, member_order, source_file, source_sheet, source_row) AS (
    VALUES
{values_block(member_rows) if member_rows else "        (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)"}
),
resolved AS (
    SELECT
        cf.case_id,
        staff.staff_id,
        src.role_code,
        role_item.item_id AS role_id,
        src.member_order::integer AS member_order,
        src.source_file,
        src.source_sheet,
        src.source_row::integer AS source_row
    FROM src
    JOIN case_files cf ON cf.case_code = src.case_code
    JOIN courts c ON c.court_id = cf.court_id
    JOIN court_staff staff ON staff.court_id = c.court_id
        AND staff.normalized_name = src.normalized_name
    LEFT JOIN dm_categories role_cat ON role_cat.category_code = 'hearing_member_role'
    LEFT JOIN dm_category_items role_item ON role_item.category_id = role_cat.category_id
        AND role_item.item_code = src.role_code
    WHERE src.case_code IS NOT NULL
)
INSERT INTO case_hearing_members (
    case_id, staff_id, role_code, role_id, member_order,
    source_file, source_sheet, source_row
)
SELECT
    case_id, staff_id, role_code, role_id, member_order,
    source_file, source_sheet, source_row
FROM resolved
ON CONFLICT (case_id, staff_id, role_code) DO UPDATE SET
    role_id = EXCLUDED.role_id,
    member_order = EXCLUDED.member_order,
    source_file = EXCLUDED.source_file,
    source_sheet = EXCLUDED.source_sheet,
    source_row = EXCLUDED.source_row,
    updated_at = CURRENT_TIMESTAMP;

COMMIT;
"""
    OUT_HEARING_MEMBERS.write_text(sql, encoding="utf-8")
    return warnings, stats, len(staff_rows), len(member_rows)


def write_csv(records: list[SourceRow]) -> None:
    CSV_PATH.parent.mkdir(parents=True, exist_ok=True)
    with CSV_PATH.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["case_code", "file", "sheet", "row", "trial_level", "case_type", "acceptance_date", "decision_date", "appeal_text", "result_text"])
        for r in records:
            writer.writerow([r.case_code, r.file_name, r.sheet_name, r.excel_row, r.trial_level, r.case_type, r.acceptance_date.isoformat(), r.decision_date.isoformat() if r.decision_date else "", r.appeal_text or "", r.result_text or ""])


def write_report(records: list[SourceRow], skipped: list[dict], workbook_report: list[dict]) -> None:
    counts_by_type = Counter(r.case_type for r in records)
    counts_by_level = Counter(r.case_group for r in records)
    detail_counts = {
        "civil_case_details": sum(1 for r in records if r.case_type not in ("criminal", "administrative")),
        "administrative_case_details": sum(1 for r in records if r.case_type == "administrative"),
        "criminal_case_details": sum(1 for r in records if r.case_type == "criminal"),
        "participants": sum(len(split_people(r.plaintiff)) + len(split_people(r.defendant)) + len(split_people(r.defendants)) + (1 if r.appeal_text and appeal_type(r.appeal_text) else 0) for r in records),
        "decisions": sum(1 for r in records if r.decision_number or r.decision_date or r.result_text),
        "appeals": sum(1 for r in records if appeal_type(r.appeal_text)),
        "appellate_trackings": sum(1 for r in records if r.trial_level == "phuc_tham" and appeal_type(r.appeal_text) and (r.decision_number or r.decision_date or r.result_text)),
    }
    lines = [
        "# EXCEL_CASE_FULL_IMPORT_MAPPING_RESULT",
        "",
        "## 1. Tổng quan",
        "",
        "- Mục tiêu: import dữ liệu danh sách án giả từ Excel vào `case_files` và các bảng detail/liên quan để test thống kê.",
        f"- Danh sách file Excel: {', '.join(sorted({r.file_name for r in records}))}.",
        f"- Tổng số dòng dữ liệu đọc được: {sum(item['total_rows'] for item in workbook_report)}.",
        f"- Tổng số hồ sơ vụ án import: {len(records)}.",
        f"- Tổng số dòng detail import dự kiến: {detail_counts['civil_case_details'] + detail_counts['administrative_case_details'] + detail_counts['criminal_case_details']}.",
        "- Tổng số dòng danh mục bổ sung: 0 trong task này; seed 020-025 hiện có tiếp tục giữ vai trò danh mục/alias.",
        "",
        "## 2. Phân tích từng Excel",
        "",
        "| File | Sheet | Cấp xét xử | Cột | Dòng dữ liệu | Dòng hợp lệ | Dòng bỏ qua |",
        "| --- | --- | --- | --- | ---: | ---: | ---: |",
    ]
    for item in workbook_report:
        level = "Phúc thẩm" if "Phúc thẩm" in item["file"] else "Sơ thẩm"
        lines.append(f"| {item['file']} | {item['sheet']} | {level} | {', '.join(item['columns'])} | {item['total_rows']} | {item['valid_rows']} | {item['skipped_rows']} |")
    lines += [
        "",
        "## 3. Mapping Excel",
        "",
        "| Cột/nguồn Excel | Ý nghĩa | Bảng đích | Cột đích | Quy tắc chuyển đổi | Bắt buộc |",
        "| --- | --- | --- | --- | --- | --- |",
        "| Số/ngày thụ lý, Số/Ngày TL | Số và ngày thụ lý | case_files | case_number, acceptance_date, filing_date | tách ngày dd/MM/yyyy; số thụ lý giữ trong summary/case_number kỹ thuật | Có |",
        "| Loại án/tên file | Loại án, nhóm án, luật tố tụng | case_files | case_type, case_group, procedure_law và *_id | map Hình sự/Hành chính/Dân sự/HNGĐ/KDTM/Lao động theo alias Excel | Có |",
        "| Nguyên đơn/NKK, Bị đơn/NBK, Họ và tên bị cáo | Người tham gia tố tụng | participants, defendants | participant_type, full_name, organization_name | tách theo dòng, dấu chấm phẩy và ký tự phân cách rõ ràng | Không |",
        "| Quan hệ pháp luật, Vụ việc | Quan hệ tranh chấp | civil_case_details, administrative_case_details, case_legal_relationships | dispute_type, lawsuit_type, relationship_id | dùng text nguồn; FK legal_relationship chỉ gắn khi danh mục 022 đã có tên tương ứng | Không |",
        "| Tội danh | Tội danh bị truy tố/xét xử | charges, dm_crimes | crime_name, crime_id | tách song song theo bị cáo khi dữ liệu đủ rõ | Không |",
        "| Số/Ngày BA/QĐ, Số BA/QĐ PT/ST | Bản án/quyết định | decisions | decision_number, decision_date | tách số và ngày; serial Excel được đổi sang DATE | Không |",
        "| Kết quả XXST/XXPT | Kết quả giải quyết | decisions, appellate_results | result_summary, result_code | phân loại cơ bản: giữ nguyên/sửa/hủy/đình chỉ/khác | Không |",
        "| KC/KN, Kháng cáo/Kháng nghị | Kháng cáo/kháng nghị | appeals, appellate_trackings | appeal_type, appeal_scope | phát hiện k/c, k/n, VKS; không tự tạo người kháng cáo nếu không tách chắc chắn | Không |",
        "| Hình thức xét xử, Ngày xử | Phiên tòa/phiên họp | hearings | hearing_type, scheduled_date, note | tạo hearing khi có ngày xử hoặc hình thức xét xử | Không |",
        "",
        "## 4. Mapping bảng",
        "",
        "- `case_files`: một dòng Excel hợp lệ tạo một hồ sơ; khóa tự nhiên `case_code = EXCEL-...-<dòng>`.",
        "- `civil_case_details`: dùng cho dân sự, hôn nhân gia đình, kinh doanh thương mại, lao động theo thiết kế schema hiện tại.",
        "- `administrative_case_details` và `challenged_admin_objects`: dùng cho án hành chính trong file dân sự mở rộng sơ thẩm.",
        "- `criminal_case_details`, `defendants`, `charges`, `sentences`: dùng cho án hình sự.",
        "- `participants`: nhập đương sự/bị cáo khi Excel có tên; không tạo người giả.",
        "- `case_events`, `hearings`, `decisions`, `appeals`, `appellate_trackings`, `appellate_results`: tạo khi Excel có dữ liệu tương ứng.",
        "- `statistics_snapshots`: không seed trực tiếp vì có thể tính từ dữ liệu gốc case/detail.",
        "",
        "## 5. Số dòng sau seed dự kiến",
        "",
        "| Bảng | Số dòng seed từ Excel |",
        "| --- | ---: |",
        f"| case_files | {len(records)} |",
    ]
    for table, count in detail_counts.items():
        lines.append(f"| {table} | {count} |")
    lines += [
        f"| case_events | {len(records)} |",
        "",
        "## 6. Kiểm tra thống kê dự kiến",
        "",
        f"- Tổng thụ lý: {len(records)}.",
        f"- Tổng đã giải quyết: {sum(1 for r in records if r.decision_date or r.result_text)}.",
        f"- Tổng tồn: {sum(1 for r in records if not (r.decision_date or r.result_text))}.",
        f"- Sơ thẩm: {counts_by_level['SO_THAM']}.",
        f"- Phúc thẩm: {counts_by_level['PHUC_THAM']}.",
    ]
    for case_type, count in sorted(counts_by_type.items()):
        lines.append(f"- {case_type}: {count}.")
    lines += [
        "",
        "## 7. Các dòng bỏ qua",
        "",
        "| File | Sheet | Dòng | Lý do bỏ qua |",
        "| --- | --- | ---: | --- |",
    ]
    if skipped:
        for item in skipped:
            lines.append(f"| {item['file']} | {item['sheet']} | {item['row']} | {item['reason']} |")
    else:
        lines.append("| Không có | | | |")
    lines += [
        "",
        "## 8. Kết luận",
        "",
        "PASSED nếu chạy seed và test thành công: seed không chỉ có `case_files`, mà có detail, participants, events/decisions/appeals/appellate tracking. Nếu sau khi chạy database mà các bảng detail bằng 0 thì kết luận phải xem là FAILED.",
    ]
    REPORT_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_trial_member_report(
    records: list[SourceRow],
    workbook_report: list[dict],
    hearing_warnings: list[dict],
    hearing_stats: Counter,
    staff_count: int,
    hearing_member_count: int,
) -> None:
    counts_by_level = Counter(r.case_group for r in records)
    lines = [
        "# EXCEL_CASE_TRIAL_LEVEL_AND_HEARING_MEMBERS_RESULT",
        "",
        "## A. Sơ thẩm/phúc thẩm",
        "",
        "- Trường dùng để phân biệt cấp xét xử: `case_files.case_group` và `case_files.case_group_id`.",
        "- Lý do chọn: `case_type` chỉ lưu loại án; `procedure_law` chỉ lưu luật tố tụng; `current_stage` chỉ lưu giai đoạn vòng đời hồ sơ.",
        "- Không tạo cột `trial_level` mới vì schema đã có `case_group/case_group_id` và danh mục `dm_categories`.",
        "- Danh mục: `dm_categories.category_code = 'case_group'`.",
        "- Mã sơ thẩm: `SO_THAM`.",
        "- Mã phúc thẩm: `PHUC_THAM`.",
        f"- Số lượng `case_files` sơ thẩm: {counts_by_level['SO_THAM']}.",
        f"- Số lượng `case_files` phúc thẩm: {counts_by_level['PHUC_THAM']}.",
        "- Số dòng thiếu cấp xét xử: 0.",
        "",
        "## B. Thẩm phán/Hội đồng/Thư ký",
        "",
        "| File Excel | Sheet | Dòng đọc | Có chủ tọa | Thiếu chủ tọa | Có hội đồng | Thiếu hội đồng | Phúc thẩm không đủ 2 PANEL_JUDGE | Có thư ký | Thiếu thư ký |",
        "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for item in workbook_report:
        key = f"{item['file']}|{item['sheet']}"
        lines.append(
            f"| {item['file']} | {item['sheet']} | {hearing_stats[key + '|rows']} | "
            f"{hearing_stats[key + '|presiding_present']} | {hearing_stats[key + '|presiding_missing']} | "
            f"{hearing_stats[key + '|panel_present']} | {hearing_stats[key + '|panel_missing']} | "
            f"{hearing_stats[key + '|panel_invalid_appeal']} | "
            f"{hearing_stats[key + '|clerk_present']} | {hearing_stats[key + '|clerk_missing']} |"
        )
    lines += [
        "",
        f"- Số nhân sự tạo/cập nhật trong `court_staff`: {staff_count}.",
        f"- Số thành phần phiên tòa tạo/cập nhật trong `case_hearing_members`: {hearing_member_count}.",
        "",
        "### Dòng lỗi/warning",
        "",
        "| File | Sheet | Row | Warning |",
        "| --- | --- | ---: | --- |",
    ]
    if hearing_warnings:
        for item in hearing_warnings:
            lines.append(f"| {item['file']} | {item['sheet']} | {item['row']} | {item['issue']} |")
    else:
        lines.append("| Không có | | | |")
    lines += [
        "",
        "## C. Bảng dữ liệu",
        "",
        "- Bảng nhân sự dùng: `court_staff`.",
        "- Bảng thành phần phiên tòa dùng: `case_hearing_members`.",
        "- Bảng danh mục role dùng: `dm_categories/dm_category_items` với `category_code = 'hearing_member_role'`.",
        f"- Sau seed dự kiến `court_staff`: {staff_count} dòng.",
        f"- Sau seed dự kiến `case_hearing_members`: {hearing_member_count} dòng.",
        "",
        "## D. Kết luận",
        "",
        "Seed không tạo nhân sự giả cho ô trống. Các ô trống hoặc sai số lượng thành viên hội đồng được ghi warning để test/report phát hiện.",
    ]
    TRIAL_MEMBER_REPORT_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    records, skipped, workbook_report = load_records()
    write_case_seed(records)
    write_detail_seed(records)
    write_party_seed(records)
    write_event_seed(records)
    hearing_warnings, hearing_stats, staff_count, hearing_member_count = write_hearing_member_seed(records)
    write_csv(records)
    write_report(records, skipped, workbook_report)
    write_trial_member_report(records, workbook_report, hearing_warnings, hearing_stats, staff_count, hearing_member_count)
    print(json.dumps({"records": len(records), "skipped": len(skipped), "report": str(REPORT_PATH), "trial_member_report": str(TRIAL_MEMBER_REPORT_PATH)}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
