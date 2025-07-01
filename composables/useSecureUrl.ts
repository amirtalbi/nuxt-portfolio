/**
 * Composable pour gérer les URLs HTTPS en production
 */
export const useSecureUrl = () => {
  const config = useRuntimeConfig()

  const getSecureUrl = (path: string = '') => {
    // Fallback si baseURL n'est pas défini
    const baseUrl = config.public?.baseURL || (process.env.NODE_ENV === 'production' ? 'https://amirtalbi.me' : 'http://localhost:3000')
    return `${baseUrl}${path}`
  }

  const forceHttps = () => {
    if (process.client && process.env.NODE_ENV === 'production') {
      if (location.protocol !== 'https:') {
        location.replace(`https:${location.href.substring(location.protocol.length)}`)
      }
    }
  }

  return {
    getSecureUrl,
    forceHttps
  }
}
