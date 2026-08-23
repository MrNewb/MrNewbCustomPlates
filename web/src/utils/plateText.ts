export function sanitizePlate(value: string, maxLength: number): string {
  return value
    .toUpperCase()
    .replace(/[^A-Z0-9]/g, '')
    .slice(0, maxLength);
}
