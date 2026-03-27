<script setup>
import { reactive, watch } from 'vue'
import BaseModal from '../ui/BaseModal.vue'
import { toNullableNumber } from '../../utils/format'

const props = defineProps({
  show: { type: Boolean, default: false },
  department: { type: Object, default: null },
  editing: { type: Boolean, default: false },
})

const emit = defineEmits(['close', 'submit'])

function createEmptyDepartment() {
  return {
    name: '',
    managerUserId: '',
    parentId: '',
    sortCode: '',
    status: 1,
  }
}

const form = reactive(createEmptyDepartment())

function syncForm() {
  Object.assign(form, createEmptyDepartment(), props.department || {})
}

watch(() => props.show, (visible) => {
  if (visible) {
    syncForm()
  }
}, { immediate: true })

watch(() => props.department, () => {
  if (props.show) {
    syncForm()
  }
})

function handleSubmit() {
  emit('submit', {
    name: form.name.trim(),
    managerUserId: toNullableNumber(form.managerUserId),
    parentId: toNullableNumber(form.parentId),
    sortCode: toNullableNumber(form.sortCode),
    status: toNullableNumber(form.status),
  })
}
</script>

<template>
  <BaseModal :show="show" :title="editing ? '编辑部门' : '添加部门'" @close="emit('close')">
    <form class="row g-3" @submit.prevent="handleSubmit">
      <div class="col-12">
        <label class="form-label">部门名称</label>
        <input v-model="form.name" class="form-control" type="text" required />
      </div>
      <div class="col-12">
        <label class="form-label">负责人用户 ID</label>
        <input v-model="form.managerUserId" class="form-control" type="number" />
      </div>
      <div class="col-12">
        <label class="form-label">上级部门 ID</label>
        <input v-model="form.parentId" class="form-control" type="number" />
      </div>
      <div class="col-12">
        <label class="form-label">排序码</label>
        <input v-model="form.sortCode" class="form-control" type="number" />
      </div>
      <div class="col-12">
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
