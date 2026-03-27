import http, { unwrapResponse } from './http'

export async function fetchUsersApi(params) {
  return unwrapResponse(await http.get('/api/users', { params }))
}

export async function createUserApi(payload) {
  return unwrapResponse(await http.post('/api/users', payload))
}

export async function updateUserApi(id, payload) {
  return unwrapResponse(await http.put(`/api/users/${id}`, payload))
}

export async function deleteUserApi(id) {
  return unwrapResponse(await http.delete(`/api/users/${id}`))
}
