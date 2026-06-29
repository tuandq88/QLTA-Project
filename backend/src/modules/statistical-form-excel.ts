import crypto from 'node:crypto';
import fs from 'node:fs';
import ExcelJS from 'exceljs';
import { ApiError } from '../common/http.js';
import { projectPath } from './statistical-form-config.js';
import type { StatisticalReport } from './statistical-form-report.js';

function displayDate(isoDate: string) {
  const [year, month, day] = isoDate.split('-');
  return `${day}/${month}/${year}`;
}

function plainCellText(value: ExcelJS.CellValue) {
  if (value === null || value === undefined) return '';
  if (typeof value === 'object') {
    if ('richText' in value) return value.richText.map((part) => part.text).join('');
    if ('text' in value) return value.text;
    if ('result' in value && value.result !== undefined) return String(value.result);
  }
  return String(value);
}

function isSampleNumericValue(cell: ExcelJS.Cell) {
  if (cell.type === ExcelJS.ValueType.Merge || cell.value === null) return false;
  if (typeof cell.value === 'number') return true;
  return typeof cell.value === 'string' && /^-?\d+(?:[.,]\d+)?$/.test(cell.value.trim());
}

function findOverallTotalRow(sheet: ExcelJS.Worksheet, minimumRow: number) {
  let totalRow: number | null = null;
  for (let row = minimumRow; row <= sheet.rowCount; row += 1) {
    const label = plainCellText(sheet.getCell(row, 1).value).trim().toLocaleLowerCase('vi-VN');
    if (label === 'tổng cộng') totalRow = row;
  }
  if (!totalRow) throw new ApiError('INTERNAL_ERROR', `Khong tim thay dong Tong cong trong sheet ${sheet.name}`, 500);
  return totalRow;
}

export async function createStatisticalFormExcel(report: StatisticalReport) {
  const sourcePath = projectPath('bieu_mau', report.form.template_file);
  if (!fs.existsSync(sourcePath)) {
    throw new ApiError('INTERNAL_ERROR', `Thieu file bieu mau ${report.form.template_file}`, 500);
  }
  const sourceBuffer = fs.readFileSync(sourcePath);
  const sourceSha256 = crypto.createHash('sha256').update(sourceBuffer).digest('hex');
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.readFile(sourcePath);
  const sheet = workbook.getWorksheet(report.form.sheet);
  if (!sheet) throw new ApiError('INTERNAL_ERROR', `Thieu sheet ${report.form.sheet}`, 500);

  const totalRow = findOverallTotalRow(sheet, report.form.number_row + 1);
  for (let row = report.form.number_row + 1; row <= totalRow; row += 1) {
    for (let column = report.form.data_first_numeric_column; column <= report.form.workbook_column_count; column += 1) {
      const cell = sheet.getCell(row, column);
      if (isSampleNumericValue(cell)) cell.value = null;
    }
  }

  sheet.getCell(report.form.period_cell).value = `Từ ${displayDate(report.query.from_date)} đến ngày ${displayDate(report.query.to_date)}`;
  for (const cell of Object.values(report.cells)) {
    if (cell.column > report.form.guide_column_count) continue;
    if (cell.value === null || (cell.status !== 'source' && cell.status !== 'formula')) continue;
    sheet.getCell(totalRow, cell.column).value = cell.value;
  }

  workbook.creator = 'QLTA-Project';
  workbook.modified = new Date();
  workbook.calcProperties.fullCalcOnLoad = true;

  return {
    buffer: Buffer.from(await workbook.xlsx.writeBuffer()),
    sourceSha256,
    totalRow,
    sheetName: sheet.name
  };
}
