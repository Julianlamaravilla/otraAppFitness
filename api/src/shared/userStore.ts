export let currentUser: any = null;

export const setUser = (user: any) => {
  currentUser = user;
};

export const getUser = () => currentUser;
