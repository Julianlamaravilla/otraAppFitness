"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generate = void 0;
const generate = async (event) => {
    const body = JSON.parse(event.body || '{}');
    const { goal, injuries, name } = body;
    if (!goal) {
        return {
            statusCode: 400,
            body: JSON.stringify({ message: 'Goal is required to generate a routine' }),
        };
    }
    // Base exercises library
    const exercises = [
        { id: 1, name: 'Squats', category: 'Strength', target: ['legs', 'knee'], intensity: 'High' },
        { id: 2, name: 'Pushups', category: 'Strength', target: ['chest', 'arms', 'shoulder'], intensity: 'Medium' },
        { id: 3, name: 'Deadlifts', category: 'Strength', target: ['back', 'legs'], intensity: 'High' },
        { id: 4, name: 'Running', category: 'Endurance', target: ['legs', 'knee', 'cardio'], intensity: 'Medium' },
        { id: 5, name: 'Cycling', category: 'Endurance', target: ['legs', 'cardio'], intensity: 'Low' },
        { id: 6, name: 'Plank', category: 'Stability', target: ['core', 'back'], intensity: 'Medium' },
        { id: 7, name: 'Yoga Flow', category: 'Flexibility', target: ['full_body'], intensity: 'Low' },
        { id: 8, name: 'Burpees', category: 'Agility', target: ['full_body', 'cardio'], intensity: 'High' },
    ];
    // Logic: Filter by Goal
    let filtered = exercises;
    if (goal.includes('Muscle Gain')) {
        filtered = exercises.filter(e => e.category === 'Strength' || e.category === 'Stability');
    }
    else if (goal.includes('Endurance')) {
        filtered = exercises.filter(e => e.category === 'Endurance' || e.category === 'Agility');
    }
    else if (goal.includes('Agility')) {
        filtered = exercises.filter(e => e.category === 'Agility' || e.category === 'Flexibility');
    }
    // Logic: Filter by Injuries (Safety Logic)
    // Note: In a real app, 'injuries' might be a list of tags. 
    // Here we check if any exercise target is mentioned in the injuries string.
    const injuryList = (injuries || '').toLowerCase();
    const safeExercises = filtered.filter(ex => {
        // If no target matches the injury keywords, it's safe
        return !ex.target.some(t => injuryList.includes(t));
    });
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: `Routine generated for ${name}`,
            routine: safeExercises.slice(0, 5), // Return top 5 safe exercises
            generatedAt: new Date().toISOString(),
        }),
    };
};
exports.generate = generate;
//# sourceMappingURL=generate.js.map