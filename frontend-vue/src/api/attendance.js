import http, { unwrapResponse } from './http'

export async function fetchAttendanceApi(params) {
  return unwrapResponse(await http.get('/api/attendance', { params }))
}

export async function createAttendanceApi(payload) {
  return unwrapResponse(await http.post('/api/attendance', payload))
}

export async function updateAttendanceApi(id, payload) {
  return unwrapResponse(await http.put(`/api/attendance/${id}`, payload))
}

export async function deleteAttendanceApi(id) {
  return unwrapResponse(await http.delete(`/api/attendance/${id}`))
}

export async function checkInApi() {
  return unwrapResponse(await http.post('/api/attendance/check-in'))
}

export async function checkOutApi() {
  return unwrapResponse(await http.post('/api/attendance/check-out'))
}
