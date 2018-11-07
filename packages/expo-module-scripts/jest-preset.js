'use strict';

const fs = require('fs');
const jestExpoPreset = require('jest-expo/jest-preset');
const path = require('path');
const { jsWithBabel: tsJestPreset } = require('ts-jest/presets');

// Jest does not support chained presets so we flatten this preset before exporting it
module.exports = {
  ...jestExpoPreset,
  clearMocks: true,
  roots: ['<rootDir>/src'],
  transform: {
    '^.+\\.jsx?$': 'babel-jest',
    '^.+\\.tsx?$': 'ts-jest',
  },
  testMatch: tsJestPreset.testMatch,
  moduleFileExtensions: tsJestPreset.moduleFileExtensions,
  globals: {
    'ts-jest': {
      tsConfig: _createTypeScriptConfiguration(),
      babelConfig: _createBabelConfiguration(),
    },
  },
};

function _createBabelConfiguration() {
  // "true" signals that ts-jest should use Babel's default configuration lookup, which will use the
  // configuration file written above
  return true;
}

function _createTypeScriptConfiguration() {
  let tsConfigFileName = 'tsconfig.json';
  // The path to tsconfig.json is resolved relative to cwd
  let tsConfigPath = path.resolve(tsConfigFileName);

  let jestTsConfig = {
    extends: tsConfigPath,
    compilerOptions: {
      // Explicitly specify "module" so that ts-jest doesn't provide its default
      module: 'es2015',
    },
  };

  let jestTsConfigJson = JSON.stringify(jestTsConfig, null, 2);
  // The TypeScript configuration needs to be under the project directory so that TypeScript finds
  // type declaration packages that are installed in the project or workspace root (writing it to a
  // temporary directory would not work, for example)
  let jestTsConfigPath = path.join('.expo', 'tsconfig.jest.json');

  fs.mkdirSync(path.dirname(jestTsConfigPath), { recursive: true });
  fs.writeFileSync(jestTsConfigPath, jestTsConfigJson);
  return jestTsConfigPath;
}
