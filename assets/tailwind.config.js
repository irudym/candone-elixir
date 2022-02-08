module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {
      backgroundColor: {
        'primary-200': '#778493',
        'primary-100': '#B5BFC9',
        'primary2-300': '#30556E',
        'primary2-200': '#417293',
        'primary2-100': '#7AB5C8',
        'green-300': '#539480',
      },
    },
    fontSize: {
      'xs': '.75rem',
      'sm': '.875rem',
      'tiny': '.875rem',
      'base': '1rem',
      'lg': '1.125rem',
      'xl': '1.25rem',
      '2xl': '1.5rem',
      '3xl': '1.875rem',
      '4xl': '2.25rem',
      '5xl': '3rem',
      '6xl': '4rem',
      '7xl': '5rem'
    }
  },
  variants: {},
  plugins: []
};
