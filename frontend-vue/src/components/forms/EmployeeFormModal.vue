<script setup>
import { reactive, watch } from 'vue'
import BaseModal from '../ui/BaseModal.vue'
import { toDateInputValue, toNullableNumber } from '../../utils/format'

const props = defineProps({
  show: { type: Boolean, default: false },
  employee: { type: Object, default: null },
  editing: { type: Boolean, default: false },
})

const emit = defineEmits(['close', 'submit'])

function createEmptyEmployee() {
  return {
    name: '',
    code: '',
    email: '',
    mobile: '',
    idCard: '',
    birthday: '',
    sex: '',
    nationCode: '',
    politicalCode: '',
    nativePlace: '',
    graduateSchool: '',
    majorCode: '',
    highestEducationCode: '',
    highestDegreeCode: '',
    habitation: '',
    maritalStatus: '',
    entryDate: '',
    leaveDate: '',
    deptId: '',
    postLevelId: '',
    userId: '',
    roleType: '',
    status: '',
  }
}

const form = reactive(createEmptyEmployee())

function syncForm() {
  const employee = props.employee || {}
  Object.assign(form, createEmptyEmployee(), {
    ...employee,
    birthday: toDateInputValue(employee.birthday),
    entryDate: toDateInputValue(employee.entryDate),
    leaveDate: toDateInputValue(employee.leaveDate),
  })
}

watch(() => props.show, (visible) => {
  if (visible) {
    syncForm()
  }
}, { immediate: true })

watch(() => props.employee, () => {
  if (props.show) {
    syncForm()
  }
})

function handleSubmit() {
  emit('submit', {
    name: form.name.trim(),
    code: form.code || null,
    email: form.email || null,
    mobile: form.mobile || null,
    idCard: form.idCard || null,
    birthday: form.birthday || null,
    sex: toNullableNumber(form.sex),
    nationCode: form.nationCode || null,
    politicalCode: form.politicalCode || null,
    nativePlace: form.nativePlace || null,
    graduateSchool: form.graduateSchool || null,
    majorCode: form.majorCode || null,
    highestEducationCode: form.highestEducationCode || null,
    highestDegreeCode: form.highestDegreeCode || null,
    habitation: form.habitation || null,
    maritalStatus: toNullableNumber(form.maritalStatus),
    entryDate: form.entryDate || null,
    leaveDate: form.leaveDate || null,
    deptId: toNullableNumber(form.deptId),
    postLevelId: toNullableNumber(form.postLevelId),
    userId: toNullableNumber(form.userId),
    roleType: toNullableNumber(form.roleType),
    status: toNullableNumber(form.status),
  })
}
</script>

<template>
  <BaseModal :show="show" :title="editing ? '编辑员工' : '添加员工'" size="lg" @close="emit('close')">
    <form class="row g-3" @submit.prevent="handleSubmit">
      <div class="col-md-6">
        <label class="form-label">姓名</label>
        <input v-model="form.name" class="form-control" type="text" required />
      </div>
      <div class="col-md-6">
        <label class="form-label">工号</label>
        <input v-model="form.code" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">邮箱</label>
        <input v-model="form.email" class="form-control" type="email" />
      </div>
      <div class="col-md-6">
        <label class="form-label">手机号</label>
        <input v-model="form.mobile" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">身份证号</label>
        <input v-model="form.idCard" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">出生日期</label>
        <input v-model="form.birthday" class="form-control" type="date" />
      </div>
      <div class="col-md-6">
        <label class="form-label">性别</label>
        <input v-model="form.sex" class="form-control" type="number" />
      </div>
      <div class="col-md-6">
        <label class="form-label">民族</label>
        <input v-model="form.nationCode" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">政治面貌</label>
        <input v-model="form.politicalCode" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">籍贯</label>
        <input v-model="form.nativePlace" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">毕业院校</label>
        <input v-model="form.graduateSchool" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">专业</label>
        <input v-model="form.majorCode" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">最高学历</label>
        <input v-model="form.highestEducationCode" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">最高学位</label>
        <input v-model="form.highestDegreeCode" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">现居住地</label>
        <input v-model="form.habitation" class="form-control" type="text" />
      </div>
      <div class="col-md-6">
        <label class="form-label">婚姻状态</label>
        <input v-model="form.maritalStatus" class="form-control" type="number" />
      </div>
      <div class="col-md-6">
        <label class="form-label">入职日期</label>
        <input v-model="form.entryDate" class="form-control" type="date" />
      </div>
      <div class="col-md-6">
        <label class="form-label">离职日期</label>
        <input v-model="form.leaveDate" class="form-control" type="date" />
      </div>
      <div class="col-md-6">
        <label class="form-label">部门 ID</label>
        <input v-model="form.deptId" class="form-control" type="number" />
      </div>
      <div class="col-md-6">
        <label class="form-label">岗位等级 ID</label>
        <input v-model="form.postLevelId" class="form-control" type="number" />
      </div>
      <div class="col-md-6">
        <label class="form-label">用户 ID</label>
        <input v-model="form.userId" class="form-control" type="number" />
      </div>
      <div class="col-md-6">
        <label class="form-label">角色类型</label>
        <input v-model="form.roleType" class="form-control" type="number" />
      </div>
      <div class="col-md-6">
        <label class="form-label">状态</label>
        <input v-model="form.status" class="form-control" type="number" />
      </div>
    </form>

    <template #footer>
      <div class="d-flex justify-content-end gap-2">
        <button class="btn btn-secondary me-2" type="button" @click="emit('close')">取消</button>
        <button class="btn btn-brand" type="button" @click="handleSubmit">
          {{ editing ? '保存' : '提交' }}
        </button>
      </div>
    </template>
  </BaseModal>
</template>
