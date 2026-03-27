<script setup>
import { computed } from 'vue'

const props = defineProps({
  total: {
    type: Number,
    default: 0,
  },
  pageNum: {
    type: Number,
    default: 1,
  },
  pageSize: {
    type: Number,
    default: 10,
  },
})

const emit = defineEmits(['change'])

const totalPages = computed(() => Math.max(1, Math.ceil(props.total / props.pageSize)))

const pageNumbers = computed(() => {
  const pages = []
  const start = Math.max(1, props.pageNum - 2)
  const end = Math.min(totalPages.value, start + 4)
  for (let page = start; page <= end; page += 1) {
    pages.push(page)
  }
  return pages
})

function goTo(page) {
  if (page < 1 || page > totalPages.value || page === props.pageNum) {
    return
  }
  emit('change', page)
}
</script>

<template>
  <nav class="d-flex justify-content-between align-items-center mt-3 flex-wrap gap-2">
    <small class="text-muted">共 {{ total }} 条，当前第 {{ pageNum }} / {{ totalPages }} 页</small>
    <ul class="pagination pagination-sm mb-0">
      <li class="page-item" :class="{ disabled: pageNum <= 1 }">
        <button class="page-link" type="button" @click="goTo(pageNum - 1)">上一页</button>
      </li>
      <li v-for="page in pageNumbers" :key="page" class="page-item" :class="{ active: page === pageNum }">
        <button class="page-link" type="button" @click="goTo(page)">{{ page }}</button>
      </li>
      <li class="page-item" :class="{ disabled: pageNum >= totalPages }">
        <button class="page-link" type="button" @click="goTo(pageNum + 1)">下一页</button>
      </li>
    </ul>
  </nav>
</template>
