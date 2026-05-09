<template>
  <div class="flex min-h-screen bg-gradient-to-br from-sky-200 via-blue-300 to-indigo-300">
    <section class="hidden flex-1 items-center justify-center p-16 text-white lg:flex">
      <div class="max-w-md">
        <p class="text-5xl font-semibold">V Retail</p>
        <p class="mt-5 text-lg text-white/90">
          Interface assets for retailers and startup creatives. Solusi IT Support handal untuk operasional retail Anda.
        </p>
      </div>
    </section>

    <section class="flex flex-1 items-center justify-center bg-white px-6 py-8 lg:rounded-l-[52px] lg:px-12">
      <div class="w-full max-w-md">
        <h1 class="text-3xl font-bold text-slate-900">Sign In</h1>
        <p class="mt-2 text-sm text-slate-500">Masuk untuk melanjutkan ke dashboard.</p>

        <form class="mt-8 space-y-5" @submit.prevent="handleLogin">
          <div>
            <label for="email" class="mb-2 block text-sm font-medium text-slate-700">Email address</label>
            <input
              id="email"
              v-model="form.email"
              type="email"
              required
              class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand"
            />
          </div>

          <div>
            <label for="password" class="mb-2 block text-sm font-medium text-slate-700">Password</label>
            <input
              id="password"
              v-model="form.password"
              type="password"
              required
              class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand"
            />
          </div>

          <button
            type="submit"
            class="w-full rounded-xl bg-brand px-4 py-3 text-sm font-semibold text-white transition hover:bg-brand-dark disabled:cursor-not-allowed disabled:opacity-70"
            :disabled="loading"
          >
            {{ loading ? 'Memproses...' : 'Login Account' }}
          </button>
        </form>

        <p class="mt-6 text-center text-sm text-slate-600">
          Belum punya akun?
          <RouterLink class="font-semibold text-brand" to="/register">Daftar Sekarang</RouterLink>
        </p>
      </div>
    </section>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import { supabase } from '../lib/supabase'

const router = useRouter()
const loading = ref(false)

const form = reactive({
  email: '',
  password: ''
})

const handleLogin = async () => {
  loading.value = true

  const { data, error } = await supabase
    .from('users_retail')
    .select('*')
    .eq('email', form.email)
    .eq('password', form.password)
    .single()

  loading.value = false

  if (error || !data) {
    window.alert('Email atau Password salah! Coba cek kembali data login Anda.')
    return
  }

  localStorage.setItem('userSession', JSON.stringify(data))
  window.alert(`Login Berhasil! Selamat datang, ${data.name}`)
  router.push('/app/dashboard')
}
</script>