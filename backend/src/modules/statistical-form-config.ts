import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { z } from 'zod';
import { ApiError } from '../common/http.js';

const formulaSchema = z.object({
  target: z.number().int().positive(),
  expression: z.string().min(1),
  dependencies: z.array(z.number().int().positive()).min(1),
  formula_ref: z.string().min(1)
});

const sourceProfileSchema = z.enum([
  'criminal_first_instance',
  'criminal_appellate',
  'civil_first_instance',
  'marriage_first_instance',
  'generic_first_instance',
  'administrative_first_instance',
  'generic_appellate'
]);

const rawFormSchema = z.object({
  form_code: z.string().min(1),
  template_code: z.string().min(1),
  case_type: z.enum(['criminal', 'civil', 'marriage_family', 'business_commercial', 'labor', 'administrative']),
  trial_level: z.enum(['SO_THAM', 'PHUC_THAM']),
  template_file: z.string().min(1),
  sheet: z.string().min(1),
  period_cell: z.string().min(1),
  number_row: z.number().int().positive(),
  guide_column_count: z.number().int().positive(),
  workbook_column_count: z.number().int().positive(),
  data_first_numeric_column: z.number().int().positive(),
  deferred_columns: z.array(z.number().int().positive()),
  source_profile: sourceProfileSchema,
  formulas: z.union([z.array(formulaSchema), z.string().min(1)])
});

const mappingSchema = z.object({
  version: z.string().min(1),
  legal_basis: z.string().min(1),
  scope: z.string().min(1),
  forms: z.array(rawFormSchema).length(12),
  source_profiles: z.record(z.array(z.object({
    cells: z.array(z.number().int().positive()).min(1),
    metric: z.string().min(1),
    source_tables: z.array(z.string().min(1)).min(1),
    grain: z.string().min(1)
  }))),
  formula_sets: z.record(z.array(formulaSchema))
});

export type StatisticalFormulaDefinition = z.infer<typeof formulaSchema>;
export type StatisticalSourceProfile = z.infer<typeof sourceProfileSchema>;
export type StatisticalFormDefinition = Omit<z.infer<typeof rawFormSchema>, 'formulas'> & {
  formulas: StatisticalFormulaDefinition[];
  mapping_version: string;
  legal_basis: string;
};

function repositoryRoot() {
  const moduleDirectory = path.dirname(fileURLToPath(import.meta.url));
  const candidates = [
    path.resolve(moduleDirectory, '../../..'),
    process.cwd(),
    path.resolve(process.cwd(), '..')
  ];
  const root = candidates.find((candidate) => fs.existsSync(path.join(candidate, 'knowledge_base')));
  if (!root) {
    throw new ApiError('INTERNAL_ERROR', 'Khong tim thay thu muc goc QLTA-Project', 500);
  }
  return root;
}

export function projectPath(...segments: string[]) {
  return path.join(repositoryRoot(), ...segments);
}

function loadMapping() {
  const mappingPath = projectPath('knowledge_base', 'data', 'statistics', 'report_mapping_ab.json');
  const parsed = mappingSchema.parse(JSON.parse(fs.readFileSync(mappingPath, 'utf8')));
  const forms = parsed.forms.map((form): StatisticalFormDefinition => ({
    ...form,
    formulas: typeof form.formulas === 'string'
      ? parsed.formula_sets[form.formulas] ?? (() => { throw new Error(`Unknown formula set ${form.formulas}`); })()
      : form.formulas,
    mapping_version: parsed.version,
    legal_basis: parsed.legal_basis
  }));
  return { ...parsed, forms };
}

const mapping = loadMapping();

export function listStatisticalForms() {
  return mapping.forms;
}

export function getStatisticalForm(formCode: string) {
  const normalized = formCode.toUpperCase();
  const form = mapping.forms.find((item) => item.form_code === normalized || item.template_code === normalized);
  if (!form) throw new ApiError('NOT_FOUND', `Khong tim thay bieu mau ${formCode}`, 404);
  return form;
}

export function statisticalMappingMetadata() {
  return { version: mapping.version, legalBasis: mapping.legal_basis, scope: mapping.scope };
}
