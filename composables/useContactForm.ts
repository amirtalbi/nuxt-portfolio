import { ref, readonly } from 'vue'

export const useContactForm = () => {
  const config = useRuntimeConfig()
  const isLoading = ref(false)
  const error = ref('')
  const success = ref(false)

  const sendEmail = async (formData: {
    name: string
    email: string
    message: string
  }) => {
    isLoading.value = true
    error.value = ''
    success.value = false

    try {
      // Validation côté client
      if (!formData.name || !formData.email || !formData.message) {
        throw new Error('Tous les champs sont requis')
      }

      if (formData.name.length > 100) {
        throw new Error('Le nom ne peut pas dépasser 100 caractères')
      }

      if (formData.email.length > 255) {
        throw new Error('L\'email ne peut pas dépasser 255 caractères')
      }

      if (formData.message.length > 2000) {
        throw new Error('Le message ne peut pas dépasser 2000 caractères')
      }

      // Validation email
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!emailRegex.test(formData.email)) {
        throw new Error('Format d\'email invalide')
      }

      // Construire l'URL de l'API
      const apiUrl = config.public.apiUrl
      const baseURL = apiUrl || '' // Utiliser une URL relative si apiUrl est vide
      
      const response = await $fetch('/api/contact', {
        method: 'POST',
        baseURL: baseURL,
        body: formData,
        headers: {
          'Content-Type': 'application/json'
        }
      })

      if (response.success) {
        success.value = true
        return response
      } else {
        throw new Error(response.error || 'Erreur lors de l\'envoi du message')
      }
    } catch (err: any) {
      console.error('Error sending email:', err)
      
      // Gestion des erreurs spécifiques
      if (err.statusCode === 429) {
        error.value = 'Trop de tentatives d\'envoi. Veuillez réessayer dans 15 minutes.'
      } else if (err.statusCode === 400) {
        error.value = err.data?.error || 'Données invalides'
      } else if (err.statusCode >= 500) {
        error.value = 'Erreur du serveur. Veuillez réessayer plus tard.'
      } else {
        error.value = err.message || 'Erreur lors de l\'envoi du message'
      }
      
      throw err
    } finally {
      isLoading.value = false
    }
  }

  const resetForm = () => {
    error.value = ''
    success.value = false
    isLoading.value = false
  }

  return {
    isLoading: readonly(isLoading),
    error: readonly(error),
    success: readonly(success),
    sendEmail,
    resetForm
  }
}
