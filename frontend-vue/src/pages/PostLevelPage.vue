<script setup>
import { onMounted, reactive, ref } from 'vue'
import PostLevelFormModal from '../components/forms/PostLevelFormModal.vue'
import PageCard from '../components/ui/PageCard.vue'
import PaginationBar from '../components/ui/PaginationBar.vue'
import {
  createPostLevelApi,
  deletePostLevelApi,
  fetchPostLevelsApi,
  updatePostLevelApi,
} from '../api/postlevels'

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
const currentPostLevel = ref(null)

function statusText(status) {
  return Number(status) === 1 ? '启用' : '禁用'
}

async function loadPostLevels(page = pageState.pageNum) {
  loading.value = true
  try {
    const data = await fetchPostLevelsApi({
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
  loadPostLevels(1)
}

function handleReset() {
  filters.name = ''
  loadPostLevels(1)
}

function openCreateModal() {
  editing.value = false
  currentPostLevel.value = null
  modalVisible.value = true
}

function openEditModal(postLevel) {
  editing.value = true
  currentPostLevel.value = postLevel
  modalVisible.value = true
}

async function handleSave(payload) {
  try {
    if (editing.value && currentPostLevel.value?.id) {
      await updatePostLevelApi(currentPostLevel.value.id, payload)
      window.alert('保存成功')
    } else {
      await createPostLevelApi(payload)
      window.alert('添加成功')
    }
    modalVisible.value = false
    await loadPostLevels(editing.value ? pageState.pageNum : 1)
  } catch (error) {
    window.alert(error.message || '操作失败')
  }
}

async function handleDelete(id) {
  if (!window.confirm('确定要删除该岗位吗？')) {
    return
  }
  try {
    await deletePostLevelApi(id)
    window.alert('删除成功')
    await loadPostLevels(pageState.pageNum)
  } catch (error) {
    window.alert(error.message || '删除失败')
  }
}

onMounted(() => {
  loadPostLevels()
})
</script>

<template>
  <PageCard>
    <div class="page-headline">
      <div>
        <h3>岗位列表</h3>
        <small>管理员端 - 维护岗位级别、薪资和启用状态</small>
      </div>
      <button class="btn btn-brand" type="button" @click="openCreateModal">添加岗位</button>
    </div>

    <form class="d-flex flex-wrap align-items-center gap-2 mb-3" @submit.prevent="handleSearch">
      <input
        v-model="filters.name"
        class="form-control form-control-sm search-input"
        placeholder="按岗位名称搜索"
        type="text"
      />
      <button class="btn btn-brand btn-sm" type="submit">搜索</button>
      <button class="btn btn-light btn-sm border" type="button" @click="handleReset">重置</button>
    </form>

    <div class="table-responsive">
      <table class="table table-bordered table-hover table-sm">
        <thead>
          <tr>
            <th>名称</th>
            <th>岗级</th>
            <th>薪资</th>
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
            <td class="text-center text-muted" colspan="6">暂无岗位数据</td>
          </tr>
          <tr v-for="postLevel in pageState.records" :key="postLevel.id">
            <td>{{ postLevel.name || '-' }}</td>
            <td>{{ postLevel.level ?? '-' }}</td>
            <td>{{ postLevel.salary ?? '-' }}</td>
            <td>{{ postLevel.sortCode ?? '-' }}</td>
            <td>{{ statusText(postLevel.status) }}</td>
            <td>
              <button class="btn btn-sm btn-brand me-2" type="button" @click="openEditModal(postLevel)">编辑</button>
              <button class="btn btn-sm btn-danger" type="button" @click="handleDelete(postLevel.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <PaginationBar :page-num="pageState.pageNum" :page-size="pageState.pageSize" :total="pageState.total" @change="loadPostLevels" />

    <PostLevelFormModal
      :editing="editing"
      :post-level="currentPostLevel"
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
