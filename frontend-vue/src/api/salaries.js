import http, { unwrapResponse } from './http'

export async function fetchSalariesApi(params) {
  return unwrapResponse(await http.get('/api/salaries', { params }))
}

export async function fetchMySalariesApi() {
  return unwrapResponse(await http.get('/api/salaries/mine'))
}

export async function createSalaryApi(payload) {
  return unwrapResponse(await http.post('/api/salaries', payload))
}

export async function deleteSalaryApi(id) {
  return unwrapResponse(await http.delete(`/api/salaries/${id}`))
}
