<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import PageCard from '../components/ui/PageCard.vue'
import { createProfileApi, fetchProfileApi, updateProfileApi } from '../api/profile'
import { formatDate, toDateInputValue, toNullableNumber } from '../utils/format'

function createEmptyForm() {
  return {
    id: null,
    name: '',
    code: '',
    email: '',
    mobile: '',
    sex: 1,
    birthday: '',
    habitation: '',
    maritalStatus: 2,
    graduateSchool: '',
    majorCode: '',
    highestEducationCode: '',
    highestDegreeCode: '',
  }
}

const loading = ref(false)
const submitting = ref(false)
const editMode = ref(false)
const profile = ref(null)
const form = reactive(createEmptyForm())

const employee = computed(() => profile.value?.employee || null)
const deptName = computed(() => profile.value?.deptName)
const postLevelName = computed(() => profile.value?.postLevelName)

const sexText = computed(() => {
  if (!employee.value) {
    return '-'
  }
  return Number(employee.value.sex) === 1 ? '男' : Number(employee.value.sex) === 2 ? '女' : '未知'
})

const maritalText = computed(() => {
  if (!employee.value) {
    return '-'
  }
  return Number(employee.value.maritalStatus) === 1 ? '已婚' : Number(employee.value.maritalStatus) === 2 ? '未婚' : '未知'
})

function syncForm() {
  const current = employee.value || {}
  Object.assign(form, createEmptyForm(), {
    ...current,
    birthday: toDateInputValue(current.birthday),
  })
}

async function loadProfile() {
  loading.value = true
  try {
    profile.value = await fetchProfileApi()
    syncForm()
  } finally {
    loading.value = false
  }
}

function startEdit() {
  editMode.value = true
  syncForm()
}

function cancelEdit() {
  editMode.value = false
  syncForm()
}

function buildPayload(includeId = false) {
  const payload = {
    name: form.name.trim(),
    code: form.code || null,
    email: form.email || null,
    mobile: form.mobile || null,
    sex: toNullableNumber(form.sex),
    birthday: form.birthday || null,
    habitation: form.habitation || null,
    maritalStatus: toNullableNumber(form.maritalStatus),
    graduateSchool: form.graduateSchool || null,
    majorCode: form.majorCode || null,
    highestEducationCode: form.highestEducationCode || null,
    highestDegreeCode: form.highestDegreeCode || null,
  }
  if (includeId) {
    payload.id = form.id
  }
  return payload
}

async function handleCreate() {
  if (!form.name.trim()) {
    window.alert('姓名不能为空')
    return
  }
  submitting.value = true
  try {
    profile.value = await createProfileApi(buildPayload(false))
    window.alert('员工档案已创建')
    editMode.value = false
    syncForm()
  } catch (error) {
    window.alert(error.message || '创建失败')
  } finally {
    submitting.value = false
  }
}

async function handleUpdate() {
  if (!form.name.trim()) {
    window.alert('姓名不能为空')
    return
  }
  submitting.value = true
  try {
    profile.value = await updateProfileApi(buildPayload(true))
    window.alert('个人信息已保存')
    editMode.value = false
    syncForm()
  } catch (error) {
    window.alert(error.message || '保存失败')
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  loadProfile()
})
</script>

<template>
  <PageCard class="profile-card">
    <div class="profile-header">
      <div>
        <h3>个人信息</h3>
        <small>查看和维护当前登录员工的详细资料</small>
      </div>
      <div v-if="employee">
        <button v-if="!editMode" class="btn btn-light btn-sm me-2" type="button" @click="startEdit">编辑</button>
        <button v-if="editMode" class="btn btn-secondary btn-sm" type="button" @click="cancelEdit">取消</button>
      </div>
    </div>

    <div v-if="loading" class="empty-state">资料加载中...</div>

    <div v-else class="profile-body">
      <template v-if="!employee">
        <div class="alert alert-warning mb-4">
          暂未找到与当前账号关联的员工信息，你可以先创建自己的员工档案。
        </div>

        <form class="row g-3" @submit.prevent="handleCreate">
          <div class="col-md-4">
            <label class="form-label">姓名</label>
            <input v-model="form.name" class="form-control" type="text" required />
          </div>
          <div class="col-md-4">
            <label class="form-label">工号</label>
            <input v-model="form.code" class="form-control" type="text" />
          </div>
          <div class="col-md-4">
            <label class="form-label">邮箱</label>
            <input v-model="form.email" class="form-control" type="email" />
          </div>

          <div class="col-md-4">
            <label class="form-label">手机号</label>
            <input v-model="form.mobile" class="form-control" type="text" />
          </div>
          <div class="col-md-4">
            <label class="form-label">性别</label>
            <select v-model="form.sex" class="form-select">
              <option :value="1">男</option>
              <option :value="2">女</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label">出生日期</label>
            <input v-model="form.birthday" class="form-control" type="date" />
          </div>

          <div class="col-md-6">
            <label class="form-label">现居住地</label>
            <input v-model="form.habitation" class="form-control" type="text" />
          </div>
          <div class="col-md-6">
            <label class="form-label">婚姻状态</label>
            <select v-model="form.maritalStatus" class="form-select">
              <option :value="1">已婚</option>
              <option :value="2">未婚</option>
            </select>
          </div>

          <div class="col-md-4">
            <label class="form-label">毕业院校</label>
            <input v-model="form.graduateSchool" class="form-control" type="text" />
          </div>
          <div class="col-md-4">
            <label class="form-label">专业</label>
            <input v-model="form.majorCode" class="form-control" type="text" />
          </div>
          <div class="col-md-4">
            <label class="form-label">最高学历</label>
            <input v-model="form.highestEducationCode" class="form-control" type="text" />
          </div>

          <div class="col-md-4">
            <label class="form-label">最高学位</label>
            <input v-model="form.highestDegreeCode" class="form-control" type="text" />
          </div>

          <div class="col-12 text-end">
            <button class="btn btn-brand" :disabled="submitting" type="submit">
              {{ submitting ? '创建中...' : '创建档案' }}
            </button>
          </div>
        </form>
      </template>

      <template v-else>
        <div class="section-title">基本信息</div>
        <div class="row g-3">
          <div class="col-md-4">
            <div class="field-label">姓名</div>
            <div v-if="!editMode" class="field-value">{{ employee.name || '-' }}</div>
            <input v-else v-model="form.name" class="form-control" type="text" />
          </div>
          <div class="col-md-4">
            <div class="field-label">工号</div>
            <div class="field-value readonly-field">{{ employee.code || '未填写' }}</div>
          </div>
          <div class="col-md-4">
            <div class="field-label">角色类型</div>
            <div class="field-value readonly-field">{{ employee.roleType ?? '未设置' }}</div>
          </div>
        </div>

        <div class="section-title">联系方式</div>
        <div class="row g-3">
          <div class="col-md-4">
            <div class="field-label">邮箱</div>
            <div v-if="!editMode" class="field-value">{{ employee.email || '未填写' }}</div>
            <input v-else v-model="form.email" class="form-control" type="email" />
          </div>
          <div class="col-md-4">
            <div class="field-label">手机号</div>
            <div v-if="!editMode" class="field-value">{{ employee.mobile || '未填写' }}</div>
            <input v-else v-model="form.mobile" class="form-control" type="text" />
          </div>
          <div class="col-md-4">
            <div class="field-label">现居住地</div>
            <div v-if="!editMode" class="field-value">{{ employee.habitation || '未填写' }}</div>
            <input v-else v-model="form.habitation" class="form-control" type="text" />
          </div>
        </div>

        <div class="section-title">个人情况</div>
        <div class="row g-3">
          <div class="col-md-4">
            <div class="field-label">性别</div>
            <div v-if="!editMode" class="field-value">{{ sexText }}</div>
            <select v-else v-model="form.sex" class="form-select">
              <option :value="1">男</option>
              <option :value="2">女</option>
            </select>
          </div>
          <div class="col-md-4">
            <div class="field-label">出生日期</div>
            <div v-if="!editMode" class="field-value">{{ formatDate(employee.birthday, '未填写') }}</div>
            <input v-else v-model="form.birthday" class="form-control" type="date" />
          </div>
          <div class="col-md-4">
            <div class="field-label">婚姻状态</div>
            <div v-if="!editMode" class="field-value">{{ maritalText }}</div>
            <select v-else v-model="form.maritalStatus" class="form-select">
              <option :value="1">已婚</option>
              <option :value="2">未婚</option>
            </select>
          </div>
        </div>

        <div class="section-title">学历信息</div>
        <div class="row g-3">
          <div class="col-md-4">
            <div class="field-label">毕业院校</div>
            <div v-if="!editMode" class="field-value">{{ employee.graduateSchool || '未填写' }}</div>
            <input v-else v-model="form.graduateSchool" class="form-control" type="text" />
          </div>
          <div class="col-md-4">
            <div class="field-label">专业</div>
            <div v-if="!editMode" class="field-value">{{ employee.majorCode || '未填写' }}</div>
            <input v-else v-model="form.majorCode" class="form-control" type="text" />
          </div>
          <div class="col-md-4">
            <div class="field-label">最高学历 / 学位</div>
            <div v-if="!editMode" class="field-value">
              {{ employee.highestEducationCode || '未填写' }}
              <template v-if="employee.highestEducationCode && employee.highestDegreeCode">/</template>
              {{ employee.highestDegreeCode || '' }}
            </div>
            <div v-else class="d-grid gap-2">
              <input v-model="form.highestEducationCode" class="form-control" placeholder="最高学历" type="text" />
              <input v-model="form.highestDegreeCode" class="form-control" placeholder="最高学位" type="text" />
            </div>
          </div>
        </div>

        <div class="section-title">工作信息</div>
        <div class="row g-3">
          <div class="col-md-3">
            <div class="field-label">部门</div>
            <div class="field-value readonly-field">{{ deptName || (employee.deptId ? `部门ID: ${employee.deptId}` : '未分配') }}</div>
          </div>
          <div class="col-md-3">
            <div class="field-label">岗位</div>
            <div class="field-value readonly-field">{{ postLevelName || (employee.postLevelId ? `岗位ID: ${employee.postLevelId}` : '未分配') }}</div>
          </div>
          <div class="col-md-3">
            <div class="field-label">入职日期</div>
            <div class="field-value readonly-field">{{ formatDate(employee.entryDate, '未填写') }}</div>
          </div>
          <div class="col-md-3">
            <div class="field-label">状态</div>
            <div class="field-value">
              <span class="badge" :class="Number(employee.status) === 1 ? 'text-bg-success' : 'text-bg-secondary'">
                {{ Number(employee.status) === 1 ? '在职' : '离职' }}
              </span>
            </div>
          </div>
        </div>

        <div v-if="editMode" class="text-end mt-4">
          <button class="btn btn-secondary me-2" type="button" @click="cancelEdit">取消</button>
          <button class="btn btn-brand" :disabled="submitting" type="button" @click="handleUpdate">
            {{ submitting ? '保存中...' : '保存' }}
          </button>
        </div>
      </template>
    </div>
  </PageCard>
</template>

<style scoped>
.profile-card {
  overflow: hidden;
  padding: 0;
}

.profile-header {
  padding: 1.4rem 1.6rem;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
  background: linear-gradient(135deg, #4f46e5, #3b82f6);
  color: #fff;
}

.profile-header h3 {
  margin: 0;
}

.profile-body {
  padding: 1.6rem;
}

.section-title {
  margin: 1.25rem 0 0.65rem;
  font-size: 0.95rem;
  font-weight: 700;
  color: #374151;
}

.field-label {
  color: var(--text-muted);
  font-size: 0.85rem;
  margin-bottom: 0.35rem;
}

.field-value {
  min-height: 38px;
  display: flex;
  align-items: center;
  font-weight: 500;
  color: #111827;
}

.readonly-field {
  color: #6b7280;
}
</style>
