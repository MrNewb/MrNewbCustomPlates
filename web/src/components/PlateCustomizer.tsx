import { useCallback, useEffect, useRef, useState, type FormEvent, type MouseEvent } from 'react';
import { fetchNui, postNui } from '../utils/fetchNui';
import { sanitizePlate } from '../utils/plateText';
import type { PlateUiConfig } from '../types/plateUi';
import './plateCustomizer.css';

type PlateCustomizerProps = {
  config: PlateUiConfig;
  onClose: () => void;
};

type PlateSubmitResponse = {
  ok?: boolean;
  error?: string;
};

export function PlateCustomizer({ config, onClose }: PlateCustomizerProps) {
  const { minLength, maxLength, labels, locale } = config;
  const [plate, setPlate] = useState('');
  const [error, setError] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);
  const panelRef = useRef<HTMLElement>(null);
  const aliveRef = useRef(true);

  const canSubmit = plate.length >= minLength && !submitting;
  const belowMinimum = plate.length < minLength;
  const describedBy = error ? 'plate-counter plate-error' : 'plate-counter';

  useEffect(() => {
    aliveRef.current = true;
    postNui('plateReady');
    inputRef.current?.focus();
    return () => {
      aliveRef.current = false;
    };
  }, []);

  const handleCancel = useCallback(() => {
    postNui('plateCancel');
    onClose();
  }, [onClose]);

  useEffect(() => {
    const onKeyDown = (event: globalThis.KeyboardEvent) => {
      if (event.key === 'Escape') {
        event.preventDefault();
        if (!submitting) handleCancel();
        return;
      }

      if (event.key !== 'Tab' || !panelRef.current) return;

      const focusable = panelRef.current.querySelectorAll<HTMLElement>(
        'button:not(:disabled), input:not(:disabled)',
      );
      if (focusable.length === 0) return;

      const first = focusable[0];
      const last = focusable[focusable.length - 1];
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        first.focus();
      }
    };

    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, [handleCancel, submitting]);

  const handleInput = (value: string) => {
    setError('');
    setPlate(sanitizePlate(value, maxLength));
  };

  const handleSubmit = async () => {
    if (!canSubmit) return;
    setSubmitting(true);
    setError('');

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
    if (event.target !== event.currentTarget) return;
    handleCancel();
  };

  return (
    <div className="app" dir={locale.dir} lang={locale.lang} onClick={handleBackdropClick}>
      <div className="backdrop" />

      <section
        ref={panelRef}
        className="panel"
        role="dialog"
        aria-labelledby="plate-title"
        aria-describedby="plate-description"
        aria-modal="true"
        aria-busy={submitting}
      >
        <header className="panel__header">
          <h1 id="plate-title" className="panel__title">
            {labels.title}
          </h1>
          <p id="plate-description" className="panel__description">
            {labels.description}
          </p>
        </header>

        <form className="plate-stage" onSubmit={handleFormSubmit}>
          <div className="plate-frame">
            <img className="plate-frame__image" src="./assets/PLATE.webp" alt="" draggable={false} />
            <input
              ref={inputRef}
              className="plate-frame__input"
              data-length={plate.length || undefined}
              type="text"
              inputMode="text"
              autoComplete="off"
              autoCorrect="off"
              autoCapitalize="characters"
              spellCheck={false}
              minLength={minLength}
              maxLength={maxLength}
              required
              value={plate}
              onChange={(event) => handleInput(event.target.value)}
              aria-label={labels.inputLabel}
              aria-describedby={describedBy}
              aria-invalid={Boolean(error) || (plate.length > 0 && belowMinimum)}
              aria-errormessage={error ? 'plate-error' : undefined}
              disabled={submitting}
            />
          </div>
          <p id="plate-counter" className="plate-counter">
            {plate.length} / {maxLength}
            {belowMinimum ? ` · ${labels.minLengthHint}` : null}
          </p>
          {error ? (
            <p id="plate-error" className="plate-error" role="alert">
              {error}
            </p>
          ) : null}

          <footer className="panel__actions">
            <button type="button" className="btn btn--ghost" onClick={handleCancel} disabled={submitting}>
              {labels.cancel}
            </button>
            <button type="submit" className="btn btn--primary" disabled={!canSubmit}>
              {labels.submit}
            </button>
          </footer>
        </form>
      </section>
    </div>
  );
}
