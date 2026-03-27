<script setup>
import { reactive, watch } from 'vue'
import BaseModal from '../ui/BaseModal.vue'
import { toNullableNumber } from '../../utils/format'

const props = defineProps({
  show: { type: Boolean, default: false },
  user: { type: Object, default: null },
  editing: { type: Boolean, default: false },
})

const emit = defineEmits(['close', 'submit'])

function createEmptyUser() {
  return {
    name: '',
    account: '',
    password: '',
    status: 1,
  }
}

const form = reactive(createEmptyUser())

function syncForm() {
  const user = props.user || {}
  Object.assign(form, createEmptyUser(), {
    ...user,
    password: '',
  })
}

watch(() => props.show, (visible) => {
  if (visible) {
    syncForm()
  }
}, { immediate: true })

watch(() => props.user, () => {
  if (props.show) {
    syncForm()
  }
})

function handleSubmit() {
  emit('submit', {
    name: form.name.trim(),
    account: form.account.trim(),
    password: form.password,
    status: toNullableNumber(form.status),
  })
}
</script>

<template>
  <BaseModal :show="show" :title="editing ? '编辑用户' : '添加用户'" @close="emit('close')">
    <form class="row g-3" @submit.prevent="handleSubmit">
      <div class="col-12">
        <label class="form-label">用户名</label>
        <input v-model="form.name" class="form-control" type="text" required />
      </div>
      <div class="col-12">
        <label class="form-label">账号</label>
        <input v-model="form.account" class="form-control" type="text" required />
      </div>
      <div class="col-12">
        <label class="form-label">{{ editing ? '新密码' : '密码' }}</label>
        <input
          v-model="form.password"
          class="form-control"
          :placeholder="editing ? '留空则保持原密码' : '请输入登录密码'"
          type="password"
          :required="!editing"
        />
        <div v-if="editing" class="form-hint mt-1">编辑时不填密码，会保留原来的登录密码。</div>
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
