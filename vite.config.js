import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  base: './', // Menambahkan base agar path CSS/JS tidak error saat deploy ke GitHub Pages
  plugins: [vue()],
})
