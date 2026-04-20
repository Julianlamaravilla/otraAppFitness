import { suggest } from '../nutrition/suggest';

describe('Nutrition Suggestion Logic', () => {
  it('should calculate calories correctly for weight gain', async () => {
    const event = {
      body: JSON.stringify({
        weight: 70,
        height: 175,
        age: 25,
        goal: 'Muscle Gain'
      })
    };

    const response = await suggest(event);
    const body = JSON.parse(response.body);

    // BMR approx = (10*70) + (6.25*175) - (5*25) + 5 = 700 + 1093.75 - 125 + 5 = 1673.75
    // Activity factor 1.5 = 2510
    // Muscle Gain + 400 = 2910
    expect(body.targetCalories).toBeGreaterThan(2800);
    expect(body.targetCalories).toBeLessThan(3000);
  });

  it('should filter out restricted meals (e.g. Vegan)', async () => {
    const event = {
      body: JSON.stringify({
        weight: 70,
        height: 175,
        age: 25,
        goal: 'Wellness',
        restrictions: 'Vegan'
      })
    };

    const response = await suggest(event);
    const body = JSON.parse(response.body);

    // Salmon and Chicken wraps are restricted for Vegan
    const hasSalmon = body.suggestions.some((m: any) => m.name.includes('Salmon'));
    const hasChicken = body.suggestions.some((m: any) => m.name.includes('Chicken'));

    expect(hasSalmon).toBe(false);
    expect(hasChicken).toBe(false);
  });

  it('should filter out specific ingredients like Peanut', async () => {
    const event = {
      body: JSON.stringify({
        weight: 70,
        height: 175,
        age: 25,
        goal: 'Wellness',
        restrictions: 'Peanut Allergy'
      })
    };

    const response = await suggest(event);
    const body = JSON.parse(response.body);

    const hasPeanut = body.suggestions.some((m: any) => m.name.includes('Peanut'));
    expect(hasPeanut).toBe(false);
  });
});
