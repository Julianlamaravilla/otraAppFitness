"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const generate_1 = require("../routines/generate");
describe('Routine Generation Logic', () => {
    it('should filter out exercises that match injuries', async () => {
        const event = {
            body: JSON.stringify({
                goal: 'Muscle Gain',
                injuries: 'knee',
                name: 'Test User'
            })
        };
        const response = await (0, generate_1.generate)(event);
        const body = JSON.parse(response.body);
        // Squats and Running target 'knee'. They should be absent.
        const hasSquats = body.routine.some((ex) => ex.name === 'Squats');
        const hasRunning = body.routine.some((ex) => ex.name === 'Running');
        expect(hasSquats).toBe(false);
        expect(hasRunning).toBe(false);
    });
    it('should return strength exercises for Muscle Gain goal', async () => {
        const event = {
            body: JSON.stringify({
                goal: 'Muscle Gain',
                name: 'Test User'
            })
        };
        const response = await (0, generate_1.generate)(event);
        const body = JSON.parse(response.body);
        expect(body.routine.length).toBeGreaterThan(0);
        body.routine.forEach((ex) => {
            expect(['Strength', 'Stability']).toContain(ex.category);
        });
    });
    it('should return error if goal is missing', async () => {
        const event = { body: JSON.stringify({ name: 'Test' }) };
        const response = await (0, generate_1.generate)(event);
        expect(response.statusCode).toBe(400);
    });
});
//# sourceMappingURL=routines.test.js.map