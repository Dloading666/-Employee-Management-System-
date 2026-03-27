import { computed, reactive, readonly } from 'vue'
import { fetchCurrentUserApi, loginApi, logoutApi } from '../api/auth'

const authState = reactive({
  user: null,
  isAdmin: false,
  initialized: false,
})

function setSession(payload) {
  authState.user = payload?.user ?? null
  authState.isAdmin = Boolean(payload?.isAdmin)
}

export async function restoreAuth() {
  if (authState.initialized) {
    return readonly(authState)
  }

  try {
    const payload = await fetchCurrentUserApi()
    setSession(payload)
  } catch (error) {
    authState.user = null
    authState.isAdmin = false
  } finally {
    authState.initialized = true
  }

  return readonly(authState)
}

export async function login(credentials) {
  const payload = await loginApi(credentials)
  setSession(payload)
  authState.initialized = true
  return readonly(authState)
}

export async function logout() {
  try {
    await logoutApi()
  } finally {
    authState.user = null
    authState.isAdmin = false
    authState.initialized = true
  }
}

export function useAuthStore() {
  return {
    state: readonly(authState),
    user: computed(() => authState.user),
    isAdmin: computed(() => authState.isAdmin),
    isLoggedIn: computed(() => Boolean(authState.user)),
    initialized: computed(() => authState.initialized),
  }
}
