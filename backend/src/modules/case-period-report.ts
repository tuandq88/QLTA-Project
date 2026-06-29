import fs from 'node:fs';
import ExcelJS from 'exceljs';
import PDFDocument from 'pdfkit';
import { pool } from '../database/pool.js';
import {
  buildCasePeriodCte,
  categoryCondition,
  type CasePeriodCategory,
  type ReportPeriodQuery
} from '../common/report-period.js';

export type CasePeriodReportRow = {
  case_id: string;
  case_code: string | null;
  case_number: string | null;
  case_type: string;
  case_group: string | null;
  acceptance_date: string | Date;
  closed_date: string | Date | null;
  report_resolution_date: string | Date | null;
  report_resolution_status: string | null;
  report_note: string | null;
  is_resolved_after_period: boolean;
  court_name: string;
  judge_name: string;
};

export const categoryLabels: Record<CasePeriodCategory, string> = {
  accepted_in_period: 'Vụ án thụ lý trong kỳ',
  opening_pending: 'Thụ lý trước kỳ, chưa giải quyết đến cuối kỳ',
  resolved_in_period: 'Vụ án có kết quả giải quyết trong kỳ'
};

const categories = Object.keys(categoryLabels) as CasePeriodCategory[];

export async function getCasePeriodRows(query: ReportPeriodQuery, category: CasePeriodCategory) {
  const period = buildCasePeriodCte(query);
  const result = await pool.query<CasePeriodReportRow>(
    `${period.sql}
     select case_id, case_code, case_number, case_type, case_group,
            acceptance_date, closed_date, report_resolution_date,
            report_resolution_status, report_note, is_resolved_after_period,
            court_name, judge_name
     from period_cases
     where ${categoryCondition(category)}
     order by acceptance_date, case_number nulls last, case_code nulls last`,
    period.values
  );
  return result.rows;
}

export async function getAllCasePeriodRows(query: ReportPeriodQuery) {
  const entries = await Promise.all(categories.map(async (category) => [category, await getCasePeriodRows(query, category)] as const));
  return Object.fromEntries(entries) as Record<CasePeriodCategory, CasePeriodReportRow[]>;
}

function displayDate(value: string | Date | null) {
  if (!value) return '';
  const iso = value instanceof Date
    ? `${value.getFullYear()}-${String(value.getMonth() + 1).padStart(2, '0')}-${String(value.getDate()).padStart(2, '0')}`
    : String(value).slice(0, 10);
  const [year, month, day] = iso.split('-');
  return `${day}/${month}/${year}`;
}

function reportValues(row: CasePeriodReportRow) {
  return [
    row.case_number ?? row.case_code ?? '',
    row.case_type,
    row.court_name,
    row.judge_name,
    displayDate(row.acceptance_date),
    displayDate(row.report_resolution_date),
    row.report_resolution_status ?? '',
    row.report_note ?? ''
  ];
}

export async function createCasePeriodExcel(query: ReportPeriodQuery) {
  const data = await getAllCasePeriodRows(query);
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'QLTA-Project';
  workbook.created = new Date();

  for (const category of categories) {
    const sheet = workbook.addWorksheet(categoryLabels[category].slice(0, 31));
    sheet.addRow([categoryLabels[category]]);
    sheet.addRow([`Kỳ báo cáo: ${displayDate(query.from_date)} - ${displayDate(query.to_date)} (bao gồm hai ngày)`]);
    sheet.addRow([]);
    sheet.addRow(['Số hồ sơ', 'Loại án', 'Đơn vị', 'Thẩm phán', 'Ngày thụ lý', 'Ngày giải quyết trong kỳ', 'Kết quả trong kỳ', 'Ghi chú']);
    for (const row of data[category]) sheet.addRow(reportValues(row));

    sheet.eachRow((row) => {
      row.eachCell((cell) => {
        cell.font = { name: 'Tahoma', size: 10 };
        cell.alignment = { vertical: 'top', wrapText: true };
      });
    });
    sheet.getRow(1).font = { name: 'Tahoma', size: 14, bold: true };
    sheet.getRow(4).font = { name: 'Tahoma', size: 10, bold: true, color: { argb: 'FFFFFFFF' } };
    sheet.getRow(4).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF1F4E78' } };
    sheet.views = [{ state: 'frozen', ySplit: 4 }];
    sheet.autoFilter = { from: 'A4', to: 'H4' };
    [16, 18, 28, 22, 14, 18, 24, 38].forEach((width, index) => {
      sheet.getColumn(index + 1).width = width;
    });
    data[category].forEach((row, index) => {
      if (row.is_resolved_after_period) {
        sheet.getRow(index + 5).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFF2CC' } };
      }
    });
  }

  return Buffer.from(await workbook.xlsx.writeBuffer());
}

export async function createCasePeriodPdf(query: ReportPeriodQuery) {
  const data = await getAllCasePeriodRows(query);
  const document = new PDFDocument({ size: 'A4', layout: 'landscape', margin: 28, bufferPages: true });
  const chunks: Buffer[] = [];
  document.on('data', (chunk: Buffer) => chunks.push(chunk));

  const tahomaRegular = 'C:/Windows/Fonts/tahoma.ttf';
  const tahomaBold = 'C:/Windows/Fonts/tahomabd.ttf';
  if (fs.existsSync(tahomaRegular)) document.registerFont('Tahoma', tahomaRegular);
  if (fs.existsSync(tahomaBold)) document.registerFont('Tahoma Bold', tahomaBold);
  const regularFont = fs.existsSync(tahomaRegular) ? 'Tahoma' : 'Helvetica';
  const boldFont = fs.existsSync(tahomaBold) ? 'Tahoma Bold' : 'Helvetica-Bold';
  const widths = [80, 70, 130, 100, 65, 70, 100, 167];
  const headers = ['Số hồ sơ', 'Loại án', 'Đơn vị', 'Thẩm phán', 'Thụ lý', 'Giải quyết', 'Kết quả', 'Ghi chú'];

  function drawHeader(title: string) {
    document.font(boldFont).fontSize(14).fillColor('#172033').text(title, { align: 'center' });
    document.moveDown(0.25);
    document.font(regularFont).fontSize(9).text(
      `Kỳ báo cáo: ${displayDate(query.from_date)} - ${displayDate(query.to_date)} (bao gồm ngày đầu và ngày cuối)`,
      { align: 'center' }
    );
    document.moveDown(0.6);
  }

  function drawTableHeader() {
    let x = document.page.margins.left;
    const y = document.y;
    document.save().rect(x, y, widths.reduce((sum, width) => sum + width, 0), 24).fill('#1F4E78').restore();
    headers.forEach((header, index) => {
      document.font(boldFont).fontSize(7.5).fillColor('#FFFFFF').text(header, x + 3, y + 6, { width: widths[index] - 6, height: 16 });
      x += widths[index];
    });
    document.y = y + 24;
  }

  function ensureSpace(height: number, title: string) {
    if (document.y + height <= document.page.height - document.page.margins.bottom) return;
    document.addPage();
    drawHeader(`${title} (tiếp)`);
    drawTableHeader();
  }

  categories.forEach((category, categoryIndex) => {
    if (categoryIndex > 0) document.addPage();
    const title = categoryLabels[category];
    drawHeader(title);
    drawTableHeader();

    if (data[category].length === 0) {
      document.font(regularFont).fontSize(9).fillColor('#475569').text('Không có hồ sơ phù hợp trong kỳ.', { align: 'center' });
      return;
    }

    data[category].forEach((row, rowIndex) => {
      const values = reportValues(row);
      const rowHeight = Math.max(22, ...values.map((value, index) => document.heightOfString(String(value), { width: widths[index] - 6 }) + 8));
      ensureSpace(rowHeight, title);
      const y = document.y;
      let x = document.page.margins.left;
      const fill = row.is_resolved_after_period ? '#FFF2CC' : rowIndex % 2 === 0 ? '#F8FAFC' : '#FFFFFF';
      document.save().rect(x, y, widths.reduce((sum, width) => sum + width, 0), rowHeight).fill(fill).restore();
      values.forEach((value, index) => {
        document.font(regularFont).fontSize(7.2).fillColor('#172033').text(String(value), x + 3, y + 4, {
          width: widths[index] - 6,
          height: rowHeight - 7
        });
        x += widths[index];
      });
      document.y = y + rowHeight;
    });
  });

  const pageRange = document.bufferedPageRange();
  for (let pageIndex = 0; pageIndex < pageRange.count; pageIndex += 1) {
    document.switchToPage(pageIndex);
    document.font(regularFont).fontSize(7).fillColor('#64748B').text(
      `Trang ${pageIndex + 1}/${pageRange.count}`,
      document.page.margins.left,
      document.page.height - document.page.margins.bottom - 10,
      { width: document.page.width - document.page.margins.left - document.page.margins.right, align: 'right' }
    );
  }

  document.end();
  await new Promise<void>((resolve, reject) => {
    document.on('end', resolve);
    document.on('error', reject);
  });
  return Buffer.concat(chunks);
}
