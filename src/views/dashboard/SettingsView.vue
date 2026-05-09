<template>
  <div class="max-w-4xl space-y-6">
    <div class="rounded-2xl border border-slate-200 bg-white p-6 sm:p-8 shadow-sm">
      <h2 class="text-xl font-bold text-slate-800">Pengaturan Profil</h2>
      <p class="mt-1 text-sm text-slate-500">Perbarui informasi dasar profil, foto, dan kontak Anda.</p>
      
      <div class="mt-8 flex flex-col sm:flex-row gap-8">
        <!-- Profile Picture -->
        <div class="flex flex-col items-center space-y-4 sm:w-1/3 shrink-0">
          <div class="group relative h-36 w-36 overflow-hidden rounded-full border-4 border-white shadow-md bg-slate-100 transition-all hover:shadow-lg">
            <img v-if="profile.photo_url" :src="profile.photo_url" alt="Profile" class="h-full w-full object-cover" />
            <div v-else class="flex h-full w-full items-center justify-center bg-gradient-to-br from-brand to-indigo-600 text-5xl font-bold text-white">
              {{ profile.name ? profile.name.charAt(0).toUpperCase() : 'A' }}
            </div>
            
            <div class="absolute inset-0 bg-black/40 opacity-0 transition-opacity group-hover:opacity-100 flex items-center justify-center cursor-pointer" @click="triggerFileInput">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </div>
          </div>
          <button class="rounded-xl border border-slate-200 bg-white px-5 py-2 text-sm font-semibold text-slate-700 shadow-sm transition hover:bg-slate-50 hover:text-brand hover:border-brand/30" @click="triggerFileInput">
            Ubah Foto
          </button>
          <input type="file" ref="fileInput" class="hidden" accept="image/*" @change="handleFileUpload" />
          <p class="text-center text-xs text-slate-400 max-w-[200px]">Format JPG, GIF atau PNG. Ukuran maksimal 2MB.</p>
        </div>

        <!-- Basic Info Form -->
        <div class="flex-1 space-y-5">
          <div class="grid grid-cols-1 gap-5 sm:grid-cols-2">
            <div class="col-span-1 sm:col-span-2">
              <label class="mb-1.5 block text-sm font-semibold text-slate-700">Nama Lengkap</label>
              <input v-model="profile.name" type="text" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand focus:bg-white focus:ring-4 focus:ring-brand/10" placeholder="Masukkan nama lengkap" />
            </div>
            
            <div class="col-span-1 sm:col-span-2">
              <label class="mb-1.5 block text-sm font-semibold text-slate-700">Alamat Email</label>
              <input v-model="profile.email" type="email" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand focus:bg-white focus:ring-4 focus:ring-brand/10" placeholder="contoh@email.com" />
            </div>
            
            <div class="col-span-1">
              <label class="mb-1.5 block text-sm font-semibold text-slate-700">Nomor Telepon</label>
              <input v-model="profile.phone" type="tel" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand focus:bg-white focus:ring-4 focus:ring-brand/10" placeholder="08xxxxxxxxxx" />
            </div>

            <div class="col-span-1">
              <label class="mb-1.5 block text-sm font-semibold text-slate-700">Jabatan / Role</label>
              <input v-model="profile.role" type="text" disabled class="w-full rounded-xl border border-slate-200 bg-slate-100 px-4 py-3 text-sm text-slate-500 outline-none cursor-not-allowed font-medium" />
            </div>
            
            <div class="col-span-1 sm:col-span-2">
              <label class="mb-1.5 block text-sm font-semibold text-slate-700">Biodata Singkat</label>
              <textarea v-model="profile.bio" rows="4" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand focus:bg-white focus:ring-4 focus:ring-brand/10" placeholder="Tulis sedikit tentang diri Anda atau tugas Anda..."></textarea>
            </div>
          </div>
          
          <div class="flex justify-end pt-4 border-t border-slate-100">
            <button class="rounded-xl bg-brand px-6 py-3 text-sm font-semibold text-white shadow-soft transition-all hover:bg-brand-dark hover:shadow-lg flex items-center gap-2 disabled:opacity-70 disabled:cursor-not-allowed" @click="saveProfile" :disabled="isSaving">
              <svg v-if="!isSaving" xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              {{ isSaving ? 'Menyimpan ke Database...' : 'Simpan Perubahan' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Password Section -->
    <div class="rounded-2xl border border-slate-200 bg-white p-6 sm:p-8 shadow-sm">
      <h2 class="text-xl font-bold text-slate-800">Keamanan & Kata Sandi</h2>
      <p class="mt-1 text-sm text-slate-500">Pastikan akun Anda menggunakan kata sandi yang panjang dan acak agar tetap aman.</p>
      
      <div class="mt-6 max-w-2xl space-y-5">
        <div>
          <label class="mb-1.5 block text-sm font-semibold text-slate-700">Kata Sandi Saat Ini</label>
          <input v-model="password.current" type="password" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand focus:bg-white focus:ring-4 focus:ring-brand/10" placeholder="••••••••" />
        </div>
        
        <div class="grid grid-cols-1 gap-5 sm:grid-cols-2">
          <div>
            <label class="mb-1.5 block text-sm font-semibold text-slate-700">Kata Sandi Baru</label>
            <input v-model="password.new" type="password" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand focus:bg-white focus:ring-4 focus:ring-brand/10" placeholder="••••••••" />
          </div>
          
          <div>
            <label class="mb-1.5 block text-sm font-semibold text-slate-700">Konfirmasi Sandi Baru</label>
            <input v-model="password.confirm" type="password" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-brand focus:bg-white focus:ring-4 focus:ring-brand/10" placeholder="••••••••" />
          </div>
        </div>
        
        <div class="flex justify-end pt-4 border-t border-slate-100">
          <button class="rounded-xl bg-slate-800 px-6 py-3 text-sm font-semibold text-white shadow-soft transition-all hover:bg-slate-900 hover:shadow-lg flex items-center gap-2" @click="updatePassword">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
            Perbarui Kata Sandi
          </button>
        </div>
      </div>
    </div>

    <!-- Notification Toast -->
    <Transition name="toast">
      <div v-if="notification.show" 
        class="fixed top-6 left-1/2 -translate-x-1/2 z-[100] flex items-center gap-3 rounded-2xl px-6 py-4 shadow-2xl transition-all duration-500 border border-white/20 backdrop-blur-md"
        :class="notification.type === 'success' ? 'bg-emerald-500 text-white' : 'bg-rose-500 text-white'"
      >
        <div class="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-white/20">
          <svg v-if="notification.type === 'success'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
          </svg>
          <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </div>
        <div>
          <p class="text-sm font-bold">{{ notification.message }}</p>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { reactive, onMounted, ref } from 'vue'
import { supabase } from '../../lib/supabase'

const fileInput = ref(null)
const selectedFile = ref(null)
const isSaving = ref(false)

const profile = reactive({
  name: '',
  email: '',
  phone: '',
  role: 'Administrator',
  bio: '',
  photo_url: ''
})

const password = reactive({
  current: '',
  new: '',
  confirm: ''
})

const notification = reactive({
  show: false,
  message: '',
  type: 'success'
})

const showToast = (message, type = 'success') => {
  notification.show = true
  notification.message = message
  notification.type = type
  setTimeout(() => {
    notification.show = false
  }, 4000)
}

onMounted(async () => {
  // Load basic info from session if available
  try {
    const session = JSON.parse(localStorage.getItem('userSession') || '{}')
    if (session.email) {
      // Fetch latest profile from DB
      const { data, error } = await supabase
        .from('users_retail')
        .select('*')
        .eq('email', session.email)
        .single()
        
      if (data) {
        profile.name = data.name || session.name || ''
        profile.email = data.email || ''
        profile.phone = data.phone || ''
        profile.bio = data.bio || ''
        profile.photo_url = data.photo_url || session.photo_url || ''
        
        // Update local storage to match DB
        session.photo_url = profile.photo_url
        localStorage.setItem('userSession', JSON.stringify(session))
        window.dispatchEvent(new Event('storage'))
      }
    }
  } catch (e) {
    console.error(e)
  }
})

const triggerFileInput = () => {
  if (fileInput.value) {
    fileInput.value.click()
  }
}

const handleFileUpload = (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  if (file.size > 2 * 1024 * 1024) {
    showToast('Ukuran file terlalu besar. Maksimal 2MB.', 'error')
    return
  }
  
  selectedFile.value = file
  
  const reader = new FileReader()
  reader.onload = (e) => {
    profile.photo_url = e.target.result // for preview
  }
  reader.readAsDataURL(file)
}

const saveProfile = async () => {
  isSaving.value = true
  try {
    const session = JSON.parse(localStorage.getItem('userSession') || '{}')
    if (!session.email) {
      showToast('Sesi tidak valid, silakan login kembali.', 'error')
      isSaving.value = false
      return
    }

    let photoUrl = profile.photo_url

    // 1. Upload to Supabase Storage if there's a new file
    if (selectedFile.value) {
      // 1a. Delete OLD photo from storage if it exists
      try {
        const { data: userData } = await supabase.from('users_retail').select('photo_url').eq('email', session.email).single()
        if (userData?.photo_url) {
          const oldUrl = userData.photo_url
          // Deteksi apakah file berada di bucket 'profil data'
          if (oldUrl.includes('profil') && oldUrl.includes('data')) {
            // Mengambil nama file murni (menghapus query string jika ada)
            const urlParts = oldUrl.split('/')
            const fileNameWithQuery = urlParts[urlParts.length - 1]
            const oldFileName = decodeURIComponent(fileNameWithQuery.split('?')[0])
            
            if (oldFileName) {
              const { error: delError } = await supabase.storage.from('profil data').remove([oldFileName])
              if (delError) console.warn('Gagal hapus di Storage:', delError.message)
              else console.log('Berhasil menghapus file lama:', oldFileName)
            }
          }
        }
      } catch (err) {
        console.warn('Gagal proses penghapusan foto lama:', err)
      }

      const fileExt = selectedFile.value.name.split('.').pop()
      const fileName = `${session.email.split('@')[0]}-${Date.now()}.${fileExt}`
      
      const { data: uploadData, error: uploadError } = await supabase.storage
        .from('profil data')
        .upload(fileName, selectedFile.value, {
          cacheControl: '3600',
          upsert: true
        })

      if (uploadError) {
        showToast(`Gagal mengunggah foto: ${uploadError.message}`, 'error')
        isSaving.value = false
        return
      }

      const { data: { publicUrl } } = supabase.storage
        .from('profil data')
        .getPublicUrl(fileName)
        
      photoUrl = publicUrl
      profile.photo_url = publicUrl
      selectedFile.value = null // reset
    }

    // 2. Update database (users_retail)
    const { error: updateError } = await supabase
      .from('users_retail')
      .update({
        name: profile.name,
        phone: profile.phone || null,
        bio: profile.bio,
        photo_url: photoUrl
      })
      .eq('email', session.email)

    if (updateError) {
      showToast(`Gagal menyimpan profil: ${updateError.message}`, 'error')
      isSaving.value = false
      return
    }

    // 3. Update local session
    session.name = profile.name
    session.photo_url = photoUrl
    localStorage.setItem('userSession', JSON.stringify(session))
    window.dispatchEvent(new Event('storage'))
    
    showToast('Profil berhasil diperbarui!')
  } catch(e) {
    console.error(e)
    showToast('Terjadi kesalahan saat menyimpan.', 'error')
  }
  isSaving.value = false
}

const updatePassword = async () => {
  if (!password.current || !password.new || !password.confirm) {
    showToast('Harap isi semua kolom kata sandi!', 'error')
    return
  }
  if (password.new !== password.confirm) {
    showToast('Konfirmasi kata sandi baru tidak cocok!', 'error')
    return
  }
  
  try {
    const session = JSON.parse(localStorage.getItem('userSession') || '{}')
    
    // Cek password saat ini
    const { data: user } = await supabase
      .from('users_retail')
      .select('password')
      .eq('email', session.email)
      .single()
      
    if (!user || user.password !== password.current) {
      showToast('Kata sandi saat ini salah!', 'error')
      return
    }
    
    // Update password
    const { error } = await supabase
      .from('users_retail')
      .update({ password: password.new })
      .eq('email', session.email)
      
    if (error) {
      showToast(`Gagal memperbarui kata sandi: ${error.message}`, 'error')
      return
    }
    
    showToast('Kata sandi berhasil diperbarui!')
    password.current = ''
    password.new = ''
    password.confirm = ''
  } catch(e) {
    showToast('Terjadi kesalahan sistem saat menghubungi database!', 'error')
  }
}
</script>

<style scoped>
.toast-enter-active,
.toast-leave-active {
  transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.toast-enter-from {
  opacity: 0;
  transform: translate(-50%, -100%) scale(0.8);
}

.toast-leave-to {
  opacity: 0;
  transform: translate(-50%, -100%) scale(0.9);
}
</style>