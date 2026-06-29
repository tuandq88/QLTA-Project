import { useMemo, type CSSProperties } from "react";
import type {
  StatisticalReport,
  StatisticsWorkbook,
  WorkbookBorder,
  WorkbookCellStyle
} from "../../types/statistics";

type WorkbookGridProps = {
  workbook: StatisticsWorkbook;
  report: StatisticalReport | null;
  fromDate: string;
  toDate: string;
  zoom: number;
};

function borderValue(border?: WorkbookBorder) {
  return border ? `${border.width} ${border.style} ${border.color}` : undefined;
}

function cellStyle(style: WorkbookCellStyle): CSSProperties {
  const horizontal = style.horizontal === "centerContinuous" ? "center" : style.horizontal;
  return {
    background: style.background,
    color: style.color,
    fontFamily: style.fontFamily ? `${style.fontFamily}, Tahoma, Arial, sans-serif` : undefined,
    fontSize: style.fontSize ? `${style.fontSize}pt` : undefined,
    fontWeight: style.fontWeight,
    fontStyle: style.fontStyle,
    textDecoration: style.textDecoration,
    textAlign: horizontal === "general" ? undefined : (horizontal as CSSProperties["textAlign"]),
    verticalAlign: (style.vertical ?? "middle") as CSSProperties["verticalAlign"],
    whiteSpace: style.wrapText ? "pre-wrap" : "nowrap",
    borderTop: borderValue(style.borderTop),
    borderRight: borderValue(style.borderRight),
    borderBottom: borderValue(style.borderBottom),
    borderLeft: borderValue(style.borderLeft)
  };
}

function displayDate(value: string) {
  const [year, month, day] = value.split("-");
  return `${day}/${month}/${year}`;
}

export function WorkbookGrid({ workbook, report, fromDate, toDate, zoom }: WorkbookGridProps) {
  const reportCells = report?.cells ?? {};
  const hiddenCells = useMemo(() => {
    const result = new Set<string>();
    Object.entries(workbook.cells).forEach(([key, cell]) => {
      const [row, column] = key.split(":").map(Number);
      for (let rowOffset = 0; rowOffset < (cell.rs ?? 1); rowOffset += 1) {
        for (let columnOffset = 0; columnOffset < (cell.cs ?? 1); columnOffset += 1) {
          if (rowOffset || columnOffset) result.add(`${row + rowOffset}:${column + columnOffset}`);
        }
      }
    });
    return result;
  }, [workbook]);

  return (
    <div className="workbook-viewport" aria-label={`Biểu mẫu ${workbook.title}`}>
      <div className="workbook-scale" style={{ "--workbook-zoom": zoom } as CSSProperties}>
        <table className="workbook-grid">
          <colgroup>
            {workbook.columns.map(([width, hidden], index) => (
              <col key={index} style={{ width: hidden ? 0 : width, display: hidden ? "none" : undefined }} />
            ))}
          </colgroup>
          <tbody>
            {workbook.rows.map(([height, hidden], rowIndex) => {
              const row = rowIndex + 1;
              if (hidden) return null;
              return (
                <tr key={row} style={{ height }}>
                  {Array.from({ length: workbook.maxColumn }, (_, columnIndex) => {
                    const column = columnIndex + 1;
                    const key = `${row}:${column}`;
                    if (hiddenCells.has(key) || workbook.columns[columnIndex]?.[1]) return null;
                    const cell = workbook.cells[key];
                    if (!cell) return <td key={key} />;
                    const sourceStyle = workbook.styles[cell.s] ?? {};
                    const reportCell = row === workbook.totalRow ? reportCells[`C${column}`] : undefined;
                    const isPeriodCell = row === 2 && column === 3;
                    const value = reportCell?.value ?? (isPeriodCell
                      ? `Từ ${displayDate(fromDate)} đến ngày ${displayDate(toDate)}`
                      : cell.v);
                    const rotation = sourceStyle.rotation ?? 0;
                    const title = reportCell
                      ? `${reportCell.code}: ${reportCell.status}${reportCell.formula ? ` · ${reportCell.formula}` : ""}${reportCell.reason ? ` · ${reportCell.reason}` : ""}`
                      : undefined;
                    return (
                      <td
                        key={key}
                        rowSpan={cell.rs}
                        colSpan={cell.cs}
                        className={reportCell ? `workbook-cell-${reportCell.status}` : undefined}
                        style={cellStyle(sourceStyle)}
                        title={title}
                        data-cell={`${row}:${column}`}
                      >
                        {rotation ? (
                          <span className="workbook-rotated-text" style={{ transform: `rotate(${rotation > 90 ? rotation - 180 : rotation}deg)` }}>
                            {value}
                          </span>
                        ) : value}
                      </td>
                    );
                  })}
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
