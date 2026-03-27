import http, { unwrapResponse } from './http'

export async function fetchProfileApi() {
  return unwrapResponse(await http.get('/api/profile'))
}

export async function createProfileApi(payload) {
  return unwrapResponse(await http.post('/api/profile', payload))
}

export async function updateProfileApi(payload) {
  return unwrapResponse(await http.put('/api/profile', payload))
}
