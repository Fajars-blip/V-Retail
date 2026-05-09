/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        brand: {
          DEFAULT: '#6c5ce7',
          dark: '#5849c4',
          soft: '#f4f1ff'
        }
      },
      boxShadow: {
        soft: '0 12px 40px rgba(29, 33, 41, 0.08)'
      }
    }
  },
  plugins: []
}