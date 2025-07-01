// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },
  modules: ['@nuxt/icon', '@nuxt/ui', '@nuxtjs/tailwindcss'],

  // Configuration pour Netlify - génération statique
  nitro: {
    preset: 'static',
    output: {
      dir: 'dist'
    }
  },

  // Force la génération statique pour Netlify
  ssr: false,

  // Redirection automatique vers HTTPS
  runtimeConfig: {
    public: {
      baseURL: process.env.NODE_ENV === 'production' ? 'https://amirtalbi.me' : 'http://localhost:3000'
    }
  }
})