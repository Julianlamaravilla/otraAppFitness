"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.getHistory = exports.track = void 0;
exports.calculateConsistency = calculateConsistency;
const fs = __importStar(require("fs"));
const path = __importStar(require("path"));
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
    }
    catch (e) {
        console.error('Error reading DB:', e);
        return [];
    }
};
// Helper to write DB
const writeDB = (data) => {
    fs.writeFileSync(DB_PATH, JSON.stringify(data, null, 2));
};
const track = async (event) => {
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
exports.track = track;
const getHistory = async (event) => {
    const progressEntries = readDB();
    return {
        statusCode: 200,
        body: JSON.stringify({
            history: progressEntries,
            consistencyScore: calculateConsistency(progressEntries),
        }),
    };
};
exports.getHistory = getHistory;
function calculateConsistency(entries) {
    if (entries.length === 0)
        return 0;
    const last7Days = new Array(7).fill(0).map((_, i) => {
        const d = new Date();
        d.setDate(d.getDate() - i);
        return d.toISOString().split('T')[0];
    });
    const entryDays = new Set(entries.map(e => e.timestamp.split('T')[0]));
    const consistentDays = last7Days.filter(day => entryDays.has(day)).length;
    return Math.round((consistentDays / 7) * 100);
}
//# sourceMappingURL=track.js.map