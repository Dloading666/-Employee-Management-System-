<script setup>
import { computed, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import PageCard from '../components/ui/PageCard.vue'
import { createLeaveApi } from '../api/leaves'

const router = useRouter()

const form = reactive({
  leaveTypeCode: '事假',
  leaveStartTime: '',
  leaveEndTime: '',
  duration: '',
  leaveReason: '',
})

const previewUrl = ref('')
const submitting = ref(false)

const durationHint = computed(() => {
  if (!form.leaveStartTime || !form.leaveEndTime) {
    return ''
  }
  const start = new Date(form.leaveStartTime)
  const end = new Date(form.leaveEndTime)
  if (Number.isNaN(start.getTime()) || Number.isNaN(end.getTime()) || end <= start) {
    return '结束时间需要晚于开始时间'
  }
  const hours = ((end.getTime() - start.getTime()) / 3600000).toFixed(1)
  return `预计时长：${hours} 小时`
})

function handleFileChange(event) {
  const [file] = event.target.files || []
  previewUrl.value = file ? URL.createObjectURL(file) : ''
}

async function handleSubmit() {
  if (!form.leaveStartTime || !form.leaveEndTime || !form.leaveReason.trim()) {
    window.alert('请先填写完整的请假信息')
    return
  }
  const start = new Date(form.leaveStartTime)
  const end = new Date(form.leaveEndTime)
  if (end <= start) {
    window.alert('结束时间必须晚于开始时间')
    return
  }

  submitting.value = true
  try {
    await createLeaveApi({
      leaveTypeCode: form.leaveTypeCode,
      leaveStartTime: form.leaveStartTime,
      leaveEndTime: form.leaveEndTime,
      leaveReason: form.leaveReason.trim(),
    })
    window.alert('请假申请已提交')
    await router.push('/app/leave-list')
  } catch (error) {
    window.alert(error.message || '提交失败')
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <PageCard class="apply-card">
    <div class="page-headline mb-4">
      <div>
        <h3>请假申请</h3>
        <small>填写请假时间、类型和事由后提交审批</small>
      </div>
    </div>

    <form class="row g-3" @submit.prevent="handleSubmit">
      <div class="col-md-6">
        <label class="form-label">请假类型</label>
        <select v-model="form.leaveTypeCode" class="form-select">
          <option value="事假">事假</option>
          <option value="病假">病假</option>
          <option value="年假">年假</option>
          <option value="调休">调休</option>
        </select>
      </div>

      <div class="col-md-6">
        <label class="form-label">时长（小时）</label>
        <input v-model="form.duration" class="form-control" min="1" type="number" />
        <div class="form-hint mt-1">{{ durationHint || '可手动填写，系统会按审批时间记录。' }}</div>
      </div>

      <div class="col-md-6">
        <label class="form-label">开始时间</label>
        <input v-model="form.leaveStartTime" class="form-control" type="datetime-local" required />
      </div>

      <div class="col-md-6">
        <label class="form-label">结束时间</label>
        <input v-model="form.leaveEndTime" class="form-control" type="datetime-local" required />
      </div>

      <div class="col-12">
        <label class="form-label">请假事由</label>
        <textarea v-model="form.leaveReason" class="form-control" maxlength="200" required rows="4" />
      </div>

      <div class="col-12">
        <label class="form-label">图片上传（可选）</label>
        <input class="form-control" accept="image/*" type="file" @change="handleFileChange" />
        <div v-if="previewUrl" class="preview-panel mt-3">
          <img :src="previewUrl" alt="preview" class="preview-image" />
        </div>
      </div>

      <div class="col-12 text-end">
        <button class="btn btn-brand px-4" :disabled="submitting" type="submit">
          {{ submitting ? '提交中...' : '提交申请' }}
        </button>
      </div>
    </form>
  </PageCard>
</template>

<style scoped>
.apply-card {
  max-width: 760px;
  margin: 0 auto;
}

.preview-panel {
  padding: 0.75rem;
  border: 1px dashed var(--line);
  border-radius: 0.75rem;
  background: #fafcff;
}

.preview-image {
  max-width: 140px;
  max-height: 140px;
  border-radius: 0.5rem;
  object-fit: cover;
}
</style>
