import * as fs from 'fs';
import * as path from 'path';

// Use process.cwd() to stay in the root of the project even when running from .build
const DATA_DIR = process.env.PROCESS_DATA_DIR || path.join(process.cwd(), 'src/data');
const DB_PATH = path.join(DATA_DIR, 'progress.json');

// Helper to read DB
const readDB = () => {
  try {
    if (!fs.existsSync(DATA_DIR)) {
      fs.mkdirSync(DATA_DIR, { recursive: true });
    }
    if (!fs.existsSync(DB_PATH)) {
      fs.writeFileSync(DB_PATH, '[]');
      return [];
    }
    const data = fs.readFileSync(DB_PATH, 'utf8');
    return JSON.parse(data);
  } catch (e) {
    console.error('Error reading DB:', e);
    return [];
  }
};

// Helper to write DB
const writeDB = (data: any[]) => {
  fs.writeFileSync(DB_PATH, JSON.stringify(data, null, 2));
};

export const track = async (event: any) => {
  const body = JSON.parse(event.body || '{}');

  if (!body.type || !body.value) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Missing progress data (type and value are mandatory)' }),
    };
  }

  const progressEntries = readDB();
  const newEntry = {
    id: 'entry_' + Math.random().toString(36).substr(2, 9),
    timestamp: new Date().toISOString(),
    type: body.type,
    value: body.value,
    notes: body.notes || '',
  };

  progressEntries.push(newEntry);
  writeDB(progressEntries);

  console.log('Saved progress entry to disk:', newEntry);

  return {
    statusCode: 201,
    body: JSON.stringify({
      message: 'Progress tracked successfully',
      entry: newEntry,
    }),
  };
};

export const getHistory = async (event: any) => {
  const progressEntries = readDB();
  return {
    statusCode: 200,
    body: JSON.stringify({
      history: progressEntries,
      consistencyScore: calculateConsistency(progressEntries),
    }),
  };
};

export function calculateConsistency(entries: any[]): number {
  if (entries.length === 0) return 0;

  const last7Days = new Array(7).fill(0).map((_, i) => {
    const d = new Date();
    d.setDate(d.getDate() - i);
    return d.toISOString().split('T')[0];
  });

  const entryDays = new Set(entries.map(e => e.timestamp.split('T')[0]));
  const consistentDays = last7Days.filter(day => entryDays.has(day)).length;

  return Math.round((consistentDays / 7) * 100);
}
