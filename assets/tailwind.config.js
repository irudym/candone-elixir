// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/candone_web.ex",
    "../lib/candone_web/**/*.*ex",
    "../lib/candone/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        // Linear-style warm palette
        'sand': {
          50: '#faf7f2',
          100: '#f5f1eb',
          200: '#ebe7df',
          300: '#e2ded6',
          400: '#d8d4cc',
          500: '#c5c1b9',
          600: '#a0a0aa',
          700: '#7a7a88',
          800: '#5a5a6e',
          900: '#3d3d4a',
          950: '#2d2d3a',
        },
        'accent': {
          DEFAULT: '#d4956a',
          light: '#e0a87c',
          dark: '#c6875a',
        },
        // Priority colors
        'priority': {
          urgent: '#e07a5f',
          high: '#d4956a',
          medium: '#9b8ec4',
          low: '#a0aab4',
          none: '#c5c9cf',
        },
        // Status colors
        'status': {
          backlog: '#a0aab4',
          inprogress: '#d4956a',
          done: '#7bb89e',
        },
        // Label colors
        'label': {
          bug: '#c75c5c',
          'bug-bg': '#fce8e8',
          feature: '#8b72c7',
          'feature-bg': '#ede6fa',
          improvement: '#4da6a6',
          'improvement-bg': '#e0f4f4',
          design: '#c77da3',
          'design-bg': '#fae8f1',
          infra: '#c79b4d',
          'infra-bg': '#faf0dc',
        },
        // Legacy colors for compatibility
        'primary-300': '#3d3d4a',
        'primary-250': '#5a5a6e',
        'primary-200': '#7a7a88',
        'primary-100': '#a0a0aa',
        'primary2-300': '#c6875a',
        'primary2-200': '#d4956a',
        'primary2-100': '#e0a87c',
        'green-300': '#7bb89e',
        'red-200': '#c75c5c',
        'red-50': '#fce8e8',
        'red-100': '#fce8e8',
      },
      fontFamily: {
        'sans': ['"Libre Franklin"', '-apple-system', 'BlinkMacSystemFont', 'sans-serif'],
      },
      boxShadow: {
        'card': '0 1px 3px rgba(0,0,0,0.04)',
        'card-hover': '0 2px 8px rgba(0,0,0,0.08)',
        'panel': '-8px 0 30px rgba(0,0,0,0.06)',
        'cmd': '0 20px 60px rgba(0,0,0,0.1), 0 0 0 1px rgba(212,149,106,0.1)',
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
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5")
          }
        }
      }, {values})
    })
  ]
}
