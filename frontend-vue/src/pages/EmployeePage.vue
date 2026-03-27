<script setup>
import { onMounted, reactive, ref } from 'vue'
import EmployeeFormModal from '../components/forms/EmployeeFormModal.vue'
import PageCard from '../components/ui/PageCard.vue'
import PaginationBar from '../components/ui/PaginationBar.vue'
import {
  createEmployeeApi,
  deleteEmployeeApi,
  fetchEmployeesApi,
  updateEmployeeApi,
} from '../api/employees'
import { formatDate } from '../utils/format'

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
const currentEmployee = ref(null)

async function loadEmployees(page = pageState.pageNum) {
  loading.value = true
  try {
    const data = await fetchEmployeesApi({
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
  loadEmployees(1)
}

function handleReset() {
  filters.name = ''
  loadEmployees(1)
}

function openCreateModal() {
  editing.value = false
  currentEmployee.value = null
  modalVisible.value = true
}

function openEditModal(employee) {
  editing.value = true
  currentEmployee.value = employee
  modalVisible.value = true
}

async function handleSave(payload) {
  try {
    if (editing.value && currentEmployee.value?.id) {
      await updateEmployeeApi(currentEmployee.value.id, payload)
      window.alert('保存成功')
    } else {
      await createEmployeeApi(payload)
      window.alert('添加成功')
    }
    modalVisible.value = false
    await loadEmployees(editing.value ? pageState.pageNum : 1)
  } catch (error) {
    window.alert(error.message || '操作失败')
  }
}

async function handleDelete(id) {
  if (!window.confirm('确定要删除该员工吗？')) {
    return
  }
  try {
    await deleteEmployeeApi(id)
    window.alert('删除成功')
    await loadEmployees(pageState.pageNum)
  } catch (error) {
    window.alert(error.message || '删除失败')
  }
}

onMounted(() => {
  loadEmployees()
})
</script>

<template>
  <PageCard>
    <div class="page-headline">
      <div>
        <h3>员工列表</h3>
        <small>管理员端 · 查看与管理所有在职 / 离职员工信息</small>
      </div>
      <button class="btn btn-brand" type="button" @click="openCreateModal">添加员工</button>
    </div>

    <form class="d-flex flex-wrap align-items-center gap-2 mb-3" @submit.prevent="handleSearch">
      <input
        v-model="filters.name"
        class="form-control form-control-sm search-input"
        placeholder="按姓名搜索员工"
        type="text"
      />
      <button class="btn btn-brand btn-sm" type="submit">搜索</button>
      <button class="btn btn-light btn-sm border" type="button" @click="handleReset">重置</button>
    </form>

    <div class="table-responsive">
      <table class="table table-bordered table-hover table-sm">
        <thead>
          <tr>
            <th>姓名</th>
            <th>工号</th>
            <th>入职日期</th>
            <th>角色类型</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td class="text-center text-muted" colspan="6">加载中...</td>
          </tr>
          <tr v-else-if="pageState.records.length === 0">
            <td class="text-center text-muted" colspan="6">暂无员工数据</td>
          </tr>
          <tr v-for="employee in pageState.records" :key="employee.id">
            <td>{{ employee.name || '-' }}</td>
            <td>{{ employee.code || '-' }}</td>
            <td>{{ formatDate(employee.entryDate) }}</td>
            <td>{{ employee.roleType ?? '-' }}</td>
            <td>{{ employee.status ?? '-' }}</td>
            <td>
              <button class="btn btn-sm btn-brand me-2" type="button" @click="openEditModal(employee)">编辑</button>
              <button class="btn btn-sm btn-danger" type="button" @click="handleDelete(employee.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <PaginationBar :page-num="pageState.pageNum" :page-size="pageState.pageSize" :total="pageState.total" @change="loadEmployees" />

    <EmployeeFormModal
      :editing="editing"
      :employee="currentEmployee"
      :show="modalVisible"
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
