<script setup>
import { reactive, watch } from 'vue'
import BaseModal from '../ui/BaseModal.vue'
import { toNullableNumber } from '../../utils/format'

const props = defineProps({
  show: { type: Boolean, default: false },
  postLevel: { type: Object, default: null },
  editing: { type: Boolean, default: false },
})

const emit = defineEmits(['close', 'submit'])

function createEmptyPostLevel() {
  return {
    name: '',
    level: '',
    salary: '',
    sortCode: '',
    status: 1,
  }
}

const form = reactive(createEmptyPostLevel())

function syncForm() {
  const postLevel = props.postLevel || {}
  Object.assign(form, createEmptyPostLevel(), postLevel)
}

watch(() => props.show, (visible) => {
  if (visible) {
    syncForm()
  }
}, { immediate: true })

watch(() => props.postLevel, () => {
  if (props.show) {
    syncForm()
  }
})

function handleSubmit() {
  emit('submit', {
    name: form.name.trim(),
    level: toNullableNumber(form.level),
    salary: form.salary === '' || form.salary === null ? null : Number(form.salary),
    sortCode: toNullableNumber(form.sortCode),
    status: toNullableNumber(form.status),
  })
}
</script>

<template>
  <BaseModal :show="show" :title="editing ? '编辑岗位' : '添加岗位'" @close="emit('close')">
    <form class="row g-3" @submit.prevent="handleSubmit">
      <div class="col-12">
        <label class="form-label">岗位名称</label>
        <input v-model="form.name" class="form-control" type="text" required />
      </div>
      <div class="col-md-6">
        <label class="form-label">岗位级别</label>
        <input v-model="form.level" class="form-control" type="number" />
      </div>
      <div class="col-md-6">
        <label class="form-label">薪资</label>
        <input v-model="form.salary" class="form-control" step="0.01" type="number" />
      </div>
      <div class="col-md-6">
        <label class="form-label">排序码</label>
        <input v-model="form.sortCode" class="form-control" type="number" />
      </div>
      <div class="col-md-6">
        <label class="form-label">状态</label>
        <select v-model="form.status" class="form-select">
          <option :value="1">启用</option>
          <option :value="0">禁用</option>
        </select>
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
