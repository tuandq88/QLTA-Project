export type WorkbookBorder = {
  width: string;
  style: string;
  color: string;
};

export type WorkbookCellStyle = {
  background?: string;
  color?: string;
  fontFamily?: string;
  fontSize?: number;
  fontWeight?: number;
  fontStyle?: string;
  textDecoration?: string;
  horizontal?: string;
  vertical?: string;
  wrapText?: boolean;
  rotation?: number;
  borderTop?: WorkbookBorder;
  borderRight?: WorkbookBorder;
  borderBottom?: WorkbookBorder;
  borderLeft?: WorkbookBorder;
};

export type WorkbookCell = {
  v?: string | number;
  rs?: number;
  cs?: number;
  s: number;
};

export type StatisticsWorkbook = {
  id: string;
  title: string;
  caseType: string;
  stage: "so-tham" | "phuc-tham" | "giam-doc-tham" | "tai-tham";
  stageLabel: string;
  fileName: string;
  sheetName: string;
  formCode?: string | null;
  numberRow: number;
  totalRow: number;
  maxRow: number;
  maxColumn: number;
  columns: Array<[number, boolean]>;
  rows: Array<[number, boolean]>;
  styles: WorkbookCellStyle[];
  cells: Record<string, WorkbookCell>;
};

export type StatisticalCellStatus = "source" | "formula" | "unmapped" | "deferred";

export type StatisticalReportCell = {
  column: number;
  code: string;
  value: number | null;
  status: StatisticalCellStatus;
  sourceTables: string[];
  sourceRecordIds: string[];
  sourceGrain?: string;
  formulaRef?: string;
  formula?: string;
  reason?: string;
};

export type StatisticalReport = {
  form: {
    form_code: string;
    template_code: string;
    legal_basis: string;
  };
  query: {
    from_date: string;
    to_date: string;
    court_id?: string;
  };
  cells: Record<string, StatisticalReportCell>;
  status: "complete" | "incomplete" | "invalid";
  validations: Array<{
    code: string;
    severity: "WARNING" | "ERROR";
    message: string;
    columns?: string[];
  }>;
  unmappedCells: string[];
  generatedAt: string;
};

export type StatisticalReportQuery = {
  from_date: string;
  to_date: string;
  court_id?: string;
};
