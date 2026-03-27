<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import PageCard from '../components/ui/PageCard.vue'
import PaginationBar from '../components/ui/PaginationBar.vue'
import { deleteLeaveApi, fetchLeavesApi, updateLeaveBatchStatusApi } from '../api/leaves'
import { useAuthStore } from '../stores/auth'
import { formatDateTime } from '../utils/format'

const auth = useAuthStore()
const route = useRoute()
const router = useRouter()

const filters = reactive({
  employeeName: '',
  tab: 'pending',
})

const pageState = reactive({
  records: [],
  total: 0,
  pageNum: 1,
  pageSize: 10,
})

const loading = ref(false)
const changedStatuses = reactive({})

const approvalMode = computed(() => route.name === 'leave-approval')
const pageTitle = computed(() => (approvalMode.value ? '请假审批' : '我的请假'))
const pageHint = computed(() =>
  approvalMode.value
    ? '管理员可调整审批状态并批量保存变更'
    : '查看自己的请假申请处理进度，审批结果会实时同步',
)

const visibleRecords = computed(() => pageState.records.filter((record) => matchesTab(record.status)))

function matchesTab(status) {
  if (filters.tab === 'pending') {
    return Number(status) === 1
  }
  if (filters.tab === 'approved') {
    return Number(status) === 2 || Number(status) === 3
  }
  return true
}

function statusText(status) {
  if (Number(status) === 1) return '待审核'
  if (Number(status) === 2) return '审批通过'
  if (Number(status) === 3) return '驳回'
  return '未知'
}

async function loadLeaves(page = pageState.pageNum) {
  loading.value = true
  try {
    const data = await fetchLeavesApi({
      employeeName: approvalMode.value ? filters.employeeName || undefined : undefined,
      pageNum: page,
      pageSize: pageState.pageSize,
    })
    pageState.records = data.records
    pageState.total = data.total
    pageState.pageNum = data.pageNum
    pageState.pageSize = data.pageSize
    Object.keys(changedStatuses).forEach((key) => {
      delete changedStatuses[key]
    })
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  loadLeaves(1)
}

function changeTab(tab) {
  filters.tab = tab
}

function pendingValue(record) {
  return changedStatuses[record.id] ?? Number(record.status ?? 1)
}

function markStatusChange(record, value) {
  changedStatuses[record.id] = Number(value)
}

async function handleSaveChanges() {
  const updates = Object.entries(changedStatuses).map(([id, status]) => ({
    id: Number(id),
    status: Number(status),
  }))
  if (updates.length === 0) {
    window.alert('当前没有待保存的状态变更')
    return
  }
  try {
    await updateLeaveBatchStatusApi(updates)
    window.alert('审批结果已保存')
    await loadLeaves(pageState.pageNum)
  } catch (error) {
    window.alert(error.message || '保存失败')
  }
}

async function handleDelete(id) {
  if (!window.confirm('确定要删除这条请假记录吗？')) {
    return
  }
  try {
    await deleteLeaveApi(id)
    window.alert('删除成功')
    await loadLeaves(pageState.pageNum)
  } catch (error) {
    window.alert(error.message || '删除失败')
  }
}

async function jumpToApply() {
  await router.push('/app/leave-apply')
}

onMounted(() => {
  loadLeaves()
})
</script>

<template>
  <PageCard>
    <div class="page-headline">
      <div>
        <h3>{{ pageTitle }}</h3>
        <small>{{ pageHint }}</small>
      </div>
      <div v-if="!approvalMode && !auth.isAdmin.value">
        <button class="btn btn-brand" type="button" @click="jumpToApply">添加请假</button>
      </div>
    </div>

    <div class="tabs-wrap mb-3">
      <button
        class="btn btn-sm me-2"
        :class="filters.tab === 'pending' ? 'btn-brand' : 'btn-outline-secondary'"
        type="button"
        @click="changeTab('pending')"
      >
        未批准列表
      </button>
      <button
        class="btn btn-sm me-2"
        :class="filters.tab === 'approved' ? 'btn-brand' : 'btn-outline-secondary'"
        type="button"
        @click="changeTab('approved')"
      >
        已批准列表
      </button>
      <button
        class="btn btn-sm"
        :class="filters.tab === 'all' ? 'btn-brand' : 'btn-outline-secondary'"
        type="button"
        @click="changeTab('all')"
      >
        请假记录
      </button>
    </div>

    <form
      v-if="approvalMode"
      class="d-flex flex-wrap align-items-center gap-2 mb-3"
      @submit.prevent="handleSearch"
    >
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
            <th>姓名</th>
            <th>请假类型</th>
            <th>开始时间</th>
            <th>结束时间</th>
            <th>事由</th>
            <th>状态</th>
            <th v-if="approvalMode">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td class="text-center text-muted" :colspan="approvalMode ? 7 : 6">加载中...</td>
          </tr>
          <tr v-else-if="visibleRecords.length === 0">
            <td class="text-center text-muted" :colspan="approvalMode ? 7 : 6">暂无请假数据</td>
          </tr>
          <tr v-for="record in visibleRecords" :key="record.id">
            <td>{{ record.userName || '-' }}</td>
            <td>{{ record.leaveTypeCode || '-' }}</td>
            <td>{{ formatDateTime(record.leaveStartTime) }}</td>
            <td>{{ formatDateTime(record.leaveEndTime) }}</td>
            <td class="reason-cell">{{ record.leaveReason || '-' }}</td>
            <td>
              <template v-if="approvalMode">
                <select
                  class="form-select form-select-sm"
                  :value="pendingValue(record)"
                  @change="markStatusChange(record, $event.target.value)"
                >
                  <option :value="1">待审核</option>
                  <option :value="2">审批通过</option>
                  <option :value="3">驳回</option>
                </select>
              </template>
              <span v-else>{{ statusText(record.status) }}</span>
            </td>
            <td v-if="approvalMode">
              <button class="btn btn-sm btn-danger" type="button" @click="handleDelete(record.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="approvalMode" class="text-end mt-3">
      <button class="btn btn-brand btn-sm" type="button" @click="handleSaveChanges">保存修改</button>
    </div>

    <PaginationBar :page-num="pageState.pageNum" :page-size="pageState.pageSize" :total="pageState.total" @change="loadLeaves" />
  </PageCard>
</template>

<style scoped>
.gap-2 {
  gap: 0.5rem;
}

.search-input {
  width: min(280px, 100%);
}

.reason-cell {
  min-width: 220px;
}

.tabs-wrap {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}
</style>
