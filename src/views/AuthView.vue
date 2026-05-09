<template>
  <div class="flex min-h-screen items-center justify-center bg-[#f8f9fc] font-sans p-4">
    <!-- Main Container -->
    <div 
      class="relative w-[900px] max-w-full min-h-[550px] bg-white rounded-3xl shadow-[0_30px_60px_rgba(30,27,75,0.1)] overflow-hidden transition-all duration-300"
      :class="{ 'right-panel-active': isSignUpActive }"
    >
      <!-- Sign Up Form Container -->
      <div class="form-container sign-up-container absolute top-0 left-0 h-full w-1/2 flex flex-col justify-center px-10 sm:px-14 bg-white z-10 transition-all duration-700 ease-in-out opacity-0">
        <form @submit.prevent="handleRegister" class="flex flex-col h-full justify-center">
          <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-slate-800 mb-2">Buat Akun</h1>
            <p class="text-sm text-slate-500">Gunakan email Anda untuk registrasi</p>
          </div>
          
          <div class="space-y-4 text-left">
            <div>
              <label class="block text-xs font-semibold text-slate-600 mb-1 ml-1">Nama Lengkap</label>
              <input v-model="registerForm.name" type="text" placeholder="Masukkan nama lengkap" class="w-full bg-slate-50 border border-slate-200 px-4 py-3.5 rounded-xl text-sm outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all" required />
            </div>
            
            <div>
              <label class="block text-xs font-semibold text-slate-600 mb-1 ml-1">Alamat Email</label>
              <input v-model="registerForm.email" type="email" placeholder="contoh@email.com" class="w-full bg-slate-50 border border-slate-200 px-4 py-3.5 rounded-xl text-sm outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all" required />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-600 mb-1 ml-1">Nomor Telepon</label>
              <input v-model="registerForm.phone" type="tel" placeholder="0812xxxxxxxx" class="w-full bg-slate-50 border border-slate-200 px-4 py-3.5 rounded-xl text-sm outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all" required />
            </div>
            
            <div>
              <label class="block text-xs font-semibold text-slate-600 mb-1 ml-1">Kata Sandi</label>
              <div class="relative">
                <input v-model="registerForm.password" :type="showRegisterPassword ? 'text' : 'password'" placeholder="Minimal 8 karakter" class="w-full bg-slate-50 border border-slate-200 px-4 py-3.5 pr-10 rounded-xl text-sm outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all" required />
                <button type="button" @click="showRegisterPassword = !showRegisterPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-indigo-600 transition-colors">
                  <svg v-if="!showRegisterPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                  </svg>
                  <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                </button>
              </div>
            </div>
          </div>
          
          <button type="submit" class="w-full bg-indigo-600 text-white rounded-xl px-4 py-4 font-bold tracking-wider uppercase text-xs mt-8 shadow-lg shadow-indigo-600/30 hover:bg-indigo-700 hover:-translate-y-0.5 hover:shadow-indigo-600/40 transition-all duration-200 disabled:opacity-70 disabled:transform-none" :disabled="loading">
            {{ loading ? 'Memproses...' : 'Daftar Sekarang' }}
          </button>
        </form>
      </div>

      <!-- Sign In Form Container -->
      <div class="form-container sign-in-container absolute top-0 left-0 h-full w-1/2 flex flex-col justify-center px-10 sm:px-14 bg-white z-20 transition-all duration-700 ease-in-out">
        <form @submit.prevent="handleLogin" class="flex flex-col h-full justify-center">
          <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-slate-800 mb-2">Masuk</h1>
            <p class="text-sm text-slate-500">Akses dashboard retail Anda</p>
          </div>
          
          <div class="space-y-4 text-left">
            <div>
              <label class="block text-xs font-semibold text-slate-600 mb-1 ml-1">Alamat Email</label>
              <input v-model="loginForm.email" type="email" placeholder="contoh@email.com" class="w-full bg-slate-50 border border-slate-200 px-4 py-3.5 rounded-xl text-sm outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all" required />
            </div>
            
            <div>
              <label class="block text-xs font-semibold text-slate-600 mb-1 ml-1">Kata Sandi</label>
              <div class="relative">
                <input v-model="loginForm.password" :type="showLoginPassword ? 'text' : 'password'" placeholder="Masukkan kata sandi" class="w-full bg-slate-50 border border-slate-200 px-4 py-3.5 pr-10 rounded-xl text-sm outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all" required />
                <button type="button" @click="showLoginPassword = !showLoginPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-indigo-600 transition-colors">
                  <svg v-if="!showLoginPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                  </svg>
                  <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                </button>
              </div>
            </div>
          </div>
          
          <div class="flex justify-end mt-3">
            <a href="#" class="text-xs text-indigo-600 font-semibold hover:text-indigo-800 transition-colors">Lupa sandi?</a>
          </div>
          
          <button type="submit" class="w-full bg-[#1e1b4b] text-white rounded-xl px-4 py-4 font-bold tracking-wider uppercase text-xs mt-6 shadow-lg shadow-slate-900/20 hover:bg-slate-800 hover:-translate-y-0.5 hover:shadow-slate-900/30 transition-all duration-200 disabled:opacity-70 disabled:transform-none" :disabled="loading">
            {{ loading ? 'Memproses...' : 'Masuk' }}
          </button>
        </form>
      </div>

      <!-- Overlay Container -->
      <div class="overlay-container absolute top-0 left-1/2 w-1/2 h-full overflow-hidden transition-transform duration-700 ease-in-out z-[100]">
        <!-- The background gradient -->
        <div class="overlay absolute top-0 -left-full h-full w-[200%] bg-gradient-to-br from-[#1e1b4b] via-indigo-900 to-indigo-600 text-white transform transition-transform duration-700 ease-in-out">
          
          <!-- Overlay Left (Shows on Sign Up) -->
          <div class="overlay-panel overlay-left absolute top-0 flex flex-col items-center justify-center h-full w-1/2 px-12 text-center transform -translate-x-[20%] transition-transform duration-700 ease-in-out">
            <div class="mb-8 p-4 bg-white/10 rounded-2xl backdrop-blur-sm border border-white/20">
              <div class="grid h-12 w-12 place-content-center rounded-xl bg-white text-xl font-bold text-indigo-600 mx-auto">VR</div>
            </div>
            <h1 class="text-3xl font-bold mb-4 tracking-tight">Selamat Datang!</h1>
            <p class="text-sm text-indigo-100 font-medium leading-relaxed mb-10">
              Sudah memiliki akun? Silakan masuk dengan informasi personal Anda untuk mengakses dashboard.
            </p>
            <button @click="switchMode('login')" class="bg-transparent border-2 border-white/50 text-white rounded-xl px-10 py-3.5 font-bold tracking-widest uppercase text-xs hover:bg-white hover:text-[#1e1b4b] hover:border-white transition-all duration-300">
              Masuk
            </button>
          </div>

          <!-- Overlay Right (Shows on Sign In) -->
          <div class="overlay-panel overlay-right absolute top-0 right-0 flex flex-col items-center justify-center h-full w-1/2 px-12 text-center transform translate-x-0 transition-transform duration-700 ease-in-out">
            <div class="mb-8 p-4 bg-white/10 rounded-2xl backdrop-blur-sm border border-white/20">
              <div class="grid h-12 w-12 place-content-center rounded-xl bg-white text-xl font-bold text-indigo-600 mx-auto">VR</div>
            </div>
            <h1 class="text-3xl font-bold mb-4 tracking-tight">Halo, Mitra!</h1>
            <p class="text-sm text-indigo-100 font-medium leading-relaxed mb-10">
              Belum memiliki akun V Retail? Daftar sekarang dan mulai optimalkan manajemen bisnis Anda.
            </p>
            <button @click="switchMode('register')" class="bg-transparent border-2 border-white/50 text-white rounded-xl px-10 py-3.5 font-bold tracking-widest uppercase text-xs hover:bg-white hover:text-[#1e1b4b] hover:border-white transition-all duration-300">
              Daftar Sekarang
            </button>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { supabase } from '../lib/supabase'

const router = useRouter()
const route = useRoute()

const isSignUpActive = ref(route.path === '/register')
const showLoginPassword = ref(false)
const showRegisterPassword = ref(false)

watch(() => route.path, (newPath) => {
  isSignUpActive.value = newPath === '/register'
})

const loading = ref(false)

const loginForm = reactive({
  email: '',
  password: ''
})

const registerForm = reactive({
  name: '',
  email: '',
  phone: '',
  password: ''
})

onMounted(() => {
  const session = localStorage.getItem('userSession')
  if (session) {
    router.push('/app/dashboard')
  }
})

const switchMode = (mode) => {
  if (mode === 'register') {
    isSignUpActive.value = true
    router.push('/register')
  } else {
    isSignUpActive.value = false
    router.push('/login')
  }
}

const handleLogin = async () => {
  loading.value = true

  // Cek apakah email ada
  const { data: user, error } = await supabase
    .from('users_retail')
    .select('*')
    .eq('email', loginForm.email)
    .maybeSingle()

  loading.value = false

  if (error) {
    window.alert(`Terjadi kesalahan sistem: ${error.message}`)
    return
  }

  // Jika user tidak ditemukan
  if (!user) {
    window.alert('Email tidak terdaftar!')
    return
  }

  // Jika password tidak cocok
  if (user.password !== loginForm.password) {
    window.alert('Password tidak sesuai!')
    return
  }

  // Jika berhasil
  window.alert(`Login berhasil! Selamat datang, ${user.name}`)
  localStorage.setItem('userSession', JSON.stringify(user))
  router.push('/app/dashboard')
}

const handleRegister = async () => {
  loading.value = true

  const { error } = await supabase.from('users_retail').insert([
    {
      name: registerForm.name,
      email: registerForm.email,
      phone: registerForm.phone || null,
      password: registerForm.password
    }
  ])

  loading.value = false

  if (error) {
    window.alert(`Registrasi gagal: ${error.message}`)
    return
  }

  window.alert('Registrasi berhasil! Silakan masuk dengan akun baru Anda.')
  switchMode('login')
  loginForm.email = registerForm.email
  registerForm.name = ''
  registerForm.email = ''
  registerForm.phone = ''
  registerForm.password = ''
}
</script>

<style scoped>
/* 
  Sliding Panel Animation Logic
  Based on standard overlapping CSS transitions 
*/

/* Base states */
.form-container {
  transition: all 0.7s cubic-bezier(0.4, 0, 0.2, 1);
}

.sign-in-container {
  z-index: 2;
}

.sign-up-container {
  z-index: 1;
  opacity: 0;
}

/* Active states (Sign Up / Register) */
.right-panel-active .sign-in-container {
  transform: translateX(100%);
  opacity: 0;
  z-index: 1;
}

.right-panel-active .sign-up-container {
  transform: translateX(100%);
  opacity: 1;
  z-index: 5;
  animation: show 0.7s;
}

@keyframes show {
  0%, 49.99% {
    opacity: 0;
    z-index: 1;
  }
  50%, 100% {
    opacity: 1;
    z-index: 5;
  }
}

/* Overlay animations */
.overlay-container {
  transition: transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
}

.right-panel-active .overlay-container {
  transform: translateX(-100%);
}

.overlay {
  transition: transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
}

.right-panel-active .overlay {
  transform: translateX(50%);
}

.overlay-panel {
  transition: transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
}

.right-panel-active .overlay-left {
  transform: translateX(0);
}

.right-panel-active .overlay-right {
  transform: translateX(20%);
}
</style>
