import { createRouter, createWebHistory } from 'vue-router'
import AppShell from '../layouts/AppShell.vue'
import LoginPage from '../pages/LoginPage.vue'
import WelcomePage from '../pages/WelcomePage.vue'
import EmployeePage from '../pages/EmployeePage.vue'
import DepartmentPage from '../pages/DepartmentPage.vue'
import AttendancePage from '../pages/AttendancePage.vue'
import PostLevelPage from '../pages/PostLevelPage.vue'
import UserPage from '../pages/UserPage.vue'
import LeaveApplyPage from '../pages/LeaveApplyPage.vue'
import LeaveRecordsPage from '../pages/LeaveRecordsPage.vue'
import SalaryPage from '../pages/SalaryPage.vue'
import ProfilePage from '../pages/ProfilePage.vue'
import { restoreAuth, useAuthStore } from '../stores/auth'

const routes = [
  {
    path: '/',
    redirect: '/signin',
  },
  {
    path: '/signin',
    name: 'signin',
    component: LoginPage,
    meta: {
      guestOnly: true,
    },
  },
  {
    path: '/app',
    component: AppShell,
    meta: {
      requiresAuth: true,
    },
    children: [
      {
        path: '',
        redirect: '/app/welcome',
      },
      {
        path: 'welcome',
        name: 'welcome',
        component: WelcomePage,
      },
      {
        path: 'employees',
        name: 'employees',
        component: EmployeePage,
        meta: {
          adminOnly: true,
        },
      },
      {
        path: 'departments',
        name: 'departments',
        component: DepartmentPage,
        meta: {
          adminOnly: true,
        },
      },
      {
        path: 'attendance',
        name: 'attendance',
        component: AttendancePage,
      },
      {
        path: 'postlevels',
        name: 'postlevels',
        component: PostLevelPage,
        meta: {
          adminOnly: true,
        },
      },
      {
        path: 'users',
        name: 'users',
        component: UserPage,
        meta: {
          adminOnly: true,
        },
      },
      {
        path: 'salary-admin',
        name: 'salary-admin',
        component: SalaryPage,
        meta: {
          adminOnly: true,
        },
      },
      {
        path: 'leave-approval',
        name: 'leave-approval',
        component: LeaveRecordsPage,
        meta: {
          adminOnly: true,
        },
      },
      {
        path: 'profile',
        name: 'profile',
        component: ProfilePage,
      },
      {
        path: 'leave-apply',
        name: 'leave-apply',
        component: LeaveApplyPage,
      },
      {
        path: 'leave-list',
        name: 'leave-list',
        component: LeaveRecordsPage,
      },
      {
        path: 'salary-my',
        name: 'salary-my',
        component: SalaryPage,
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach(async (to) => {
  await restoreAuth()
  const auth = useAuthStore()

  if (to.meta.requiresAuth && !auth.isLoggedIn.value) {
    return '/signin'
  }

  if (to.meta.guestOnly && auth.isLoggedIn.value) {
    return '/app/welcome'
  }

  if (to.meta.adminOnly && !auth.isAdmin.value) {
    return '/app/welcome'
  }

  return true
})

export default router
