import { StrictMode, useMemo, useState, type ReactNode } from "react";
import { createRoot } from "react-dom/client";
import { BarChart3, ClipboardList, FilePenLine, LayoutDashboard, ListChecks } from "lucide-react";
import { CaseProgressDashboardPage } from "./pages/cases/CaseProgressDashboardPage";
import { CaseIntakeFormPage } from "./pages/cases/CaseIntakeFormPage";
import { CaseRelatedFormsPage } from "./pages/cases/CaseRelatedFormsPage";
import { CaseWorklistPage } from "./pages/cases/CaseWorklistPage";
import { StatisticsWorkbookPage } from "./pages/statistics/StatisticsWorkbookPage";
import "./styles.css";

type AppPage = "dashboard" | "statistics" | "intake" | "related" | "worklist";

type NavigationItem = {
  id: AppPage;
  label: string;
  description: string;
};

type NavigationGroup = {
  id: "operations" | "statistics" | "lists" | "input";
  label: string;
  icon: ReactNode;
  items: NavigationItem[];
};

const navigationGroups: NavigationGroup[] = [
  {
    id: "operations",
    label: "Điều hành",
    icon: <LayoutDashboard size={18} aria-hidden="true" />,
    items: [
      {
        id: "dashboard",
        label: "Dashboard tiến độ",
        description: "Theo dõi thụ lý, giải quyết, quá hạn, phân công và án hủy/sửa."
      }
    ]
  },
  {
    id: "statistics",
    label: "Thống kê",
    icon: <BarChart3 size={18} aria-hidden="true" />,
    items: [
      {
        id: "statistics",
        label: "Biểu mẫu nghiệp vụ",
        description: "24 biểu mẫu theo loại án và cấp xét xử, render trực tiếp từ workbook nguồn."
      }
    ]
  },
  {
    id: "lists",
    label: "Danh sách",
    icon: <ListChecks size={18} aria-hidden="true" />,
    items: [
      {
        id: "worklist",
        label: "Danh sách hồ sơ",
        description: "Tra cứu, lọc và mở chi tiết hồ sơ."
      }
    ]
  },
  {
    id: "input",
    label: "Nhập liệu",
    icon: <FilePenLine size={18} aria-hidden="true" />,
    items: [
      {
        id: "intake",
        label: "Nhập hồ sơ mới",
        description: "Tạo hồ sơ, thông tin loại án và phân công."
      },
      {
        id: "related",
        label: "Bổ sung vòng đời",
        description: "Cập nhật người tham gia, phiên tòa, thụ lý và kết quả."
      }
    ]
  }
];

function App() {
  const [page, setPage] = useState<AppPage>(() => window.location.hash.startsWith("#statistics/") ? "statistics" : "dashboard");
  const activeGroup = useMemo(
    () => navigationGroups.find((group) => group.items.some((item) => item.id === page)) ?? navigationGroups[0],
    [page]
  );
  const activeItem = activeGroup.items.find((item) => item.id === page) ?? activeGroup.items[0];

  function navigate(nextPage: AppPage) {
    setPage(nextPage);
    if (nextPage !== "statistics") window.location.hash = nextPage;
  }

  return (
    <>
      <nav className="app-nav" aria-label="Điều hướng chức năng hệ thống">
        <div className="app-nav-inner">
          <div className="app-nav-brand">
            <ClipboardList size={22} aria-hidden="true" />
            <div>
              <strong>QLTA Quảng Ngãi</strong>
              <span>
                {activeGroup.label} · {activeItem.label}
              </span>
            </div>
          </div>
          <div className="app-nav-groups" role="list">
            {navigationGroups.map((group) => (
              <section
                className={`app-nav-group ${group.id === activeGroup.id ? "app-nav-group-active" : ""}`}
                key={group.id}
                aria-label={group.label}
                role="listitem"
              >
                <div className="app-nav-group-heading">
                  {group.icon}
                  <strong>{group.label}</strong>
                </div>
                <div className="app-nav-items">
                  {group.items.map((item) => (
                    <button
                      className={page === item.id ? "app-nav-active" : ""}
                      key={item.id}
                      type="button"
                      aria-current={page === item.id ? "page" : undefined}
                      title={item.description}
                      onClick={() => navigate(item.id)}
                    >
                      <span>{item.label}</span>
                    </button>
                  ))}
                </div>
              </section>
            ))}
          </div>
        </div>
      </nav>
      {page === "dashboard" ? (
        <CaseProgressDashboardPage />
      ) : page === "statistics" ? (
        <StatisticsWorkbookPage />
      ) : page === "intake" ? (
        <CaseIntakeFormPage />
      ) : page === "related" ? (
        <CaseRelatedFormsPage />
      ) : (
        <CaseWorklistPage />
      )}
    </>
  );
}

createRoot(document.getElementById("root") as HTMLElement).render(
  <StrictMode>
    <App />
  </StrictMode>
);
