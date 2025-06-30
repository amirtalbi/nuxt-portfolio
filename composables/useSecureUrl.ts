/**
 * Composable pour gérer les URLs HTTPS en production
 */
export const useSecureUrl = () => {
  const config = useRuntimeConfig()
  
  const getSecureUrl = (path: string = '') => {
    const baseUrl = config.public.baseURL
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
