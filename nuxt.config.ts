// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },
  modules: ['@nuxt/icon', '@nuxt/ui', '@nuxtjs/tailwindcss'],

  // Configuration du CSS
  css: ['~/assets/css/style.css'],

  // Configuration SSR
  ssr: true,

  // Configuration des routes
  nitro: {
    preset: 'node-server'
  }
})