<script setup>
import { reactive, watch } from 'vue'
import BaseModal from '../ui/BaseModal.vue'

const props = defineProps({
  show: { type: Boolean, default: false },
})

const emit = defineEmits(['close', 'submit'])

function createEmptySalary() {
  return {
    userName: '',
    payMonth: '',
    amount: '',
    remark: '',
  }
}

const form = reactive(createEmptySalary())

watch(() => props.show, (visible) => {
  if (visible) {
    Object.assign(form, createEmptySalary())
  }
}, { immediate: true })

function handleSubmit() {
  emit('submit', {
    userName: form.userName.trim(),
    payMonth: form.payMonth,
    amount: form.amount === '' ? null : Number(form.amount),
    remark: form.remark || null,
  })
}
</script>

<template>
  <BaseModal :show="show" title="新建发放记录" @close="emit('close')">
    <form class="row g-3" @submit.prevent="handleSubmit">
      <div class="col-12">
        <label class="form-label">员工姓名</label>
        <input v-model="form.userName" class="form-control" type="text" required />
      </div>
      <div class="col-12">
        <label class="form-label">发放月份</label>
        <input v-model="form.payMonth" class="form-control" type="month" required />
      </div>
      <div class="col-12">
        <label class="form-label">金额</label>
        <input v-model="form.amount" class="form-control" min="0" step="0.01" type="number" required />
      </div>
      <div class="col-12">
        <label class="form-label">备注</label>
        <textarea v-model="form.remark" class="form-control" rows="3" />
      </div>
    </form>

    <template #footer>
      <div class="d-flex justify-content-end gap-2">
        <button class="btn btn-secondary me-2" type="button" @click="emit('close')">取消</button>
        <button class="btn btn-brand" type="button" @click="handleSubmit">保存</button>
      </div>
    </template>
  </BaseModal>
</template>
