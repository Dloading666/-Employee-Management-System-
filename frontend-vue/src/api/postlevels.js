import http, { unwrapResponse } from './http'

export async function fetchPostLevelsApi(params) {
  return unwrapResponse(await http.get('/api/postlevels', { params }))
}

export async function createPostLevelApi(payload) {
  return unwrapResponse(await http.post('/api/postlevels', payload))
}

export async function updatePostLevelApi(id, payload) {
  return unwrapResponse(await http.put(`/api/postlevels/${id}`, payload))
}

export async function deletePostLevelApi(id) {
  return unwrapResponse(await http.delete(`/api/postlevels/${id}`))
}
