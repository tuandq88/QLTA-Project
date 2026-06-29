import type { ReactNode } from "react";
import { AlertTriangle, Ban, FileSearch, Loader2, Lock, ShieldAlert } from "lucide-react";
import type { DataState as DataStateType } from "../../types/cases";

type DataStateProps = {
  state: DataStateType;
  title?: string;
  description?: string;
  action?: ReactNode;
};

const contentByState: Record<DataStateType, { title: string; description: string; icon: ReactNode }> = {
  idle: {
    title: "Sẵn sàng tải dữ liệu",
    description: "Chọn bộ lọc hoặc tải danh sách hồ sơ án.",
    icon: <FileSearch aria-hidden="true" />
  },
  loading: {
    title: "Đang tải dữ liệu",
    description: "Dữ liệu đang được tải, vui lòng chờ trong giây lát.",
    icon: <Loader2 className="spin" aria-hidden="true" />
  },
  empty: {
    title: "Không có dữ liệu",
    description: "Không tìm thấy hồ sơ án phù hợp với điều kiện lọc hiện tại.",
    icon: <FileSearch aria-hidden="true" />
  },
  error: {
    title: "Không tải được dữ liệu",
    description: "Vui lòng thử tải lại dữ liệu.",
    icon: <AlertTriangle aria-hidden="true" />
  },
  readonly: {
    title: "Chế độ chỉ xem",
    description: "Người dùng hiện tại chỉ được xem dữ liệu, không được chỉnh sửa hồ sơ.",
    icon: <Lock aria-hidden="true" />
  },
  permission_denied: {
    title: "Không có quyền truy cập",
    description: "Tài khoản hiện tại chưa có quyền xem danh sách hoặc chi tiết hồ sơ án.",
    icon: <ShieldAlert aria-hidden="true" />
  }
};

export function DataState({ state, title, description, action }: DataStateProps) {
  const content = contentByState[state];

  return (
    <div className={`data-state data-state-${state}`} role={state === "error" ? "alert" : "status"}>
      <div className="data-state-icon">{state === "permission_denied" ? <Ban aria-hidden="true" /> : content.icon}</div>
      <div>
        <h3>{title ?? content.title}</h3>
        <p>{description ?? content.description}</p>
        {state === "loading" ? (
          <div className="state-skeleton" aria-hidden="true">
            <span />
            <span />
            <span />
          </div>
        ) : null}
        {action ? <div className="data-state-action">{action}</div> : null}
      </div>
    </div>
  );
}
