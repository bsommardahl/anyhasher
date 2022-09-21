export default {
  clearMocks: true,
  collectCoverage: true,
  coverageDirectory: "coverage",
  coveragePathIgnorePatterns: [
    "/node_modules/"
  ],
  coverageProvider: "v8",
  coverageReporters: [
    "json",
    "text",
    "lcov",
    "clover"
  ],
  coverageThreshold: { 
    "global": {
      "branches": 50,
      "functions": 100,
      "lines": 100,
      "statements": 100
    }
  },
  preset: "ts-jest",
  roots: [
    "<rootDir>/src"
  ],
  testEnvironment: "node",
  testMatch: [
    "**/?(*.)+(spec|test).[tj]s?(x)"
  ],
  testPathIgnorePatterns: [
    "/node_modules/"
  ]
};
