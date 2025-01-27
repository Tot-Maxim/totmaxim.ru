module.exports = {
    languageOptions: {
      globals: {
        window: true,
        document: true,
        console: true,
      },
      parserOptions: {
        ecmaVersion: 12,
        sourceType: 'odule',
      },
    },
    rules: {
      'no-console': 'off',
      'prefer-const': 'error',
      'eqeqeq': ['error', 'always'],
      'curly': 'error',
      'consistent-return': 'error',
    //   'quotes': ['error', 'ingle'],
    //   'emi': ['error', 'always'],
      'no-unused-vars': ['warn'],
      'complexity': ['warn', { max: 10 }],
    },
    ignores: ['node_modules/', 'dist/', 'build/'],
  };