<template>
  <div class="grid min-h-screen place-items-center bg-gradient-to-br from-slate-200 via-slate-300 to-slate-500 p-4">
    <main class="w-full max-w-md rounded-3xl border border-white/30 bg-white/90 p-8 shadow-soft backdrop-blur-xl">
      <div class="mb-8 text-center">
        <h1 class="text-3xl font-bold text-slate-900">Daftar Akun</h1>
        <p class="mt-2 text-sm text-slate-500">Buat akun baru dengan cepat dan aman.</p>
      </div>

      <form class="space-y-4" @submit.prevent="handleRegister">
        <div>
          <label for="name" class="mb-2 block text-sm font-medium text-slate-700">Nama Lengkap</label>
          <input
            id="name"
            v-model="form.name"
            type="text"
            required
            class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand"
          />
        </div>
        <div>
          <label for="email" class="mb-2 block text-sm font-medium text-slate-700">Email</label>
          <input
            id="email"
            v-model="form.email"
            type="email"
            required
            class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand"
          />
        </div>
        <div>
          <label for="password" class="mb-2 block text-sm font-medium text-slate-700">Kata Sandi</label>
          <input
            id="password"
            v-model="form.password"
            type="password"
            required
            class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand"
          />
        </div>
        <div>
          <label for="confirm" class="mb-2 block text-sm font-medium text-slate-700">Konfirmasi Sandi</label>
          <input
            id="confirm"
            v-model="form.confirm"
            type="password"
            required
            class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand"
          />
        </div>

        <button
          type="submit"
          class="mt-2 w-full rounded-xl bg-brand px-4 py-3 text-sm font-semibold text-white transition hover:bg-brand-dark disabled:cursor-not-allowed disabled:opacity-70"
          :disabled="loading"
        >
          {{ loading ? 'Memproses...' : 'Daftar Sekarang' }}
        </button>
      </form>

      <p class="mt-6 text-center text-sm text-slate-600">
        Sudah punya akun?
        <RouterLink to="/login" class="font-semibold text-brand">Masuk di sini</RouterLink>
      </p>
    </main>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import { supabase } from '../lib/supabase'

const router = useRouter()
const loading = ref(false)

const form = reactive({
  name: '',
  email: '',
  password: '',
  confirm: ''
})

const handleRegister = async () => {
  if (form.password !== form.confirm) {
    window.alert('Konfirmasi sandi tidak cocok!')
    return
  }

  loading.value = true

  const { error } = await supabase.from('users_retail').insert([
    {
      name: form.name,
      email: form.email,
      password: form.password
    }
  ])

  loading.value = false

  if (error) {
    window.alert(`Gagal mendaftar: ${error.message}`)
    return
  }

  window.alert('Pendaftaran Berhasil!')
  router.push('/login')
}
</script>