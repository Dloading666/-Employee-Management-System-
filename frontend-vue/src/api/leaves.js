import http, { unwrapResponse } from './http'

export async function fetchLeavesApi(params) {
  return unwrapResponse(await http.get('/api/leaves', { params }))
}

export async function createLeaveApi(payload) {
  return unwrapResponse(await http.post('/api/leaves', payload))
}

export async function updateLeaveStatusApi(id, payload) {
  return unwrapResponse(await http.post(`/api/leaves/${id}/status`, payload))
}

export async function updateLeaveBatchStatusApi(payload) {
  return unwrapResponse(await http.post('/api/leaves/batch-status', payload))
}

export async function deleteLeaveApi(id) {
  return unwrapResponse(await http.delete(`/api/leaves/${id}`))
}
