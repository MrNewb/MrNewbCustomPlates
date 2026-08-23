import { useCallback, useEffect, useState } from 'react';
import { PlateCustomizer } from './components/PlateCustomizer';
import { useNuiAction } from './hooks/useNuiAction';
import {
  defaultLabels,
  resolvePlateLocale,
  type PlateOpenPayload,
  type PlateUiConfig,
} from './types/plateUi';
import { isEnvBrowser } from './utils/misc';

const defaultLocale = resolvePlateLocale('en');

const browserConfig: PlateUiConfig = {
  minLength: 1,
  maxLength: 8,
  labels: defaultLabels,
  locale: defaultLocale,
};

function applyDocumentLocale(lang: string, dir: 'ltr' | 'rtl') {
  document.documentElement.lang = lang;
  document.documentElement.dir = dir;
}

export default function App() {
  const [visible, setVisible] = useState(isEnvBrowser());
  const [config, setConfig] = useState<PlateUiConfig>(browserConfig);

  const handleClose = useCallback(() => {
    setVisible(false);
  }, []);

  useEffect(() => {
    if (!visible) {
      applyDocumentLocale('en', 'ltr');
      return;
    }
    applyDocumentLocale(config.locale.lang, config.locale.dir);
  }, [visible, config.locale.lang, config.locale.dir]);

  useNuiAction<PlateOpenPayload>('open', (payload) => {
    const locale = resolvePlateLocale(payload.locale);
    applyDocumentLocale(locale.lang, locale.dir);
    setConfig({
      minLength: Number(payload.minLength) || 1,
      maxLength: Number(payload.maxLength) || 8,
      locale,
      labels: {
        title: payload.labels?.title ?? defaultLabels.title,
        description: payload.labels?.description ?? defaultLabels.description,
        submit: payload.labels?.submit ?? defaultLabels.submit,
        cancel: payload.labels?.cancel ?? defaultLabels.cancel,
        inputLabel: payload.labels?.inputLabel ?? defaultLabels.inputLabel,
        minLengthHint: payload.labels?.minLengthHint ?? defaultLabels.minLengthHint,
        invalidPlate: payload.labels?.invalidPlate ?? defaultLabels.invalidPlate,
      },
    });
    setVisible(true);
  });

  useNuiAction('close', () => {
    setVisible(false);
  });

  if (!visible) return null;

  return <PlateCustomizer config={config} onClose={handleClose} />;
}
