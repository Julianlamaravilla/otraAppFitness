"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.hello = void 0;
const hello = async (event) => {
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Fitness App API v1.0 - Local Setup Complete!',
            input: event,
        }, null, 2),
    };
};
exports.hello = hello;
//# sourceMappingURL=handler.js.map