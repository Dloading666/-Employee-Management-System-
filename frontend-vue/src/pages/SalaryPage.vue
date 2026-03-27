<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import SalaryFormModal from '../components/forms/SalaryFormModal.vue'
import PageCard from '../components/ui/PageCard.vue'
import { createSalaryApi, deleteSalaryApi, fetchMySalariesApi, fetchSalariesApi } from '../api/salaries'
import { formatDateTime } from '../utils/format'

const route = useRoute()

const filters = reactive({
  userName: '',
  payMonth: '',
})

const records = ref([])
const loading = ref(false)
const modalVisible = ref(false)

const adminMode = computed(() => route.name === 'salary-admin')
const pageTitle = computed(() => (adminMode.value ? '薪资发放记录' : '我的薪资'))
const pageHint = computed(() =>
  adminMode.value
    ? '管理员可以创建和删除发放记录，按员工和月份快速检索'
    : '查看自己的薪资发放明细与备注信息',
)

async function loadSalaries() {
  loading.value = true
  try {
    records.value = adminMode.value
      ? await fetchSalariesApi({
        userName: filters.userName || undefined,
        payMonth: filters.payMonth || undefined,
      })
      : await fetchMySalariesApi()
  } finally {
    loading.value = false
  }
}

function openCreateModal() {
  modalVisible.value = true
}

async function handleSave(payload) {
  try {
    await createSalaryApi(payload)
    modalVisible.value = false
    window.alert('发放记录已创建')
    await loadSalaries()
  } catch (error) {
    window.alert(error.message || '创建失败')
  }
}

async function handleDelete(id) {
  if (!window.confirm('确定要删除这条薪资记录吗？')) {
    return
  }
  try {
    await deleteSalaryApi(id)
    window.alert('删除成功')
    await loadSalaries()
  } catch (error) {
    window.alert(error.message || '删除失败')
  }
}

function handleReset() {
  filters.userName = ''
  filters.payMonth = ''
  loadSalaries()
}

onMounted(() => {
  loadSalaries()
})
</script>

<template>
  <PageCard>
    <div class="page-headline">
      <div>
        <h3>{{ pageTitle }}</h3>
        <small>{{ pageHint }}</small>
      </div>
      <button v-if="adminMode" class="btn btn-brand" type="button" @click="openCreateModal">新建发放记录</button>
    </div>

    <form
      v-if="adminMode"
      class="d-flex flex-wrap align-items-center gap-2 mb-3"
      @submit.prevent="loadSalaries"
    >
      <input
        v-model="filters.userName"
        class="form-control form-control-sm search-input"
        placeholder="员工姓名"
        type="text"
      />
      <input v-model="filters.payMonth" class="form-control form-control-sm month-input" type="month" />
      <button class="btn btn-brand btn-sm" type="submit">搜索</button>
      <button class="btn btn-light btn-sm border" type="button" @click="handleReset">重置</button>
    </form>

    <div class="table-responsive">
      <table class="table table-bordered table-hover table-sm">
        <thead>
          <tr>
            <th v-if="adminMode">员工姓名</th>
            <th>发放月份</th>
            <th>金额</th>
            <th>备注</th>
            <th>发放时间</th>
            <th v-if="adminMode">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td class="text-center text-muted" :colspan="adminMode ? 6 : 4">加载中...</td>
          </tr>
          <tr v-else-if="records.length === 0">
            <td class="text-center text-muted" :colspan="adminMode ? 6 : 4">暂无薪资记录</td>
          </tr>
          <tr v-for="record in records" :key="record.id">
            <td v-if="adminMode">{{ record.userName || '-' }}</td>
            <td>{{ record.payMonth || '-' }}</td>
            <td>{{ record.amount ?? '-' }}</td>
            <td>{{ record.remark || '-' }}</td>
            <td>{{ formatDateTime(record.createTime) }}</td>
            <td v-if="adminMode">
              <button class="btn btn-sm btn-danger" type="button" @click="handleDelete(record.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <SalaryFormModal :show="modalVisible" @close="modalVisible = false" @submit="handleSave" />
  </PageCard>
</template>

<style scoped>
.gap-2 {
  gap: 0.5rem;
}

.search-input {
  width: min(220px, 100%);
}

.month-input {
  width: 180px;
}
</style>
