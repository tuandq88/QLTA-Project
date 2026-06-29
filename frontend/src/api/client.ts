import type { ApiResponse } from "../types/cases";

const defaultBaseUrl = "http://127.0.0.1:3000";

export const apiBaseUrl = import.meta.env.VITE_API_BASE_URL ?? defaultBaseUrl;

export async function getJson<T>(path: string, params?: Record<string, string | number | undefined>) {
  const url = new URL(path, apiBaseUrl);

  Object.entries(params ?? {}).forEach(([key, value]) => {
    if (value !== undefined && value !== "") {
      url.searchParams.set(key, String(value));
    }
  });

  const response = await fetch(url);
  const body = (await response.json()) as ApiResponse<T>;

  if (!response.ok || !body.success) {
    throw new Error(body.error?.message ?? `HTTP ${response.status}`);
  }

  return body;
}

export async function postJson<T>(path: string, payload: unknown) {
  const url = new URL(path, apiBaseUrl);
  const response = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });
  const body = (await response.json()) as ApiResponse<T>;

  if (!response.ok || !body.success) {
    throw new Error(body.error?.message ?? `HTTP ${response.status}`);
  }

  return body;
}

export async function downloadFile(path: string, params: Record<string, string | undefined>) {
  const url = new URL(path, apiBaseUrl);
  Object.entries(params).forEach(([key, value]) => {
    if (value) url.searchParams.set(key, value);
  });
  const response = await fetch(url);
  if (!response.ok) {
    const body = (await response.json().catch(() => null)) as ApiResponse<unknown> | null;
    throw new Error(body?.error?.message ?? `HTTP ${response.status}`);
  }
  const blob = await response.blob();
  const disposition = response.headers.get("Content-Disposition") ?? "";
  const filename = disposition.match(/filename="?([^";]+)"?/i)?.[1] ?? "bao-cao";
  const objectUrl = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = objectUrl;
  anchor.download = filename;
  anchor.click();
  URL.revokeObjectURL(objectUrl);
}
