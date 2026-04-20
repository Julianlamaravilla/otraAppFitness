import { calculateConsistency } from '../progress/track';

describe('Progress Analytics Logic', () => {
  it('should calculate 0% consistency for no entries', () => {
    expect(calculateConsistency([])).toBe(0);
  });

  it('should calculate 100% consistency for entries every day of the last 7 days', () => {
    const entries = [];
    for (let i = 0; i < 7; i++) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      entries.push({ timestamp: d.toISOString() });
    }
    expect(calculateConsistency(entries)).toBe(100);
  });

  it('should calculate ~14% consistency for 1 entry in the last 7 days', () => {
    const d = new Date();
    const entries = [{ timestamp: d.toISOString() }];
    expect(calculateConsistency(entries)).toBe(14);
  });

  it('should ignore entries older than 7 days', () => {
    const d = new Date();
    d.setDate(d.getDate() - 10);
    const entries = [{ timestamp: d.toISOString() }];
    expect(calculateConsistency(entries)).toBe(0);
  });
});
