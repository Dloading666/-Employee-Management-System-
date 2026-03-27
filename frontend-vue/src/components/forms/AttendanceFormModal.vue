<script setup>
import { computed, reactive, watch } from 'vue'
import BaseModal from '../ui/BaseModal.vue'
import { toDateInputValue, toNullableNumber, toTimeInputValue, withSeconds } from '../../utils/format'

const props = defineProps({
  show: { type: Boolean, default: false },
  attendance: { type: Object, default: null },
  editing: { type: Boolean, default: false },
})

const emit = defineEmits(['close', 'submit'])

function createEmptyAttendance() {
  return {
    userId: '',
    userName: '',
    attendanceDate: '',
    checkInTime: '',
    checkOutTime: '',
    status: 0,
    remark: '',
  }
}

const form = reactive(createEmptyAttendance())

function syncForm() {
  const attendance = props.attendance || {}
  Object.assign(form, createEmptyAttendance(), {
    ...attendance,
    attendanceDate: toDateInputValue(attendance.attendanceDate),
    checkInTime: toTimeInputValue(attendance.checkInTime),
    checkOutTime: toTimeInputValue(attendance.checkOutTime),
  })
}

watch(() => props.show, (visible) => {
  if (visible) {
    syncForm()
  }
}, { immediate: true })

watch(() => props.attendance, () => {
  if (props.show) {
    syncForm()
  }
})

const timeDisabled = computed(() => Number(form.status) === 3)

function handleSubmit() {
  emit('submit', {
    userId: toNullableNumber(form.userId),
    userName: form.userName.trim(),
    attendanceDate: form.attendanceDate || null,
    checkInTime: timeDisabled.value ? null : withSeconds(form.checkInTime),
    checkOutTime: timeDisabled.value ? null : withSeconds(form.checkOutTime),
    status: toNullableNumber(form.status),
    remark: form.remark || null,
  })
}
</script>

<template>
  <BaseModal :show="show" :title="editing ? '编辑考勤记录' : '添加考勤记录'" @close="emit('close')">
    <form class="row g-3" @submit.prevent="handleSubmit">
      <div class="col-12">
        <label class="form-label">用户 ID</label>
        <input v-model="form.userId" class="form-control" type="number" required />
      </div>
      <div class="col-12">
        <label class="form-label">员工姓名</label>
        <input v-model="form.userName" class="form-control" type="text" required />
      </div>
      <div class="col-12">
        <label class="form-label">考勤日期</label>
        <input v-model="form.attendanceDate" class="form-control" type="date" required />
      </div>
      <div class="col-md-6">
        <label class="form-label">签到时间</label>
        <input v-model="form.checkInTime" :disabled="timeDisabled" class="form-control" type="time" />
      </div>
      <div class="col-md-6">
        <label class="form-label">签退时间</label>
        <input v-model="form.checkOutTime" :disabled="timeDisabled" class="form-control" type="time" />
      </div>
      <div class="col-12">
        <label class="form-label">状态</label>
        <select v-model="form.status" class="form-select">
          <option :value="0">正常</option>
          <option :value="1">迟到</option>
          <option :value="2">早退</option>
          <option :value="3">缺勤</option>
        </select>
      </div>
      <div class="col-12">
        <label class="form-label">备注</label>
        <textarea v-model="form.remark" class="form-control" rows="2" />
      </div>
    </form>

    <template #footer>
      <div class="d-flex justify-content-end gap-2">
        <button class="btn btn-secondary me-2" type="button" @click="emit('close')">取消</button>
        <button class="btn btn-brand" type="button" @click="handleSubmit">
          {{ editing ? '保存' : '提交' }}
        </button>
      </div>
    </template>
  </BaseModal>
</template>
