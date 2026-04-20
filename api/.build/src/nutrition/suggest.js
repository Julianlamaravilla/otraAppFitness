"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.suggest = void 0;
const suggest = async (event) => {
    const body = JSON.parse(event.body || '{}');
    const { weight, height, age, goal, restrictions } = body;
    if (!weight || !height || !age || !goal) {
        return {
            statusCode: 400,
            body: JSON.stringify({ message: 'Weight, height, age, and goal are required for suggestions.' }),
        };
    }
    // Calculate base calories using a simplified Mifflin-St Jeor
    const baseCalories = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    let targetCalories = Math.round(baseCalories * 1.5); // Moderate activity factor
    // Adjust calories based on goal
    const normalizedGoal = goal.toLowerCase();
    let macroSplit = { protein: 25, carbs: 45, fats: 30 }; // Default Wellness
    if (normalizedGoal.includes('muscle gain')) {
        targetCalories += 400;
        macroSplit = { protein: 35, carbs: 40, fats: 25 };
    }
    else if (normalizedGoal.includes('endurance') || normalizedGoal.includes('agility')) {
        targetCalories += 200;
        macroSplit = { protein: 20, carbs: 60, fats: 20 };
    }
    const macros = {
        protein: Math.round((targetCalories * (macroSplit.protein / 100)) / 4),
        carbs: Math.round((targetCalories * (macroSplit.carbs / 100)) / 4),
        fats: Math.round((targetCalories * (macroSplit.fats / 100)) / 9),
    };
    // Mock meal library
    const mealLibrary = [
        { name: 'Grilled Salmon with Quinoa', tags: ['High Protein', 'Omega-3'], calories: 550, ingredients: ['Salmon', 'Quinoa', 'Asparagus'], restrictions: ['Vegan'] },
        { name: 'Peanut Butter & Banana Toast', tags: ['Quick', 'Energy'], calories: 350, ingredients: ['Peanut Butter', 'Banana', 'Whole Wheat Bread'], restrictions: ['Peanut Allergy'] },
        { name: 'Lentil & Chickpea Stew', tags: ['Plant Based', 'Fiber'], calories: 420, ingredients: ['Lentils', 'Chickpeas', 'Spinach', 'Coconut Milk'], restrictions: [] },
        { name: 'Chicken & Avocado Wrap', tags: ['High Protein', 'Healthy Fats'], calories: 480, ingredients: ['Chicken', 'Avocado', 'Whole Wheat Tortilla'], restrictions: ['Vegan'] },
        { name: 'Spinach & Berry Smoothie', tags: ['Antioxidants', 'Light'], calories: 280, ingredients: ['Spinach', 'Blueberries', 'Almond Milk'], restrictions: [] },
    ];
    // Filter based on restrictions (Case-insensitive check)
    const userRestrictions = (restrictions || '').toLowerCase();
    const suggestions = mealLibrary.filter(meal => {
        // Check if any of the meal's restricted categories match the user's restrictions
        const isRestricted = meal.restrictions.some(r => userRestrictions.includes(r.toLowerCase()));
        // Also check if any ingredient is specifically listed in user restrictions
        const hasRestrictedIngredient = meal.ingredients.some(i => userRestrictions.includes(i.toLowerCase()));
        return !isRestricted && !hasRestrictedIngredient;
    });
    return {
        statusCode: 200,
        body: JSON.stringify({
            targetCalories,
            macros,
            macroSplit,
            suggestions: suggestions.slice(0, 3), // Return top 3 safe suggestions
        }),
    };
};
exports.suggest = suggest;
//# sourceMappingURL=suggest.js.map