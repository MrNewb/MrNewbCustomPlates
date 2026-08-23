export type PlateLabels = {
  title: string;
  description: string;
  submit: string;
  cancel: string;
  inputLabel: string;
  minLengthHint: string;
  invalidPlate: string;
};

export type PlateOpenPayload = {
  action: 'open';
  minLength?: number;
  maxLength?: number;
  locale?: string;
  labels?: Partial<PlateLabels>;
};

export type PlateClosePayload = {
  action: 'close';
};

export type PlateDocumentLocale = {
  lang: string;
  dir: 'ltr' | 'rtl';
};

export type PlateUiConfig = {
  minLength: number;
  maxLength: number;
  labels: PlateLabels;
  locale: PlateDocumentLocale;
};

export const defaultLabels: PlateLabels = {
  title: 'Plate Customization',
  description: 'Enter your custom plate text below',
  submit: 'Submit',
  cancel: 'Cancel',
  inputLabel: 'License plate text',
  minLengthHint: '1 minimum',
  invalidPlate: 'That plate text is not allowed',
};

const rtlLanguages = new Set(['ar', 'fa', 'he', 'ur']);

const htmlLangByLocale: Record<string, string> = {
  'en-pirate': 'en',
  'zh-cn': 'zh-CN',
  'zh-hk': 'zh-HK',
  'zh-tw': 'zh-TW',
};

export function resolvePlateLocale(localeKey: string | undefined): PlateDocumentLocale {
  const key = (localeKey || 'en').trim().toLowerCase() || 'en';
  const language = key.split('-')[0] || 'en';
  return {
    lang: htmlLangByLocale[key] ?? key,
    dir: rtlLanguages.has(language) ? 'rtl' : 'ltr',
  };
}
