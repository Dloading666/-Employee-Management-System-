<script setup>
import { onMounted, reactive, ref } from 'vue'
import UserFormModal from '../components/forms/UserFormModal.vue'
import PageCard from '../components/ui/PageCard.vue'
import PaginationBar from '../components/ui/PaginationBar.vue'
import {
  createUserApi,
  deleteUserApi,
  fetchUsersApi,
  updateUserApi,
} from '../api/users'

const filters = reactive({ name: '' })
const pageState = reactive({
  records: [],
  total: 0,
  pageNum: 1,
  pageSize: 10,
})

const loading = ref(false)
const modalVisible = ref(false)
const editing = ref(false)
const currentUser = ref(null)

function statusText(status) {
  return Number(status) === 1 ? '启用' : '禁用'
}

async function loadUsers(page = pageState.pageNum) {
  loading.value = true
  try {
    const data = await fetchUsersApi({
      name: filters.name || undefined,
      pageNum: page,
      pageSize: pageState.pageSize,
    })
    pageState.records = data.records
    pageState.total = data.total
    pageState.pageNum = data.pageNum
    pageState.pageSize = data.pageSize
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  loadUsers(1)
}

function handleReset() {
  filters.name = ''
  loadUsers(1)
}

function openCreateModal() {
  editing.value = false
  currentUser.value = null
  modalVisible.value = true
}

function openEditModal(user) {
  editing.value = true
  currentUser.value = user
  modalVisible.value = true
}

async function handleSave(payload) {
  try {
    if (editing.value && currentUser.value?.id) {
      await updateUserApi(currentUser.value.id, payload)
      window.alert('保存成功')
    } else {
      await createUserApi(payload)
      window.alert('添加成功')
    }
    modalVisible.value = false
    await loadUsers(editing.value ? pageState.pageNum : 1)
  } catch (error) {
    window.alert(error.message || '操作失败')
  }
}

async function handleDelete(id) {
  if (!window.confirm('确定要删除该用户吗？')) {
    return
  }
  try {
    await deleteUserApi(id)
    window.alert('删除成功')
    await loadUsers(pageState.pageNum)
  } catch (error) {
    window.alert(error.message || '删除失败')
  }
}

onMounted(() => {
  loadUsers()
})
</script>

<template>
  <PageCard>
    <div class="page-headline">
      <div>
        <h3>用户列表</h3>
        <small>管理员端 - 维护系统账号、登录密码和启用状态</small>
      </div>
      <button class="btn btn-brand" type="button" @click="openCreateModal">添加用户</button>
    </div>

    <form class="d-flex flex-wrap align-items-center gap-2 mb-3" @submit.prevent="handleSearch">
      <input
        v-model="filters.name"
        class="form-control form-control-sm search-input"
        placeholder="按用户名搜索"
        type="text"
      />
      <button class="btn btn-brand btn-sm" type="submit">搜索</button>
      <button class="btn btn-light btn-sm border" type="button" @click="handleReset">重置</button>
    </form>

    <div class="table-responsive">
      <table class="table table-bordered table-hover table-sm">
        <thead>
          <tr>
            <th>用户名</th>
            <th>账号</th>
            <th>密码</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td class="text-center text-muted" colspan="5">加载中...</td>
          </tr>
          <tr v-else-if="pageState.records.length === 0">
            <td class="text-center text-muted" colspan="5">暂无用户数据</td>
          </tr>
          <tr v-for="user in pageState.records" :key="user.id">
            <td>{{ user.name || '-' }}</td>
            <td>{{ user.account || '-' }}</td>
            <td>{{ user.passwordMasked || '未设置' }}</td>
            <td>{{ statusText(user.status) }}</td>
            <td>
              <button class="btn btn-sm btn-brand me-2" type="button" @click="openEditModal(user)">编辑</button>
              <button class="btn btn-sm btn-danger" type="button" @click="handleDelete(user.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <PaginationBar :page-num="pageState.pageNum" :page-size="pageState.pageSize" :total="pageState.total" @change="loadUsers" />

    <UserFormModal
      :editing="editing"
      :show="modalVisible"
      :user="currentUser"
      @close="modalVisible = false"
      @submit="handleSave"
    />
  </PageCard>
</template>

<style scoped>
.gap-2 {
  gap: 0.5rem;
}

.search-input {
  width: min(320px, 100%);
}
</style>
