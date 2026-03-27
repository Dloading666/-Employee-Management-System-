import http, { unwrapResponse } from './http'

export async function loginApi(payload) {
  return unwrapResponse(await http.post('/api/auth/login', payload))
}

export async function logoutApi() {
  return unwrapResponse(await http.post('/api/auth/logout'))
}

export async function fetchCurrentUserApi() {
  return unwrapResponse(await http.get('/api/auth/me'))
}
