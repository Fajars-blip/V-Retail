<template>
  <div class="flex h-screen w-full bg-slate-50 font-sans overflow-hidden">
    <!-- Sidebar Rail (Sistem Rail yang melebar saat di-hover) -->
    <aside 
      class="group fixed inset-y-0 left-0 z-50 flex w-20 flex-col bg-[#1e1b4b] transition-all duration-500 ease-in-out hover:w-64 border-r border-white/5"
      style="box-shadow: 10px 0 30px rgba(0,0,0,0.05);"
    >
      <!-- User Profile Area -->
      <div class="flex h-20 shrink-0 items-center gap-3 px-5 border-b border-white/5 cursor-pointer hover:bg-white/5 transition overflow-hidden" @click="router.push('/app/settings')">
        <div class="relative h-10 w-10 shrink-0 overflow-hidden rounded-xl border-2 border-indigo-500/30 bg-indigo-500/10">
          <img v-if="userProfile.photo_url" :src="userProfile.photo_url" alt="User" class="h-full w-full object-cover" />
          <div v-else class="flex h-full w-full items-center justify-center text-xs font-black text-white">
            {{ userProfile.name ? userProfile.name.charAt(0).toUpperCase() : 'A' }}
          </div>
        </div>
        <div class="flex-1 min-w-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
          <h1 class="text-sm font-black tracking-tight text-white truncate">{{ userProfile.name }}</h1>
          <p class="text-[9px] font-black text-indigo-400 uppercase tracking-widest">{{ userProfile.role }}</p>
        </div>
      </div>

      <!-- Navigation Menu -->
      <nav class="flex-1 space-y-2 overflow-y-auto px-4 py-8 no-scrollbar overflow-x-hidden">
        <RouterLink
          v-for="item in menu"
          :key="item.name"
          :to="item.path"
          class="group/item flex items-center h-12 rounded-2xl transition-all duration-300"
          :class="isActive(item.path) ? 'bg-indigo-500 text-white shadow-lg shadow-indigo-500/30' : 'text-indigo-200/40 hover:bg-white/5 hover:text-white'"
        >
          <div class="w-12 h-12 shrink-0 flex items-center justify-center" :class="isActive(item.path) ? 'text-white' : 'text-indigo-400 group-hover/item:text-brand'">
            <!-- Icons -->
            <svg v-if="item.name === 'dashboard'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
            </svg>
            <svg v-else-if="item.name === 'pos'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
            </svg>
            <svg v-else-if="item.name === 'orders'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
            </svg>
            <svg v-else-if="item.name === 'inventory'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
            </svg>
            <svg v-else-if="item.name === 'purchase-orders'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            <svg v-else-if="item.name === 'customers'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            <svg v-else-if="item.name === 'settings'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
            </svg>
          </div>
          <span class="text-sm font-bold opacity-0 group-hover:opacity-100 transition-opacity duration-300 whitespace-nowrap pl-1">{{ item.label }}</span>
        </RouterLink>

        <!-- Map Section -->
        <div class="pt-6 mt-4 border-t border-white/5">
          <RouterLink
            to="/app/preventif-map"
            class="flex items-center h-12 rounded-2xl text-indigo-300 hover:bg-brand/10 hover:text-white transition-all"
          >
            <div class="w-12 h-12 shrink-0 flex items-center justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-brand" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7" />
              </svg>
            </div>
            <span class="text-sm font-bold opacity-0 group-hover:opacity-100 transition-opacity duration-300 whitespace-nowrap pl-1">Preventif Map</span>
          </RouterLink>
        </div>
      </nav>

      <!-- Logout Area -->
      <div class="p-4 border-t border-white/5">
        <button
          @click="logout"
          class="flex items-center h-12 w-full rounded-2xl text-rose-400 hover:bg-rose-500 hover:text-white transition-all overflow-hidden"
        >
          <div class="w-12 h-12 shrink-0 flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
          </div>
          <span class="text-sm font-black opacity-0 group-hover:opacity-100 transition-opacity duration-300 whitespace-nowrap pl-1">Logout</span>
        </button>
      </div>
    </aside>

    <!-- Content Area (Diberi margin-left agar tidak tertutup rail) -->
    <div class="flex flex-1 flex-col overflow-hidden bg-slate-50 ml-20 transition-all duration-500 relative">
      
      <!-- Premium Ambient Background Elements -->
      <div class="absolute inset-0 z-0 pointer-events-none overflow-hidden">
        <div class="absolute top-[-10%] left-[-5%] w-[40%] h-[40%] rounded-full bg-indigo-500/5 blur-[100px]"></div>
        <div class="absolute bottom-[-10%] right-[-5%] w-[40%] h-[40%] rounded-full bg-blue-500/5 blur-[100px]"></div>
        <div class="absolute top-[30%] right-[10%] w-[30%] h-[30%] rounded-full bg-purple-500/5 blur-[100px]"></div>
      </div>

      <!-- Top Header Horizontal -->
      <header class="flex h-16 shrink-0 items-center justify-between border-b border-white/60 bg-white/40 backdrop-blur-xl px-6 lg:px-8 z-10">
        
        <!-- Kiri: Breadcrumb or Greeting -->
        <div class="flex flex-col">
          <span class="text-[10px] font-black text-slate-400 uppercase tracking-[0.3em] mb-0.5">V Retail System</span>
          <h2 class="text-xl font-black text-slate-800 tracking-tight">
            {{ route.name === 'pos' ? 'Transaksikan Disini' : (route.name || 'Dashboard') }}
          </h2>
        </div>

        <!-- Kanan: Notifikasi & Logo Area -->
        <div class="flex items-center gap-4">
          
          <!-- Ikon Notifikasi -->
          <button class="relative flex h-9 w-9 items-center justify-center rounded-xl text-slate-400 transition hover:bg-slate-100 hover:text-slate-600">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
            <span class="absolute top-2 right-2 block h-2 w-2 rounded-full bg-rose-500 ring-2 ring-white"></span>
          </button>
          
          <div class="h-6 w-px bg-slate-200 mx-1"></div>

          <!-- VR Logo Area -->
          <div class="flex items-center gap-2 pr-2">
            <div class="h-10 w-10 rounded-xl overflow-hidden shadow-lg shadow-indigo-900/20 shrink-0">
              <img src="/src/assets/vr-logo.png" alt="V Retail Logo" class="h-full w-full object-cover" />
            </div>
            <div class="hidden sm:block leading-none">
              <div class="text-sm font-black tracking-tight text-slate-800">V Retail</div>
              <div class="text-[10px] font-bold text-brand uppercase tracking-tighter">Pro System</div>
            </div>
          </div>

        </div>
      </header>

      <!-- Main Router View -->
      <main class="flex-1 overflow-y-auto p-4 lg:p-8 custom-scrollbar">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter, RouterLink, RouterView } from 'vue-router'

const route = useRoute()
const router = useRouter()

const search = ref('')

const menu = [
  { name: 'dashboard', label: 'Dashboard', path: '/app/dashboard' },
  { name: 'pos', label: 'Kasir / POS', path: '/app/pos' },
  { name: 'orders', label: 'Orders', path: '/app/orders' },
  { name: 'inventory', label: 'Inventory', path: '/app/inventory' },
  { name: 'purchase-orders', label: 'Purchase Orders', path: '/app/purchase-orders' },
  { name: 'customers', label: 'Customers', path: '/app/customers' },
  { name: 'settings', label: 'Settings', path: '/app/settings' }
]

const userProfile = ref({
  name: 'Admin',
  photo_url: '',
  role: 'admin'
})

const loadProfile = () => {
  try {
    const session = JSON.parse(localStorage.getItem('userSession') || '{}')
    userProfile.value.name = session.name || 'Admin'
    userProfile.value.photo_url = session.photo_url || ''
    userProfile.value.role = session.role || 'admin'
  } catch (e) {
    userProfile.value.name = 'Admin'
    userProfile.value.role = 'admin'
  }
}

onMounted(() => {
  loadProfile()
  window.addEventListener('storage', loadProfile)
})

onUnmounted(() => {
  window.removeEventListener('storage', loadProfile)
})

const isActive = (path) => route.path === path

const logout = () => {
  localStorage.removeItem('userSession')
  router.push('/login')
}
</script>

<style>
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}

/* Ensure the sidebar expands smoothly */
aside {
  transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1) !important;
}
</style>