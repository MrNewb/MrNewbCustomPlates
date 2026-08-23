import { isEnvBrowser } from './misc';

export async function fetchNui<T>(event: string, data?: unknown, mock?: T): Promise<T> {
  if (isEnvBrowser()) {
    if (mock !== undefined) return mock as T;
    return { ok: true } as T;
  }

  const resource = window.GetParentResourceName?.() ?? 'MrNewbCustomPlates';
  const response = await fetch(`https://${resource}/${event}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data ?? {}),
  });

  const text = await response.text();
  if (!text) return { ok: true } as T;

  try {
    return JSON.parse(text) as T;
  } catch {
    return { ok: response.ok } as T;
  }
}

export function postNui(event: string, data?: unknown): void {
  if (isEnvBrowser()) return;
  void fetchNui(event, data).catch(() => undefined);
}
