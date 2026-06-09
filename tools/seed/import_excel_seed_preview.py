#!/usr/bin/env python3
"""Read QLTA .xlsx seed workbooks without modifying the source files.

The script intentionally uses only Python standard-library modules so it can run
in environments that do not have openpyxl installed. It supports .xlsx files.
For legacy .xls files, install xlrd and extend this script or convert them to
.xlsx before import.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import unicodedata
from collections import Counter
from pathlib import Path
from xml.etree import ElementTree as ET
from zipfile import ZipFile

XLSX_NS = {
    "a": "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
    "r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
}
PKG_NS = {"rel": "http://schemas.openxmlformats.org/package/2006/relationships"}


def clean_text(value: object) -> str:
    return re.sub(r"\s+", " ", str(value or "").strip(" -;\n\r\t")).strip()


def normalize_header(value: object) -> str:
    text = clean_text(value).lower()
    text = unicodedata.normalize("NFC", text)
    return text


def slugify(value: str, prefix: str = "excel") -> str:
    text = unicodedata.normalize("NFD", value)
    text = "".join(ch for ch in text if unicodedata.category(ch) != "Mn")
    text = text.replace("đ", "d").replace("Đ", "D")
    text = re.sub(r"[^A-Za-z0-9]+", "_", text).strip("_").lower()
    return f"{prefix}_{text}"[:140] if text else f"{prefix}_requires_review"


def column_index(cell_ref: str) -> int:
    match = re.match(r"([A-Z]+)", cell_ref)
    if not match:
        return 0
    number = 0
    for char in match.group(1):
        number = number * 26 + ord(char) - 64
    return number


def read_xlsx(path: Path) -> list[dict[str, object]]:
    with ZipFile(path) as archive:
        shared_strings: list[str] = []
        if "xl/sharedStrings.xml" in archive.namelist():
            root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
            for item in root.findall("a:si", XLSX_NS):
                shared_strings.append(
                    "".join(node.text or "" for node in item.findall(".//a:t", XLSX_NS))
                )

        workbook = ET.fromstring(archive.read("xl/workbook.xml"))
        rels = ET.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
        relmap = {
            rel.attrib["Id"]: rel.attrib["Target"]
            for rel in rels.findall("rel:Relationship", PKG_NS)
        }

        sheets: list[dict[str, object]] = []
        for sheet in workbook.findall("a:sheets/a:sheet", XLSX_NS):
            name = sheet.attrib["name"]
            rel_id = sheet.attrib[
                "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id"
            ]
            target = relmap[rel_id]
            sheet_path = "xl/" + target.lstrip("/") if not target.startswith("xl/") else target
            root = ET.fromstring(archive.read(sheet_path))
            rows: list[list[str]] = []
            for row in root.findall("a:sheetData/a:row", XLSX_NS):
                values: dict[int, str] = {}
                for cell in row.findall("a:c", XLSX_NS):
                    idx = column_index(cell.attrib.get("r", "A"))
                    cell_type = cell.attrib.get("t")
                    value_node = cell.find("a:v", XLSX_NS)
                    inline_node = cell.find("a:is", XLSX_NS)
                    value = ""
                    if cell_type == "s" and value_node is not None and value_node.text is not None:
                        value = shared_strings[int(value_node.text)]
                    elif cell_type == "inlineStr" and inline_node is not None:
                        value = "".join(
                            node.text or "" for node in inline_node.findall(".//a:t", XLSX_NS)
                        )
                    elif value_node is not None and value_node.text is not None:
                        value = value_node.text
                    values[idx] = value
                if values:
                    rows.append([values.get(i, "") for i in range(1, max(values) + 1)])
            sheets.append({"name": name, "rows": rows})
        return sheets


def split_values(value: object) -> list[str]:
    values: list[str] = []
    for part in re.split(r"[\n;]+", str(value or "")):
        cleaned = clean_text(part)
        if cleaned:
            values.append(cleaned)
    return values


def detect_header(nonempty_rows: list[list[str]]) -> tuple[int, list[str]]:
    keywords = {
        "loại án",
        "số/ngày thụ lý",
        "quan hệ pháp luật",
        "vụ việc",
        "tội danh",
        "kết quả xxpt",
        "kết quả xxst",
        "hình thức xét xử",
    }
    best_idx = 0
    best_score = -1
    for idx, row in enumerate(nonempty_rows[:10]):
        normalized = {normalize_header(cell) for cell in row}
        score = len(normalized & keywords)
        if score > best_score:
            best_idx = idx
            best_score = score
    return best_idx, nonempty_rows[best_idx]


def analyze_workbook(path: Path) -> dict[str, object]:
    result: dict[str, object] = {"file": path.name, "sheets": []}
    for sheet in read_xlsx(path):
        rows = sheet["rows"]
        nonempty = [row for row in rows if any(clean_text(cell) for cell in row)]
        if not nonempty:
            result["sheets"].append(
                {"sheet": sheet["name"], "header_row": None, "data_rows": 0, "columns": []}
            )
            continue
        header_idx, header = detect_header(nonempty)
        header_map = {normalize_header(col): i for i, col in enumerate(header)}
        data_rows = nonempty[header_idx + 1 :]
        counters: dict[str, list[tuple[str, int]]] = {}
        for label in (
            "loại án",
            "quan hệ pháp luật",
            "vụ việc",
            "tội danh",
            "kết quả xxpt",
            "kết quả xxst",
            "hình thức xét xử",
            "kc/kn",
            "kháng cáo/kháng nghị",
        ):
            if label not in header_map:
                continue
            counter: Counter[str] = Counter()
            col_idx = header_map[label]
            for row in data_rows:
                value = row[col_idx] if col_idx < len(row) else ""
                for part in split_values(value):
                    counter[part] += 1
            counters[label] = counter.most_common()

        result["sheets"].append(
            {
                "sheet": sheet["name"],
                "header_row": header_idx + 1,
                "data_rows": len(data_rows),
                "columns": [clean_text(col) for col in header],
                "counters": counters,
            }
        )
    return result


def iter_records(path: Path) -> list[dict[str, object]]:
    records: list[dict[str, object]] = []
    wanted = {
        "loại án": "case_type",
        "quan hệ pháp luật": "legal_relationship",
        "vụ việc": "case_matter",
        "tội danh": "crime_name",
        "kết quả xxpt": "appellate_result",
        "kết quả xxst": "trial_result",
        "hình thức xét xử": "hearing_format",
        "kc/kn": "appeal_protest_text",
        "kháng cáo/kháng nghị": "appeal_protest_text",
    }
    for sheet in read_xlsx(path):
        rows = sheet["rows"]
        nonempty = [row for row in rows if any(clean_text(cell) for cell in row)]
        if not nonempty:
            continue
        header_idx, header = detect_header(nonempty)
        header_map = {normalize_header(col): i for i, col in enumerate(header)}
        for offset, row in enumerate(nonempty[header_idx + 1 :], start=header_idx + 2):
            record: dict[str, object] = {
                "file": path.name,
                "sheet": sheet["name"],
                "source_row": offset,
            }
            for source_name, target_name in wanted.items():
                if source_name not in header_map:
                    continue
                col_idx = header_map[source_name]
                record[target_name] = row[col_idx] if col_idx < len(row) else ""
            records.append(record)
    return records


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-dir", default="database/seed/danh sach")
    parser.add_argument("--json-out")
    parser.add_argument("--csv-out")
    parser.add_argument("--records-out")
    args = parser.parse_args()

    input_dir = Path(args.input_dir)
    workbooks = sorted(input_dir.glob("*.xlsx"))
    analyses = [analyze_workbook(path) for path in workbooks]

    if args.json_out:
        Path(args.json_out).write_text(
            json.dumps(analyses, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )
    if args.csv_out:
        with Path(args.csv_out).open("w", encoding="utf-8-sig", newline="") as handle:
            writer = csv.writer(handle)
            writer.writerow(
                ["file", "sheet", "header_row", "data_rows", "column", "value", "count"]
            )
            for workbook in analyses:
                for sheet in workbook["sheets"]:
                    for column, values in sheet.get("counters", {}).items():
                        for value, count in values:
                            writer.writerow(
                                [
                                    workbook["file"],
                                    sheet["sheet"],
                                    sheet["header_row"],
                                    sheet["data_rows"],
                                    column,
                                    value,
                                    count,
                                ]
                            )
    if args.records_out:
        fields = [
            "file",
            "sheet",
            "source_row",
            "case_type",
            "legal_relationship",
            "case_matter",
            "crime_name",
            "appellate_result",
            "trial_result",
            "hearing_format",
            "appeal_protest_text",
        ]
        with Path(args.records_out).open("w", encoding="utf-8-sig", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=fields)
            writer.writeheader()
            for workbook in workbooks:
                for record in iter_records(workbook):
                    writer.writerow({field: record.get(field, "") for field in fields})
    if not args.json_out and not args.csv_out:
        print(json.dumps(analyses, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
