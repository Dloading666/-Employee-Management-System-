import http, { unwrapResponse } from './http'

export async function fetchDepartmentsApi(params) {
  return unwrapResponse(await http.get('/api/departments', { params }))
}

export async function createDepartmentApi(payload) {
  return unwrapResponse(await http.post('/api/departments', payload))
}

export async function updateDepartmentApi(id, payload) {
  return unwrapResponse(await http.put(`/api/departments/${id}`, payload))
}

export async function deleteDepartmentApi(id) {
  return unwrapResponse(await http.delete(`/api/departments/${id}`))
}
