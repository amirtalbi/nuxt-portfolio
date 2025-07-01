// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },
  modules: ['@nuxt/icon', '@nuxt/ui', '@nuxtjs/tailwindcss'],

  // Configuration pour Netlify
  nitro: {
    preset: 'netlify',
    prerender: {
      routes: ['/']
    }
  },

  // Configuration SPA pour Netlify
  ssr: false,

  // Configuration des variables d'environnement
  runtimeConfig: {
    public: {
      baseURL: process.env.NODE_ENV === 'production' ? 'https://amirtalbi.me' : 'http://localhost:3000'
    }
  },

  // Configuration du CSS
  css: ['~/assets/css/style.css']
})