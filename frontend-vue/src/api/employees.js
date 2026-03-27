import http, { unwrapResponse } from './http'

export async function fetchEmployeesApi(params) {
  return unwrapResponse(await http.get('/api/employees', { params }))
}

export async function createEmployeeApi(payload) {
  return unwrapResponse(await http.post('/api/employees', payload))
}

export async function updateEmployeeApi(id, payload) {
  return unwrapResponse(await http.put(`/api/employees/${id}`, payload))
}

export async function deleteEmployeeApi(id) {
  return unwrapResponse(await http.delete(`/api/employees/${id}`))
}
