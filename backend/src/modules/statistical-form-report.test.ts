import crypto from 'node:crypto';
import fs from 'node:fs';
import ExcelJS from 'exceljs';
import { describe, expect, it } from 'vitest';
import {
  getStatisticalForm,
  listStatisticalForms,
  projectPath
} from './statistical-form-config.js';
import { createStatisticalFormExcel } from './statistical-form-excel.js';
import {
  calculateMappedCells,
  type SourceCellMap,
  type StatisticalReport
} from './statistical-form-report.js';

function source(value: number, ids = ['00000000-0000-0000-0000-000000000001']) {
  return { value, sourceTables: ['case_files'], sourceRecordIds: ids, sourceGrain: 'case_id' };
}

function fakeReport(formCode: string): StatisticalReport {
  const form = getStatisticalForm(formCode);
  const targetColumn = form.data_first_numeric_column;
  const cells = calculateMappedCells(form, { [`C${targetColumn}`]: source(7) });
  return {
    form,
    query: { from_date: '2026-05-01', to_date: '2026-05-31' },
    cells,
    status: 'incomplete',
    validations: [],
    unmappedCells: [],
    generatedAt: '2026-06-29T00:00:00.000Z'
  };
}

function findTotalRow(sheet: ExcelJS.Worksheet, start: number) {
  let found = 0;
  for (let row = start; row <= sheet.rowCount; row += 1) {
    if (String(sheet.getCell(row, 1).value ?? '').trim().toLocaleLowerCase('vi-VN') === 'tổng cộng') found = row;
  }
  return found;
}

describe('statistical A/B mapping', () => {
  it('registers exactly six first-instance and six appellate forms', () => {
    const forms = listStatisticalForms();
    expect(forms).toHaveLength(12);
    expect(forms.filter((form) => form.trial_level === 'SO_THAM')).toHaveLength(6);
    expect(forms.filter((form) => form.trial_level === 'PHUC_THAM')).toHaveLength(6);
    for (const form of forms) {
      expect(form.template_code.endsWith('A')).toBe(form.trial_level === 'SO_THAM');
      expect(form.template_code.endsWith('B')).toBe(form.trial_level === 'PHUC_THAM');
    }
  });

  it('calculates a formula only when every dependency is traceable', () => {
    const form = getStatisticalForm('KDTM_ST_4A');
    const completeSources: SourceCellMap = {
      C2: source(2), C3: source(5), C4: source(1), C5: source(0),
      C7: source(1), C8: source(1), C9: source(1), C10: source(1), C11: source(1)
    };
    const complete = calculateMappedCells(form, completeSources);
    expect(complete.C6.value).toBe(6);
    expect(complete.C12.value).toBe(3);
    expect(complete.C13.value).toBe(5);
    expect(complete.C14.value).toBe(1);
    expect(complete.C6.status).toBe('formula');

    const incomplete = calculateMappedCells(form, { C2: source(2), C3: source(5) });
    expect(incomplete.C6.value).toBeNull();
    expect(incomplete.C6.status).toBe('unmapped');
  });

  it('marks columns beyond Decision 287 scope as deferred', () => {
    expect(calculateMappedCells(getStatisticalForm('HS_ST_1A'), {}).C92.status).toBe('deferred');
    expect(calculateMappedCells(getStatisticalForm('HNGD_ST_3A'), {}).C37.status).toBe('deferred');
    expect(calculateMappedCells(getStatisticalForm('KDTM_ST_4A'), {}).C33.status).toBe('deferred');
    expect(calculateMappedCells(getStatisticalForm('LD_ST_5A'), {}).C36.status).toBe('deferred');
  });
});

describe('statistical Excel templates', () => {
  for (const form of listStatisticalForms()) {
    it(`exports ${form.template_code} from its exact source template without modifying source`, async () => {
      const sourcePath = projectPath('bieu_mau', form.template_file);
      const before = crypto.createHash('sha256').update(fs.readFileSync(sourcePath)).digest('hex');
      const exported = await createStatisticalFormExcel(fakeReport(form.form_code));
      const after = crypto.createHash('sha256').update(fs.readFileSync(sourcePath)).digest('hex');
      expect(after).toBe(before);
      expect(exported.sourceSha256).toBe(before);

      const workbook = new ExcelJS.Workbook();
      await workbook.xlsx.load(exported.buffer as unknown as ArrayBuffer);
      const sheet = workbook.getWorksheet(form.sheet);
      expect(sheet).toBeDefined();
      expect(sheet!.getCell(form.period_cell).value).toBe('Từ 01/05/2026 đến ngày 31/05/2026');
      const totalRow = findTotalRow(sheet!, form.number_row + 1);
      expect(totalRow).toBeGreaterThan(form.number_row);
      expect(sheet!.getCell(totalRow, form.data_first_numeric_column).value).toBe(7);
      for (const column of form.deferred_columns) {
        expect(sheet!.getCell(totalRow, column).value).toBeNull();
      }
    });
  }
});
