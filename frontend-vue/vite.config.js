import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

const backendTarget = 'http://localhost:8080'
const sharedProxy = {
  target: backendTarget,
  changeOrigin: true,
  secure: false,
  cookieDomainRewrite: '',
  cookiePathRewrite: '/',
}

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': sharedProxy,
    },
  },
})
