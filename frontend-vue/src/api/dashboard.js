import http, { unwrapResponse } from './http'

export async function fetchSummaryApi() {
  return unwrapResponse(await http.get('/api/dashboard/summary'))
}

export async function fetchDeptEmployeeApi() {
  return unwrapResponse(await http.get('/api/dashboard/dept-employee'))
}

export async function fetchAttendanceStatusApi() {
  return unwrapResponse(await http.get('/api/dashboard/attendance-status'))
}

export async function fetchAddLeaveTrendApi() {
  return unwrapResponse(await http.get('/api/dashboard/add-leave-trend'))
}
