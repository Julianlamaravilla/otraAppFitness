const { createDefaultPreset } = require("ts-jest");

const tsJestTransformCfg = createDefaultPreset({
  diagnostics: {
    ignoreCodes: [5107] // Ignore the 'node10' resolution deprecation warning
  }
}).transform;

/** @type {import("jest").Config} **/
module.exports = {
  testEnvironment: "node",
  transform: {
    ...tsJestTransformCfg,
  },
  modulePathIgnorePatterns: ["<rootDir>/.build/"],
  testMatch: ["**/src/tests/**/*.test.ts"]
};