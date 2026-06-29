import { statusLabel } from "../../utils/format";

type CaseStatusBadgeProps = {
  status?: string | null;
};

export function CaseStatusBadge({ status }: CaseStatusBadgeProps) {
  const normalized = status ?? "unknown";
  return <span className={`status-badge status-${normalized}`}>{statusLabel(status)}</span>;
}
