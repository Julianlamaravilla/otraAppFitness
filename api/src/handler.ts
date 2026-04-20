export const hello = async (event: any) => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Fitness App API v1.0 - Local Setup Complete!',
        input: event,
      },
      null,
      2
    ),
  };
};
