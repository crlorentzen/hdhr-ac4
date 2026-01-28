import globals from 'globals';
import js from '@eslint/js';
import stylistic from '@stylistic/eslint-plugin';

export default [
  // Global ignores
  {
    ignores: [
      '**/node_modules/**',
      '**/dist/**',
      '**/coverage/**',
      '**/es5/**',
      '**/*.min.js',
      '**/build-output*.log'
    ]
  },

  // Base config for all JavaScript and TypeScript files
  {
    files: ['**/*.js'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'commonjs',
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.es2017,
        Atomics: 'readonly',
        SharedArrayBuffer: 'readonly',
        globalThis: false
      }
    },
    plugins: {
      '@stylistic': stylistic,
    },
    rules: {
      // ESLint recommended rules
      ...js.configs.recommended.rules,
      'no-unused-vars': 'warn',

      // Stylistic rules (moved from core ESLint)
      '@stylistic/array-bracket-newline': 'off',
      '@stylistic/array-bracket-spacing': ['error', 'never'],
      '@stylistic/array-element-newline': 'off',
      '@stylistic/arrow-parens': ['error', 'as-needed'],
      '@stylistic/arrow-spacing': ['error', { after: true, before: true }],
      '@stylistic/block-spacing': ['error', 'always'],
      '@stylistic/brace-style': ['error', '1tbs', { allowSingleLine: true }],
      '@stylistic/comma-dangle': 'off',
      '@stylistic/comma-spacing': ['error', { after: true, before: false }],
      '@stylistic/comma-style': ['error', 'last'],
      '@stylistic/computed-property-spacing': ['error', 'never'],
      '@stylistic/dot-location': ['error', 'property'],
      '@stylistic/eol-last': 'error',
      '@stylistic/function-call-spacing': 'error',
      '@stylistic/function-call-argument-newline': 'off',
      '@stylistic/function-paren-newline': 'off',
      '@stylistic/generator-star-spacing': 'error',
      '@stylistic/implicit-arrow-linebreak': 'off',
      '@stylistic/indent': ['error', 2, { SwitchCase: 1 }],
      '@stylistic/jsx-quotes': 'error',
      '@stylistic/key-spacing': 'error',
      '@stylistic/keyword-spacing': 'error',
      '@stylistic/line-comment-position': 'off',
      // '@stylistic/linebreak-style': ['error', 'unix'],
      '@stylistic/max-len': 'off',
      '@stylistic/max-statements-per-line': 'off',
      '@stylistic/multiline-comment-style': 'off',
      '@stylistic/multiline-ternary': 'off',
      '@stylistic/new-parens': 'error',
      '@stylistic/no-confusing-arrow': 'off',
      '@stylistic/no-extra-parens': 'off',
      '@stylistic/no-floating-decimal': 'error',
      '@stylistic/no-mixed-operators': 'off',
      '@stylistic/no-mixed-spaces-and-tabs': 'error',
      '@stylistic/no-multi-spaces': 'off',
      '@stylistic/no-multiple-empty-lines': 'error',
      '@stylistic/no-tabs': 'error',
      '@stylistic/no-trailing-spaces': 'error',
      '@stylistic/no-whitespace-before-property': 'off',
      '@stylistic/nonblock-statement-body-position': 'error',
      '@stylistic/object-curly-newline': ['error', { 'consistent': true }],
      '@stylistic/object-curly-spacing': ['error', 'always'],
      '@stylistic/object-property-newline': 'off',
      '@stylistic/one-var-declaration-per-line': 'error',
      '@stylistic/operator-linebreak': 'off',
      '@stylistic/padded-blocks': 'off',
      '@stylistic/padding-line-between-statements': 'error',
      '@stylistic/quote-props': ['error', 'consistent'],
      // '@stylistic/quotes': ['error', 'single'],
      '@stylistic/rest-spread-spacing': ['error', 'never'],
      '@stylistic/semi': ['error', 'always'],
      '@stylistic/semi-spacing': 'error',
      '@stylistic/semi-style': ['error', 'last'],
      '@stylistic/space-before-blocks': 'error',
      '@stylistic/space-before-function-paren': ['error', {
        anonymous: 'never',
        named: 'never',
        asyncArrow: 'always'
      }],
      '@stylistic/space-in-parens': ['error', 'never'],
      '@stylistic/space-infix-ops': 'error',
      '@stylistic/space-unary-ops': 'error',
      '@stylistic/spaced-comment': ['error', 'always'],
      '@stylistic/switch-colon-spacing': ['error', { after: true, before: false }],
      '@stylistic/template-curly-spacing': ['error', 'never'],
      '@stylistic/template-tag-spacing': 'error',
      '@stylistic/wrap-iife': 'error',
      '@stylistic/yield-star-spacing': 'error'
    }
  },

  // Test files
  {
    files: ['test/**/*.js', 'test/**/*.ts'],
    languageOptions: {
      globals: {
        ...globals.mocha,
        ...globals.node
      }
    },
    rules: {
      'consistent-return': 'warn',
      'no-console': 'off',
      'no-unused-vars': 'warn',
      'no-undefined': 'off'
    }
  },

  // Script files (build/utility scripts)
  {
    files: ['scripts/**/*.js'],
    languageOptions: {
      globals: {
        ...globals.node
      }
    },
    rules: {
      'no-console': 'off'
    }
  }
];


