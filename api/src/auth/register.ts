import { setUser } from '../shared/userStore';

export const register = async (event: any) => {
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
  setUser(user);
  console.log('User registered and stored:', user);

  return {
    statusCode: 201,
    body: JSON.stringify({
      message: 'User registered successfully',
      user: user,
    }),
  };
};
