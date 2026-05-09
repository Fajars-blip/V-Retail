<template>
  <div class="space-y-8">
    <!-- Header Area -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="text-3xl font-black text-slate-800 tracking-tight">Manajemen Inventory</h1>
        <p class="text-slate-500 font-medium">Pantau dan kelola stok perangkat hardware Anda.</p>
      </div>
      <button
        type="button"
        class="flex items-center justify-center gap-2 rounded-2xl bg-brand px-6 py-4 text-sm font-bold text-white shadow-xl shadow-brand/20 transition-all hover:bg-brand-dark hover:-translate-y-1 active:translate-y-0"
        @click="showModal = true"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4" />
        </svg>
        Tambah Item Baru
      </button>
    </div>

    <!-- Quick Stats -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <div v-for="stat in stats" :key="stat.label" class="bg-white p-6 rounded-3xl shadow-sm border border-slate-100">
        <div class="h-12 w-12 rounded-2xl flex items-center justify-center mb-4" :class="stat.bg">
          <component :is="stat.icon" class="h-6 w-6" :class="stat.color" />
        </div>
        <div class="text-2xl font-black text-slate-800">{{ stat.value }}</div>
        <div class="text-xs font-bold text-slate-400 uppercase tracking-widest">{{ stat.label }}</div>
      </div>
    </div>

    <!-- Inventory Table/Grid -->
    <div class="bg-white rounded-[2rem] shadow-sm border border-slate-100 overflow-hidden">
      <div class="p-6 border-b border-slate-50 flex items-center justify-between">
        <h3 class="font-bold text-slate-800">Daftar Stok Terkini</h3>
        <div class="flex items-center gap-2">
          <div class="relative">
            <input type="text" placeholder="Cari barang..." class="pl-10 pr-4 py-2 bg-slate-50 rounded-xl text-sm border-none focus:ring-2 focus:ring-brand/20 outline-none w-64" v-model="search" />
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
          <thead>
            <tr class="text-[10px] uppercase tracking-[0.2em] text-slate-400 font-black border-b border-slate-50">
              <th class="px-8 py-5">Barang</th>
              <th class="px-6 py-5">Kategori</th>
              <th class="px-6 py-5 text-center">Stok</th>
              <th class="px-6 py-5">Status</th>
              <th class="px-8 py-5 text-right">Aksi</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-50">
            <tr v-if="loading">
              <td colspan="5" class="px-8 py-10 text-center">
                <div class="flex flex-col items-center gap-3">
                  <div class="animate-spin h-8 w-8 border-4 border-brand border-t-transparent rounded-full"></div>
                  <span class="text-sm font-bold text-slate-400">Sinkronisasi data...</span>
                </div>
              </td>
            </tr>
            <tr v-else-if="filteredInventory.length === 0" class="text-center">
              <td colspan="5" class="px-8 py-12 text-slate-400 font-medium">Tidak ada barang ditemukan.</td>
            </tr>
            <tr v-for="item in filteredInventory" :key="item.id" class="group hover:bg-slate-50/50 transition-colors">
              <td class="px-8 py-5">
                <div class="flex items-center gap-4">
                  <div class="h-14 w-14 rounded-2xl bg-slate-100 overflow-hidden shrink-0 border border-slate-200/50 shadow-sm">
                    <img :src="getProductImage(item)" class="h-full w-full object-cover" />
                  </div>
                  <div>
                    <div class="font-bold text-slate-800">{{ item.item_name }}</div>
                    <div class="text-[10px] font-bold text-slate-400 uppercase">ID: #{{ item.id }}</div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-5">
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-wider" 
                  :class="getCategoryClass(item.category)">
                  <span class="h-1.5 w-1.5 rounded-full bg-current"></span>
                  {{ item.category }}
                </span>
              </td>
              <td class="px-6 py-5 text-center">
                <div class="text-sm font-black text-slate-800">{{ item.quantity }}</div>
                <div class="text-[9px] font-bold text-slate-400 uppercase tracking-tighter">{{ item.category === 'Consumable' ? 'Roll' : 'Unit' }}</div>
              </td>
              <td class="px-6 py-5">
                <div class="flex items-center gap-2">
                  <div class="h-2 w-2 rounded-full" :class="item.quantity <= 5 ? 'bg-rose-500 animate-pulse' : 'bg-emerald-500'"></div>
                  <span class="text-xs font-bold" :class="item.quantity <= 5 ? 'text-rose-600' : 'text-emerald-600'">
                    {{ item.quantity <= 5 ? (item.quantity === 0 ? 'Habis' : 'Menipis') : 'Tersedia' }}
                  </span>
                </div>
              </td>
              <td class="px-8 py-5 text-right">
                <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                  <button @click="editItem(item)" class="p-2 rounded-lg bg-white border border-slate-200 text-slate-400 hover:text-brand hover:border-brand transition-all shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                    </svg>
                  </button>
                  <button @click="deleteItem(item.id)" class="p-2 rounded-lg bg-white border border-slate-200 text-slate-400 hover:text-rose-500 hover:border-rose-500 transition-all shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal Tambah/Edit -->
    <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/40 backdrop-blur-sm">
      <div class="w-full max-w-lg bg-white rounded-[2.5rem] shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-300">
        <div class="p-8">
          <div class="flex items-center justify-between mb-8">
            <h3 class="text-2xl font-black text-slate-800">{{ editingId ? 'Update Barang' : 'Barang Baru' }}</h3>
            <button @click="closeModal" class="h-10 w-10 flex items-center justify-center rounded-full bg-slate-50 text-slate-400 hover:bg-slate-100 transition-colors">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <form class="space-y-6" @submit.prevent="saveInventoryItem">
            <div>
              <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2 block">Nama Barang</label>
              <input v-model="form.name" type="text" class="w-full rounded-2xl bg-slate-50 border-none px-5 py-4 text-sm font-bold text-slate-800 outline-none focus:ring-2 focus:ring-brand/20 transition-all" placeholder="Contoh: Monitor LG 24'" required />
            </div>
            
            <div class="grid grid-cols-2 gap-6">
              <div>
                <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2 block">Kategori</label>
                <select v-model="form.category" class="w-full rounded-2xl bg-slate-50 border-none px-5 py-4 text-sm font-bold text-slate-800 outline-none focus:ring-2 focus:ring-brand/20 transition-all appearance-none cursor-pointer">
                  <option value="Hardware">Hardware</option>
                  <option value="Consumable">Consumable</option>
                  <option value="Network">Network</option>
                </select>
              </div>
              <div>
                <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2 block">Jumlah Stok</label>
                <input v-model.number="form.quantity" type="number" min="0" class="w-full rounded-2xl bg-slate-50 border-none px-5 py-4 text-sm font-bold text-slate-800 outline-none focus:ring-2 focus:ring-brand/20 transition-all" placeholder="0" required />
              </div>
            </div>

            <div class="pt-4">
              <button type="submit" class="w-full rounded-2xl bg-brand py-5 text-sm font-black text-white shadow-xl shadow-brand/20 hover:bg-brand-dark transition-all flex items-center justify-center gap-3">
                {{ editingId ? 'Simpan Perubahan' : 'Tambahkan ke Inventory' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref, computed } from 'vue'
import { supabase } from '../../lib/supabase'

const loading = ref(false)
const showModal = ref(false)
const editingId = ref(null)
const inventory = ref([])
const search = ref('')

const form = reactive({
  name: '',
  category: 'Hardware',
  quantity: null
})

const stats = computed(() => [
  { label: 'Total Barang', value: inventory.value.length, icon: BoxIcon, color: 'text-brand', bg: 'bg-brand/10' },
  { label: 'Stok Menipis', value: inventory.value.filter(i => i.quantity <= 5 && i.quantity > 0).length, icon: AlertIcon, color: 'text-amber-500', bg: 'bg-amber-100' },
  { label: 'Habis', value: inventory.value.filter(i => i.quantity === 0).length, icon: XIcon, color: 'text-rose-500', bg: 'bg-rose-100' },
  { label: 'Kategori', value: [...new Set(inventory.value.map(i => i.category))].length, icon: CategoryIcon, color: 'text-indigo-500', bg: 'bg-indigo-100' }
])

const BoxIcon = { template: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" /></svg>' }
const AlertIcon = { template: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>' }
const XIcon = { template: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>' }
const CategoryIcon = { template: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" /></svg>' }

const getProductImage = (item) => {
  const name = item.item_name.toLowerCase()
  if (name.includes('cpu')) return 'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=200&q=80'
  if (name.includes('monitor')) return 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=200&q=80'
  if (name.includes('ssd')) return 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=200&q=80'
  
  if (item.category === 'Hardware') return 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=200&q=80'
  if (item.category === 'Consumable') return 'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?w=200&q=80'
  if (item.category === 'Network') return 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=200&q=80'
  return 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=200&q=80'
}

const getCategoryClass = (cat) => {
  if (cat === 'Hardware') return 'bg-indigo-50 text-indigo-600'
  if (cat === 'Consumable') return 'bg-amber-50 text-amber-600'
  if (cat === 'Network') return 'bg-teal-50 text-teal-600'
  return 'bg-slate-50 text-slate-600'
}

const fetchInventory = async () => {
  loading.value = true
  const { data, error } = await supabase.from('inventory_retail').select('*').order('id', { ascending: false })
  loading.value = false

  if (error) {
    window.alert(`Gagal: ${error.message}`)
    return
  }

  inventory.value = data || []
}

const filteredInventory = computed(() => {
  if (!search.value) return inventory.value
  const q = search.value.toLowerCase()
  return inventory.value.filter(i => 
    i.item_name.toLowerCase().includes(q) || 
    i.category.toLowerCase().includes(q)
  )
})

const saveInventoryItem = async () => {
  if (!form.name || form.quantity === null) return

  const statusText = form.quantity <= 5 ? (form.quantity === 0 ? 'Habis' : 'Menipis') : 'Tersedia'
  
  loading.value = true
  const payload = {
    item_name: form.name,
    category: form.category,
    quantity: form.quantity,
    status: statusText
  }

  let error
  if (editingId.value) {
    const { error: err } = await supabase.from('inventory_retail').update(payload).eq('id', editingId.value)
    error = err
  } else {
    const { error: err } = await supabase.from('inventory_retail').insert([payload])
    error = err
  }
  loading.value = false

  if (error) {
    window.alert(`Gagal menyimpan: ${error.message}`)
    return
  }

  closeModal()
  fetchInventory()
}

const editItem = (item) => {
  editingId.value = item.id
  form.name = item.item_name
  form.category = item.category
  form.quantity = item.quantity
  showModal.value = true
}

const deleteItem = async (id) => {
  if (!confirm('Hapus barang ini secara permanen?')) return
  
  const { error } = await supabase.from('inventory_retail').delete().eq('id', id)
  if (error) window.alert(error.message)
  else fetchInventory()
}

const closeModal = () => {
  showModal.value = false
  editingId.value = null
  form.name = ''
  form.category = 'Hardware'
  form.quantity = null
}

onMounted(fetchInventory)
</script>

<style scoped>
.animate-in {
  animation: animate-in 0.3s ease-out;
}
@keyframes animate-in {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}
</style>