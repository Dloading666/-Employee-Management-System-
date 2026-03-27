<script setup>
import * as echarts from 'echarts'
import { nextTick, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import PageCard from '../components/ui/PageCard.vue'
import {
  fetchAddLeaveTrendApi,
  fetchAttendanceStatusApi,
  fetchDeptEmployeeApi,
  fetchSummaryApi,
} from '../api/dashboard'

const summary = reactive({
  userCount: '-',
  employeeCount: '-',
  departmentCount: '-',
  todayAttendance: '-',
})

const nowText = ref('')
const trendRef = ref(null)
const deptRef = ref(null)
const attRef = ref(null)

let trendChart
let deptChart
let attChart
let timeTimer
let summaryTimer
let chartTimer

function updateTime() {
  const now = new Date()
  nowText.value = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(
    now.getDate(),
  ).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(
    2,
    '0',
  )}:${String(now.getSeconds()).padStart(2, '0')}`
}

async function loadSummary() {
  Object.assign(summary, await fetchSummaryApi())
}

async function loadCharts() {
  const [trendData, deptData, attData] = await Promise.all([
    fetchAddLeaveTrendApi(),
    fetchDeptEmployeeApi(),
    fetchAttendanceStatusApi(),
  ])

  if (!trendChart && trendRef.value) {
    trendChart = echarts.init(trendRef.value)
  }
  if (!deptChart && deptRef.value) {
    deptChart = echarts.init(deptRef.value)
  }
  if (!attChart && attRef.value) {
    attChart = echarts.init(attRef.value)
  }

  trendChart?.setOption({
    tooltip: { trigger: 'axis' },
    legend: { data: ['新增', '请假'] },
    xAxis: { type: 'category', data: trendData.months },
    yAxis: { type: 'value' },
    series: [
      { name: '新增', type: 'bar', data: trendData.add, itemStyle: { color: '#4caf50' } },
      { name: '请假', type: 'bar', data: trendData.leave, itemStyle: { color: '#ff9800' } },
    ],
  })

  deptChart?.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    legend: { type: 'scroll', orient: 'vertical', left: 0, top: 'middle' },
    series: [
      {
        type: 'pie',
        center: ['65%', '50%'],
        radius: ['40%', '65%'],
        data: deptData,
        label: { formatter: '{b}\n{d}%' },
      },
    ],
  })

  attChart?.setOption({
    tooltip: { trigger: 'item' },
    series: [
      {
        type: 'pie',
        radius: ['40%', '70%'],
        data: attData.map((item) => ({
          ...item,
          name:
            {
              Normal: '正常',
              Late: '迟到',
              'Early Leave': '早退',
              Absent: '缺勤',
              Unknown: '未知',
            }[item.name] || item.name,
        })),
        label: { formatter: '{b}: {d}%' },
      },
    ],
  })
}

function resizeCharts() {
  trendChart?.resize()
  deptChart?.resize()
  attChart?.resize()
}

onMounted(async () => {
  updateTime()
  timeTimer = window.setInterval(updateTime, 1000)

  await nextTick()
  await loadSummary()
  await loadCharts()

  summaryTimer = window.setInterval(loadSummary, 60000)
  chartTimer = window.setInterval(loadCharts, 300000)
  window.addEventListener('resize', resizeCharts)
})

onBeforeUnmount(() => {
  window.clearInterval(timeTimer)
  window.clearInterval(summaryTimer)
  window.clearInterval(chartTimer)
  window.removeEventListener('resize', resizeCharts)
  trendChart?.dispose()
  deptChart?.dispose()
  attChart?.dispose()
})
</script>

<template>
  <div class="d-flex flex-column gap-4">
    <PageCard>
      <div class="row align-items-center">
        <div class="col-lg-8">
          <h2 class="mb-3">欢迎使用企业员工管理系统</h2>
          <p class="text-muted mb-0">Vue 前端正在逐步接管旧版 JSP 页面，当前核心模块已优先迁移。</p>
        </div>
        <div class="col-lg-4 mt-3 mt-lg-0">
          <div class="system-info">
            <h5>系统信息</h5>
            <p class="mb-1">版本：v1.1.0</p>
            <p class="mb-0">当前时间：{{ nowText }}</p>
          </div>
        </div>
      </div>
    </PageCard>

    <div class="row g-3">
      <div class="col-md-6 col-xl-3">
        <div class="stat-card">
          <div class="stat-number text-primary">{{ summary.userCount }}</div>
          <div class="stat-label">系统用户</div>
        </div>
      </div>
      <div class="col-md-6 col-xl-3">
        <div class="stat-card">
          <div class="stat-number text-success">{{ summary.employeeCount }}</div>
          <div class="stat-label">在职员工</div>
        </div>
      </div>
      <div class="col-md-6 col-xl-3">
        <div class="stat-card">
          <div class="stat-number text-warning">{{ summary.departmentCount }}</div>
          <div class="stat-label">部门数量</div>
        </div>
      </div>
      <div class="col-md-6 col-xl-3">
        <div class="stat-card">
          <div class="stat-number text-info">{{ summary.todayAttendance }}</div>
          <div class="stat-label">今日考勤</div>
        </div>
      </div>
    </div>

    <div class="row g-3">
      <div class="col-xl-4">
        <PageCard>
          <h5 class="mb-3 text-center">新增人数 & 请假人数（近 6 个月）</h5>
          <div ref="trendRef" class="chart-panel" />
        </PageCard>
      </div>
      <div class="col-xl-4">
        <PageCard>
          <h5 class="mb-3 text-center">部门人数比例</h5>
          <div ref="deptRef" class="chart-panel" />
        </PageCard>
      </div>
      <div class="col-xl-4">
        <PageCard>
          <h5 class="mb-3 text-center">今日考勤状态</h5>
          <div ref="attRef" class="chart-panel" />
        </PageCard>
      </div>
    </div>
  </div>
</template>

<style scoped>
.gap-4 {
  gap: 1.25rem;
}

.system-info {
  background: linear-gradient(135deg, #5e80e6 0%, #6a63b7 100%);
  color: #fff;
  border-radius: 10px;
  padding: 20px;
}

.stat-card {
  background: #fff;
  border-radius: 10px;
  box-shadow: var(--shadow-card);
  padding: 20px;
  text-align: center;
  transition: transform 0.25s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
}

.stat-number {
  font-size: 2.4rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.stat-label {
  color: var(--text-muted);
  font-size: 0.95rem;
}

.chart-panel {
  height: 280px;
}
</style>
