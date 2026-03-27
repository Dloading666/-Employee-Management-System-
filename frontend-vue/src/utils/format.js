export function formatDate(value, fallback = '-') {
  if (!value) {
    return fallback
  }
  return String(value).slice(0, 10)
}

export function formatTime(value, fallback = '-') {
  if (!value) {
    return fallback
  }
  return String(value).slice(0, 5)
}

export function formatDateTime(value, fallback = '-') {
  if (!value) {
    return fallback
  }
  return String(value).replace('T', ' ').slice(0, 19)
}

export function toDateInputValue(value) {
  return value ? String(value).slice(0, 10) : ''
}

export function toTimeInputValue(value) {
  return value ? String(value).slice(0, 5) : ''
}

export function toNullableNumber(value) {
  if (value === '' || value === null || value === undefined || Number.isNaN(value)) {
    return null
  }
  return Number(value)
}

export function withSeconds(value) {
  if (!value) {
    return null
  }
  return value.length === 5 ? `${value}:00` : value
}
