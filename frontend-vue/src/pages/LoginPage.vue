<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { login } from '../stores/auth'

const router = useRouter()
const loading = ref(false)
const errorMessage = ref('')

const form = reactive({
  account: '',
  password: '',
})

async function handleSubmit() {
  if (!form.account.trim() || !form.password) {
    errorMessage.value = '请输入账号和密码'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    await login({
      account: form.account.trim(),
      password: form.password,
    })
    await router.push('/app/welcome')
  } catch (error) {
    errorMessage.value = error.message || '登录失败'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-panel">
      <h3>企业员工管理系统</h3>
      <form @submit.prevent="handleSubmit">
        <div class="mb-3">
          <label class="form-label" for="account">账号</label>
          <input id="account" v-model="form.account" class="form-control" type="text" required />
        </div>
        <div class="mb-3">
          <label class="form-label" for="password">密码</label>
          <input id="password" v-model="form.password" class="form-control" type="password" required />
        </div>
        <div v-if="errorMessage" class="alert alert-danger py-2" role="alert">
          {{ errorMessage }}
        </div>
        <button class="btn btn-brand w-100" type="submit" :disabled="loading">
          {{ loading ? '登录中...' : '登录' }}
        </button>
      </form>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  min-height: 100%;
  background: #f5f5f5;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding: 120px 1rem 2rem;
}

.login-panel {
  width: min(100%, 400px);
  padding: 40px 30px 30px;
  border-radius: 10px;
  background: #fff;
  box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
}

.login-panel h3 {
  margin-bottom: 30px;
  text-align: center;
}
</style>
