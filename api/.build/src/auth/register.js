"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.register = void 0;
const userStore_1 = require("../shared/userStore");
const register = async (event) => {
    const body = JSON.parse(event.body || '{}');
    // Basic validation
    if (!body.name || !body.weight || !body.height || !body.age || !body.goal) {
        return {
            statusCode: 400,
            body: JSON.stringify({ message: 'Missing required profile data (Name, Age, Weight, Height, and Goal are mandatory)' }),
        };
    }
    const user = {
        id: 'user_' + Math.random().toString(36).substr(2, 9),
        ...body,
    };
    // Store user data in memory for local simulation
    (0, userStore_1.setUser)(user);
    console.log('User registered and stored:', user);
    return {
        statusCode: 201,
        body: JSON.stringify({
            message: 'User registered successfully',
            user: user,
        }),
    };
};
exports.register = register;
//# sourceMappingURL=register.js.map