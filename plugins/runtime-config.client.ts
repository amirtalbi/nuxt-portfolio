export default defineNuxtPlugin(() => {
  // S'assurer que la configuration runtime est disponible côté client
  const config = useRuntimeConfig()

  // Vérifier que baseURL est défini
  if (!config.public?.baseURL) {
    console.warn('baseURL not defined in runtime config, using fallback')
    config.public = config.public || {}
    config.public.baseURL = process.env.NODE_ENV === 'production' ? 'https://amirtalbi.me' : 'http://localhost:3000'
  }
})
