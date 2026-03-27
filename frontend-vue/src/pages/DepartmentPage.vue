<script setup>
import { onMounted, reactive, ref } from 'vue'
import DepartmentFormModal from '../components/forms/DepartmentFormModal.vue'
import PageCard from '../components/ui/PageCard.vue'
import PaginationBar from '../components/ui/PaginationBar.vue'
import {
  createDepartmentApi,
  deleteDepartmentApi,
  fetchDepartmentsApi,
  updateDepartmentApi,
} from '../api/departments'

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
const currentDepartment = ref(null)

async function loadDepartments(page = pageState.pageNum) {
  loading.value = true
  try {
    const data = await fetchDepartmentsApi({
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
  loadDepartments(1)
}

function openCreateModal() {
  editing.value = false
  currentDepartment.value = null
  modalVisible.value = true
}

function openEditModal(department) {
  editing.value = true
  currentDepartment.value = department
  modalVisible.value = true
}

async function handleSave(payload) {
  try {
    if (editing.value && currentDepartment.value?.id) {
      await updateDepartmentApi(currentDepartment.value.id, payload)
      window.alert('保存成功')
    } else {
      await createDepartmentApi(payload)
      window.alert('添加成功')
    }
    modalVisible.value = false
    await loadDepartments(editing.value ? pageState.pageNum : 1)
  } catch (error) {
    window.alert(error.message || '操作失败')
  }
}

async function handleDelete(id) {
  if (!window.confirm('确定要删除该部门吗？')) {
    return
  }
  try {
    await deleteDepartmentApi(id)
    window.alert('删除成功')
    await loadDepartments(pageState.pageNum)
  } catch (error) {
    window.alert(error.message || '删除失败')
  }
}

onMounted(() => {
  loadDepartments()
})
</script>

<template>
  <PageCard>
    <div class="page-headline">
      <div>
        <h3>部门列表</h3>
        <small>沿用旧版后台的信息结构和操作顺序</small>
      </div>
      <button class="btn btn-brand" type="button" @click="openCreateModal">添加部门</button>
    </div>

    <form class="d-flex flex-wrap align-items-center gap-2 mb-3" @submit.prevent="handleSearch">
      <input v-model="filters.name" class="form-control form-control-sm search-input" placeholder="部门名称" type="text" />
      <button class="btn btn-brand btn-sm" type="submit">搜索</button>
    </form>

    <div class="table-responsive">
      <table class="table table-bordered table-hover table-sm">
        <thead>
          <tr>
            <th>名称</th>
            <th>负责人 ID</th>
            <th>上级部门 ID</th>
            <th>排序码</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td class="text-center text-muted" colspan="6">加载中...</td>
          </tr>
          <tr v-else-if="pageState.records.length === 0">
            <td class="text-center text-muted" colspan="6">暂无部门数据</td>
          </tr>
          <tr v-for="department in pageState.records" :key="department.id">
            <td>{{ department.name || '-' }}</td>
            <td>{{ department.managerUserId ?? '-' }}</td>
            <td>{{ department.parentId ?? '-' }}</td>
            <td>{{ department.sortCode ?? '-' }}</td>
            <td>{{ department.status ?? '-' }}</td>
            <td>
              <button class="btn btn-sm btn-brand me-2" type="button" @click="openEditModal(department)">编辑</button>
              <button class="btn btn-sm btn-danger" type="button" @click="handleDelete(department.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <PaginationBar :page-num="pageState.pageNum" :page-size="pageState.pageSize" :total="pageState.total" @change="loadDepartments" />

    <DepartmentFormModal
      :department="currentDepartment"
      :editing="editing"
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
