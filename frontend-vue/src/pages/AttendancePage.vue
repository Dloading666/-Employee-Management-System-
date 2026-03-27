<script setup>
import { onMounted, reactive, ref } from 'vue'
import AttendanceFormModal from '../components/forms/AttendanceFormModal.vue'
import PageCard from '../components/ui/PageCard.vue'
import PaginationBar from '../components/ui/PaginationBar.vue'
import {
  checkInApi,
  checkOutApi,
  createAttendanceApi,
  deleteAttendanceApi,
  fetchAttendanceApi,
  updateAttendanceApi,
} from '../api/attendance'
import { useAuthStore } from '../stores/auth'
import { formatDate, formatTime } from '../utils/format'

const auth = useAuthStore()

const filters = reactive({ employeeName: '' })
const pageState = reactive({
  records: [],
  total: 0,
  pageNum: 1,
  pageSize: 10,
})

const loading = ref(false)
const modalVisible = ref(false)
const editing = ref(false)
const currentAttendance = ref(null)

const statusText = {
  0: '正常',
  1: '迟到',
  2: '早退',
  3: '缺勤',
}

async function loadAttendance(page = pageState.pageNum) {
  loading.value = true
  try {
    const data = await fetchAttendanceApi({
      employeeName: filters.employeeName || undefined,
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
  loadAttendance(1)
}

function openCreateModal() {
  editing.value = false
  currentAttendance.value = null
  modalVisible.value = true
}

function openEditModal(record) {
  editing.value = true
  currentAttendance.value = record
  modalVisible.value = true
}

async function handleSave(payload) {
  try {
    if (editing.value && currentAttendance.value?.id) {
      await updateAttendanceApi(currentAttendance.value.id, payload)
      window.alert('保存成功')
    } else {
      await createAttendanceApi(payload)
      window.alert('添加成功')
    }
    modalVisible.value = false
    await loadAttendance(editing.value ? pageState.pageNum : 1)
  } catch (error) {
    window.alert(error.message || '操作失败')
  }
}

async function handleDelete(id) {
  if (!window.confirm('确定要删除该考勤记录吗？')) {
    return
  }
  try {
    await deleteAttendanceApi(id)
    window.alert('删除成功')
    await loadAttendance(pageState.pageNum)
  } catch (error) {
    window.alert(error.message || '删除失败')
  }
}

async function handleCheckIn() {
  try {
    const message = await checkInApi()
    window.alert(message)
    await loadAttendance(1)
  } catch (error) {
    window.alert(error.message || '签到失败')
  }
}

async function handleCheckOut() {
  try {
    const message = await checkOutApi()
    window.alert(message)
    await loadAttendance(1)
  } catch (error) {
    window.alert(error.message || '签退失败')
  }
}

onMounted(() => {
  loadAttendance()
})
</script>

<template>
  <PageCard>
    <div class="page-headline">
      <div>
        <h3>考勤记录列表</h3>
        <small>{{ auth.isAdmin.value ? '管理员可新增 / 编辑 / 删除记录' : '普通员工可查看自己的考勤并执行签到签退' }}</small>
      </div>
      <div>
        <button v-if="auth.isAdmin.value" class="btn btn-brand" type="button" @click="openCreateModal">添加考勤</button>
        <div v-else class="d-flex gap-2">
          <button class="btn btn-brand me-2" type="button" @click="handleCheckIn">签到</button>
          <button class="btn btn-brand" type="button" @click="handleCheckOut">签退</button>
        </div>
      </div>
    </div>

    <form class="d-flex flex-wrap align-items-center gap-2 mb-3" @submit.prevent="handleSearch">
      <input
        v-model="filters.employeeName"
        class="form-control form-control-sm search-input"
        placeholder="员工姓名"
        type="text"
      />
      <button class="btn btn-brand btn-sm" type="submit">搜索</button>
    </form>

    <div class="table-responsive">
      <table class="table table-bordered table-hover table-sm">
        <thead>
          <tr>
            <th>员工姓名</th>
            <th>考勤日期</th>
            <th>签到时间</th>
            <th>签退时间</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td class="text-center text-muted" colspan="6">加载中...</td>
          </tr>
          <tr v-else-if="pageState.records.length === 0">
            <td class="text-center text-muted" colspan="6">暂无考勤数据</td>
          </tr>
          <tr v-for="record in pageState.records" :key="record.id">
            <td>{{ record.userName || '-' }}</td>
            <td>{{ formatDate(record.attendanceDate) }}</td>
            <td>{{ formatTime(record.checkInTime) }}</td>
            <td>{{ formatTime(record.checkOutTime) }}</td>
            <td>{{ statusText[record.status] || '未知' }}</td>
            <td>
              <template v-if="auth.isAdmin.value">
                <button class="btn btn-sm btn-brand me-2" type="button" @click="openEditModal(record)">编辑</button>
                <button class="btn btn-sm btn-danger" type="button" @click="handleDelete(record.id)">删除</button>
              </template>
              <span v-else class="text-muted">-</span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <PaginationBar :page-num="pageState.pageNum" :page-size="pageState.pageSize" :total="pageState.total" @change="loadAttendance" />

    <AttendanceFormModal
      :attendance="currentAttendance"
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
