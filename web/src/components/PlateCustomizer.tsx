import { useCallback, useEffect, useRef, useState, type CSSProperties, type FormEvent, type MouseEvent } from 'react';
import logo from '../assets/mrnewb-logo.webp';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { fetchNui, postNui } from '../utils/fetchNui';
import { sanitizePlate } from '../utils/plateText';
import type { PlateUiConfig } from '../types/plateUi';

type PlateCustomizerProps = {
  config: PlateUiConfig;
  onClose: () => void;
};

type PlateSubmitResponse = {
  ok?: boolean;
  error?: string;
};

const STRIPPED_NOTE_MS = 2000;

// The plate art is 2:1 and its blank field runs about 12% to 88% of the width and 27% to 79% of the height.
// The wrapper is 31rem wide, so 1% of the plate width is 0.31rem (rem tracks the screen height, see index.css).
const PLATE_WIDTH_REM = 31;
const TEXT_FIELD_WIDTH_PERCENT = 72;
const MAX_FONT_PERCENT = 20;
// Average advance of Bebas Neue capitals in em, including the tracking below
const CHAR_ADVANCE_EM = 0.46;
const TRACKING_EM = 0.06;

function plateTextStyle(length: number): CSSProperties {
  const characters = Math.max(length, 1);
  const fontPercent = Math.min(MAX_FONT_PERCENT, TEXT_FIELD_WIDTH_PERCENT / (characters * CHAR_ADVANCE_EM));
  return {
    fontSize: `${((fontPercent * PLATE_WIDTH_REM) / 100).toFixed(3)}rem`,
    letterSpacing: `${TRACKING_EM}em`,
    // letter-spacing also trails the last glyph; the matching left padding keeps the text optically centred
    paddingLeft: `${TRACKING_EM}em`,
    // the native caret is as tall as the font's ascent plus descent; a clipped box keeps it near the cap height
    height: '0.85em',
    lineHeight: '0.85em',
    overflow: 'hidden',
  };
}

export function PlateCustomizer({ config, onClose }: PlateCustomizerProps) {
  const { minLength, maxLength, labels, locale } = config;
  const [plate, setPlate] = useState('');
  const [error, setError] = useState('');
  const [strippedNote, setStrippedNote] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);
  const aliveRef = useRef(true);
  const noteTimerRef = useRef<number>(0);

  const canSubmit = plate.length >= minLength && !submitting;
  const belowMinimum = plate.length < minLength;
  const status = error || (strippedNote ? labels.lettersOnly : '');

  useEffect(() => {
    aliveRef.current = true;
    postNui('plateReady');
    inputRef.current?.focus();
    return () => {
      aliveRef.current = false;
      window.clearTimeout(noteTimerRef.current);
    };
  }, []);

  const handleCancel = useCallback(() => {
    postNui('plateCancel');
    onClose();
  }, [onClose]);

  useEffect(() => {
    const onKeyDown = (event: globalThis.KeyboardEvent) => {
      if (event.key !== 'Escape') return;
      event.preventDefault();
      if (!submitting) handleCancel();
    };

    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, [handleCancel, submitting]);

  const handleChange = (raw: string) => {
    const next = sanitizePlate(raw, maxLength);
    const strippedInvalid = raw.toUpperCase().replace(/[A-Z0-9]/g, '').length > 0;

    setError('');
    setPlate(next);
    window.clearTimeout(noteTimerRef.current);
    setStrippedNote(strippedInvalid);
    if (strippedInvalid) {
      noteTimerRef.current = window.setTimeout(() => setStrippedNote(false), STRIPPED_NOTE_MS);
    }
  };

  const handleSubmit = async () => {
    if (!canSubmit) return;
    setSubmitting(true);
    setError('');
    setStrippedNote(false);

    const response = await fetchNui<PlateSubmitResponse>('plateSubmit', { plate }).catch(
      () => ({ ok: false, error: labels.invalidPlate }) as PlateSubmitResponse,
    );

    if (!aliveRef.current) return;
    if (response?.ok === false) {
      setError(response.error || labels.invalidPlate);
      setSubmitting(false);
      inputRef.current?.focus();
      return;
    }

    onClose();
  };

  const handleFormSubmit = (event: FormEvent) => {
    event.preventDefault();
    void handleSubmit();
  };

  const handleBackdropClick = (event: MouseEvent<HTMLDivElement>) => {
    if (event.target !== event.currentTarget || submitting) return;
    handleCancel();
  };

  return (
    <div
      className="fixed inset-0 grid place-items-center bg-scrim p-6"
      dir={locale.dir}
      lang={locale.lang}
      onClick={handleBackdropClick}
    >
      <Card className="w-[35rem] max-w-full gap-4 bg-card py-5 shadow-none" role="dialog" aria-modal="true" aria-labelledby="plate-title" aria-busy={submitting}>
        <CardHeader className="px-5">
          <div className="flex items-start justify-between gap-4">
            <div className="grid gap-1.5">
              <CardTitle id="plate-title" className="text-[1.05rem] leading-snug">{labels.title}</CardTitle>
              <CardDescription className="text-[0.875rem]">{labels.description}</CardDescription>
            </div>
            <img className="h-9 w-auto shrink-0 select-none opacity-90" src={logo} alt="MrNewb Scripts" draggable={false} />
          </div>
        </CardHeader>

        <form onSubmit={handleFormSubmit}>
          <CardContent className="grid justify-items-center gap-2.5 px-5">
            <div
              className="relative aspect-[2/1] w-full max-w-[31rem] cursor-text"
              onClick={() => inputRef.current?.focus()}
            >
              <img
                className="block size-full object-contain select-none"
                src="./assets/PLATE.webp"
                alt=""
                draggable={false}
                width={1600}
                height={800}
                decoding="async"
              />
              <div className="absolute inset-x-[12%] top-[27%] flex h-[52%] items-center justify-center">
                <input
                  ref={inputRef}
                  className="w-full border-0 bg-transparent text-center font-plate text-plate-ink uppercase caret-plate-ink outline-none transition-[font-size] duration-150 ease-out placeholder:text-plate-ghost aria-invalid:text-plate-error [text-shadow:1px_1px_0_#ffffff73,-1px_-1px_0_#00000047,0_2px_4px_#0000002e]"
                  style={plateTextStyle(plate.length || maxLength)}
                  type="text"
                  dir="ltr"
                  inputMode="text"
                  autoComplete="off"
                  autoCorrect="off"
                  autoCapitalize="characters"
                  spellCheck={false}
                  minLength={minLength}
                  maxLength={maxLength}
                  placeholder={labels.placeholder.slice(0, maxLength)}
                  required
                  value={plate}
                  onChange={(event) => handleChange(event.target.value)}
                  aria-label={labels.inputLabel}
                  aria-invalid={Boolean(error)}
                  disabled={submitting}
                />
              </div>
            </div>
            <div className="flex min-h-[1.25rem] w-full max-w-[31rem] items-baseline justify-between gap-3 text-[0.8125rem]">
              <p className={error ? 'text-destructive' : 'text-muted-foreground'} role={error ? 'alert' : undefined}>
                {status}
              </p>
              <p className="ml-auto text-muted-foreground tabular-nums">
                {plate.length} / {maxLength}
                {minLength > 1 && belowMinimum ? ` · ${labels.minLengthHint}` : null}
              </p>
            </div>
          </CardContent>

          <CardFooter className="mt-2 justify-end gap-2 px-5">
            <Button type="button" variant="outline" className="h-9 px-4 text-[0.875rem]" onClick={handleCancel} disabled={submitting}>
              {labels.cancel}
            </Button>
            <Button type="submit" className="h-9 px-4 text-[0.875rem]" disabled={!canSubmit}>
              {submitting ? labels.submitting : labels.submit}
            </Button>
          </CardFooter>
        </form>
      </Card>
    </div>
  );
}
