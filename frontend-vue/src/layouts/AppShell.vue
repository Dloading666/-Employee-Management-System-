<script setup>
import { computed, ref } from 'vue'
import { RouterLink, RouterView, useRoute, useRouter } from 'vue-router'
import { adminMenu, employeeMenu } from '../config/menu'
import { logout, useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const sidebarVisible = ref(true)

const menuItems = computed(() => (auth.isAdmin.value ? adminMenu : employeeMenu))
const roleLabel = computed(() => (auth.isAdmin.value ? '管理员' : '普通用户'))
const roleBadgeClass = computed(() => (auth.isAdmin.value ? 'badge badge-role-admin' : 'badge badge-role-user'))
const shellTitle = computed(() =>
  auth.isAdmin.value ? '企业员工管理系统' : '企业员工管理系统 - 员工中心',
)

function isActive(item) {
  return route.path === item.route
}

async function handleLogout() {
  await logout()
  await router.push('/signin')
}
</script>

<template>
  <div class="container-fluid p-0 h-100">
    <div class="row topbar align-items-center g-0">
      <div class="col d-flex align-items-center">
        <button
          class="btn btn-sm btn-light me-3"
          type="button"
          style="border-radius: 4px"
          @click="sidebarVisible = !sidebarVisible"
        >
          ☰
        </button>
        {{ shellTitle }}
      </div>
      <div class="col text-end">
        <span class="me-3">
          欢迎，<strong>{{ auth.user.value?.name || '-' }}</strong>
          <span :class="roleBadgeClass" class="badge ms-2">{{ roleLabel }}</span>
        </span>
        <button class="btn btn-link text-white text-decoration-none p-0" type="button" @click="handleLogout">
          退出登录
        </button>
      </div>
    </div>

    <div class="row g-0">
      <aside v-show="sidebarVisible" class="col-12 col-lg-2 sidebar">
        <ul class="nav flex-column mt-3" id="menuList">
          <li v-for="item in menuItems" :key="item.route" class="nav-item">
            <RouterLink
              :to="item.route"
              class="nav-link"
              :class="{ active: isActive(item) }"
            >
              {{ item.label }}
            </RouterLink>
          </li>
        </ul>
      </aside>

      <main :class="sidebarVisible ? 'col-12 col-lg-10 main-content' : 'col-12 main-content'">
        <div class="app-content-inner">
          <RouterView v-slot="{ Component, route: currentRoute }">
            <transition name="route-fade" mode="out-in">
              <component :is="Component" :key="currentRoute.fullPath" />
            </transition>
          </RouterView>
        </div>
      </main>
    </div>
  </div>
</template>

<style scoped>
.topbar {
  background: var(--brand);
  color: #fff;
  padding: 12px 20px;
}

.sidebar {
  min-height: calc(100vh - 56px);
  background: var(--sidebar-bg);
  border-right: 1px solid var(--line);
}

.nav-link {
  color: #333;
  cursor: pointer;
  border-radius: 0;
  padding: 0.8rem 1rem;
}

.nav-link.active,
.nav-link:hover {
  background: #e9ecef;
  color: var(--brand);
}

.main-content {
  padding: 0;
  min-height: calc(100vh - 56px);
}

.app-content-inner {
  padding: 1.25rem;
  height: calc(100vh - 56px);
  overflow: auto;
}

@media (max-width: 991px) {
  .sidebar {
    min-height: auto;
  }

  .app-content-inner {
    height: auto;
    min-height: calc(100vh - 56px);
    padding: 1rem;
  }
}
</style>
