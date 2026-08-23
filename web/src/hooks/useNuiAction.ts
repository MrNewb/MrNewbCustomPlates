import { useEffect, useRef } from 'react';
import { isRecord } from '../utils/misc';

export function useNuiAction<T extends Record<string, unknown>>(
  action: string,
  handler: (payload: T) => void,
) {
  const handlerRef = useRef(handler);

  useEffect(() => {
    handlerRef.current = handler;
  }, [handler]);

  useEffect(() => {
    const listener = (event: MessageEvent) => {
      if (!isRecord(event.data)) return;
      if (event.data.action !== action) return;
      handlerRef.current(event.data as T);
    };

    window.addEventListener('message', listener);
    return () => window.removeEventListener('message', listener);
  }, [action]);
}
