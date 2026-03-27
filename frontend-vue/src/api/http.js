import axios from 'axios'

const http = axios.create({
  baseURL: '/',
  timeout: 15000,
  withCredentials: true,
})

export function unwrapResponse(response) {
  const payload = response.data
  if (!payload || payload.code !== 200) {
    const error = new Error(payload?.msg || 'Request failed')
    error.payload = payload
    throw error
  }
  return payload.data
}

export default http
