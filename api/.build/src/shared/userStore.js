"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getUser = exports.setUser = exports.currentUser = void 0;
exports.currentUser = null;
const setUser = (user) => {
    exports.currentUser = user;
};
exports.setUser = setUser;
const getUser = () => exports.currentUser;
exports.getUser = getUser;
//# sourceMappingURL=userStore.js.map