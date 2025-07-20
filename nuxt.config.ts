// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },
  modules: ['@nuxt/icon', '@nuxt/ui', '@nuxtjs/tailwindcss'],

  // Configuration du CSS
  css: ['~/assets/css/style.css'],

  // Variables d'environnement runtime
  runtimeConfig: {
    // Variables côté serveur uniquement
    private: {},
    // Variables publiques (exposées côté client)
    public: {
      // En production Docker, utiliser le nom du service backend
      apiUrl: process.env.API_URL || 'http://backend:3001'
    }
  },

  // Configuration SSR
  ssr: true,

  // Configuration des routes
  nitro: {
    preset: 'node-server'
  }
})