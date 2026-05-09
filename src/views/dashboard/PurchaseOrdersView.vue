<template>
  <div class="h-full flex flex-col space-y-6">
    <!-- Header -->
    <div class="bg-white rounded-[2rem] shadow-sm border border-slate-100 p-6 flex flex-col sm:flex-row items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-black text-slate-800 tracking-tight">Purchase Orders</h1>
        <p class="text-sm font-bold text-slate-400 mt-1">Kelola penambahan stok dan faktur pembelian barang.</p>
      </div>
      
      <div class="flex items-center gap-2 bg-slate-50 p-1.5 rounded-2xl">
        <button 
          @click="activeTab = 'list'"
          class="px-6 py-2.5 rounded-xl text-xs font-black uppercase tracking-widest transition-all"
          :class="activeTab === 'list' ? 'bg-white text-indigo-600 shadow-sm' : 'text-slate-400 hover:text-slate-600'"
        >
          Daftar PO
        </button>
        <button 
          @click="activeTab = 'create'"
          class="px-6 py-2.5 rounded-xl text-xs font-black uppercase tracking-widest transition-all"
          :class="activeTab === 'create' ? 'bg-indigo-600 text-white shadow-md shadow-indigo-200' : 'text-slate-400 hover:text-slate-600'"
        >
          Buat PO Baru
        </button>
      </div>
    </div>

    <!-- Main Content Area -->
    <div class="flex-1 bg-white rounded-[2.5rem] shadow-sm border border-slate-100 overflow-hidden relative">
      
      <!-- TAB: LIST PO -->
      <div v-if="activeTab === 'list'" class="absolute inset-0 overflow-y-auto custom-scrollbar p-8">
        
        <div v-if="loading" class="flex flex-col items-center justify-center h-full text-slate-400">
          <svg class="animate-spin h-8 w-8 mb-4 text-indigo-500" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <span class="font-bold text-sm tracking-widest uppercase">Memuat Data...</span>
        </div>

        <div v-else-if="purchaseOrders.length === 0" class="flex flex-col items-center justify-center h-full text-slate-300">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 mb-4 opacity-50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <p class="font-black text-lg text-slate-400">Belum ada Purchase Order</p>
          <button @click="activeTab = 'create'" class="mt-4 text-indigo-500 font-bold hover:underline">Buat PO pertama Anda</button>
        </div>

        <div v-else class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
          <div 
            v-for="po in purchaseOrders" :key="po.id"
            class="group bg-white border border-slate-100 rounded-[2rem] p-6 hover:shadow-xl hover:shadow-indigo-900/5 transition-all duration-300 flex flex-col"
          >
            <!-- Header Card -->
            <div class="flex justify-between items-start mb-4">
              <div class="flex items-center gap-3">
                <div class="h-10 w-10 rounded-xl bg-slate-50 flex items-center justify-center text-slate-400">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                  </svg>
                </div>
                <div>
                  <h3 class="font-black text-slate-800 leading-tight">{{ getProductName(po.product_id) }}</h3>
                  <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mt-0.5">{{ po.supplier_name }}</p>
                </div>
              </div>
              
              <span 
                class="px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-widest"
                :class="{
                  'bg-amber-50 text-amber-600 border border-amber-200': po.status === 'PENDING',
                  'bg-emerald-50 text-emerald-600 border border-emerald-200': po.status === 'ACCEPTED',
                  'bg-rose-50 text-rose-600 border border-rose-200': po.status === 'REJECTED'
                }"
              >
                {{ po.status }}
              </span>
            </div>

            <!-- Details -->
            <div class="space-y-3 mb-6 flex-1">
              <div class="flex justify-between items-center text-sm">
                <span class="text-slate-500 font-semibold">Harga Masuk</span>
                <span class="font-black text-slate-700">Rp {{ formatNumber(po.incoming_price) }}</span>
              </div>
              <div class="flex justify-between items-center text-sm">
                <span class="text-slate-500 font-semibold">Jumlah (Qty)</span>
                <span class="font-black text-slate-700">{{ po.quantity }} Unit</span>
              </div>
              <div class="pt-3 border-t border-slate-50 flex justify-between items-center">
                <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Total Harga</span>
                <span class="text-lg font-black text-indigo-600 tracking-tight">Rp {{ formatNumber(po.total_price) }}</span>
              </div>
            </div>

            <!-- Actions & View Image -->
            <div class="mt-auto space-y-3">
              <button 
                v-if="po.invoice_image_url"
                @click="viewImage(po.invoice_image_url)"
                class="w-full py-3 bg-slate-50 hover:bg-slate-100 text-slate-600 font-bold rounded-xl text-xs transition-colors flex items-center justify-center gap-2"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
                Lihat Faktur
              </button>

              <div v-if="po.status === 'PENDING' && userRole === 'owner'" class="flex gap-2">
                <button 
                  @click="updateStatus(po, 'ACCEPTED')"
                  class="flex-1 bg-emerald-500 hover:bg-emerald-600 text-white py-3 rounded-xl font-bold text-xs shadow-lg shadow-emerald-500/20 transition-all"
                >
                  Terima
                </button>
                <button 
                  @click="updateStatus(po, 'REJECTED')"
                  class="flex-1 bg-white border-2 border-rose-100 hover:border-rose-500 hover:bg-rose-50 text-rose-500 py-3 rounded-xl font-bold text-xs transition-all"
                >
                  Tolak
                </button>
              </div>
              
              <div v-else-if="po.status === 'PENDING' && userRole !== 'owner'" class="text-center bg-slate-50 p-3 rounded-xl">
                <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Menunggu Persetujuan Owner</span>
              </div>
            </div>
            
            <div class="mt-4 text-center">
              <span class="text-[9px] text-slate-400 font-bold">Dibuat oleh: {{ po.created_by }} pada {{ formatDate(po.created_at) }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- TAB: CREATE PO -->
      <div v-else class="absolute inset-0 overflow-y-auto custom-scrollbar p-8 bg-slate-50/50">
        <div class="max-w-2xl mx-auto bg-white rounded-[2rem] shadow-sm border border-slate-100 p-8">
          <h2 class="text-xl font-black text-slate-800 mb-8 flex items-center gap-3">
            <div class="h-10 w-10 rounded-xl bg-indigo-50 flex items-center justify-center text-indigo-500">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
              </svg>
            </div>
            Formulir Purchase Order
          </h2>

          <form @submit.prevent="submitPO" class="space-y-6">
            
            <!-- Pilih Barang -->
            <div>
              <label class="block text-xs font-black text-slate-400 uppercase tracking-widest mb-2">Pilih Barang dari Inventory</label>
              <select v-model="form.product_id" required class="w-full bg-slate-50 border border-slate-200 px-4 py-4 rounded-2xl text-sm font-bold text-slate-700 outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all appearance-none">
                <option value="" disabled>-- Pilih Barang --</option>
                <option v-for="item in inventory" :key="item.id" :value="item.id">
                  {{ item.item_name }} (Stok saat ini: {{ item.quantity }})
                </option>
              </select>
            </div>

            <!-- Nama Supplier -->
            <div>
              <label class="block text-xs font-black text-slate-400 uppercase tracking-widest mb-2">Nama PT / Supplier</label>
              <input v-model="form.supplier_name" type="text" required placeholder="Contoh: PT. Sumber Makmur" class="w-full bg-slate-50 border border-slate-200 px-4 py-4 rounded-2xl text-sm font-bold text-slate-700 outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all" />
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Harga Masuk -->
              <div>
                <label class="block text-xs font-black text-slate-400 uppercase tracking-widest mb-2">Harga Masuk (Satuan)</label>
                <div class="relative">
                  <span class="absolute left-4 top-1/2 -translate-y-1/2 font-black text-slate-400 text-xs">Rp</span>
                  <input v-model.number="form.incoming_price" type="number" min="0" required class="w-full pl-10 pr-4 py-4 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-black text-slate-700 outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all" />
                </div>
              </div>

              <!-- Qty -->
              <div>
                <label class="block text-xs font-black text-slate-400 uppercase tracking-widest mb-2">Jumlah Barang</label>
                <input v-model.number="form.quantity" type="number" min="1" required class="w-full px-4 py-4 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-black text-slate-700 outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all" />
              </div>
            </div>

            <!-- Total Preview -->
            <div class="p-6 bg-indigo-50 rounded-2xl border border-indigo-100 flex items-center justify-between">
              <div>
                <span class="text-[10px] font-black text-indigo-400 uppercase tracking-widest block mb-1">Total Estimasi Pembelian</span>
                <span class="text-2xl font-black text-indigo-700 tracking-tight">Rp {{ formatNumber(calculatedTotal) }}</span>
              </div>
              <div class="h-12 w-12 rounded-full bg-white flex items-center justify-center shadow-sm">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                </svg>
              </div>
            </div>

            <!-- Upload Faktur -->
            <div>
              <label class="block text-xs font-black text-slate-400 uppercase tracking-widest mb-2">Foto Faktur Pembelian</label>
              <div class="relative border-2 border-dashed border-slate-300 rounded-2xl p-8 text-center hover:border-indigo-400 transition-colors bg-slate-50 group">
                <input type="file" accept="image/*" @change="handleFileUpload" class="absolute inset-0 w-full h-full opacity-0 cursor-pointer" />
                
                <div v-if="!form.invoice_image_url" class="flex flex-col items-center pointer-events-none">
                  <div class="h-12 w-12 rounded-xl bg-white shadow-sm flex items-center justify-center text-slate-400 group-hover:text-indigo-500 group-hover:scale-110 transition-all mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <span class="text-sm font-bold text-slate-600">Klik atau seret foto faktur ke sini</span>
                  <span class="text-xs font-semibold text-slate-400 mt-1">Maks. 5MB (JPG, PNG)</span>
                </div>

                <div v-else class="flex flex-col items-center">
                  <img :src="form.invoice_image_url" alt="Preview" class="h-32 object-contain rounded-lg shadow-sm border border-slate-200 mb-3" />
                  <span class="text-xs font-bold text-indigo-600 bg-indigo-50 px-3 py-1 rounded-full">Foto berhasil dilampirkan. Klik untuk ganti.</span>
                </div>
              </div>
            </div>

            <div class="pt-4 border-t border-slate-100">
              <button 
                type="submit" 
                :disabled="isSubmitting"
                class="w-full bg-slate-900 text-white py-5 rounded-2xl font-black text-sm tracking-widest uppercase hover:bg-brand hover:shadow-xl hover:shadow-brand/20 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3"
              >
                <svg v-if="isSubmitting" class="animate-spin h-5 w-5" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                {{ isSubmitting ? 'MENYIMPAN...' : 'SIMPAN PURCHASE ORDER' }}
              </button>
            </div>

          </form>
        </div>
      </div>

    </div>

    <!-- Image Modal -->
    <div v-if="selectedImage" class="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-10" @click="selectedImage = null">
      <div class="absolute inset-0 bg-slate-900/80 backdrop-blur-sm"></div>
      <div class="relative max-h-full max-w-4xl w-full flex justify-center" @click.stop>
        <button @click="selectedImage = null" class="absolute -top-12 right-0 text-white hover:text-rose-400 transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
        <img :src="selectedImage" class="max-h-[85vh] w-auto rounded-2xl shadow-2xl" alt="Faktur Full" />
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '../../lib/supabase'

const activeTab = ref('list')
const loading = ref(false)
const isSubmitting = ref(false)
const inventory = ref([])
const purchaseOrders = ref([])
const userRole = ref('admin')
const userName = ref('User')
const selectedImage = ref(null)

const form = ref({
  product_id: '',
  supplier_name: '',
  incoming_price: 0,
  quantity: 1,
  invoice_image_url: null
})

const calculatedTotal = computed(() => {
  return (form.value.incoming_price || 0) * (form.value.quantity || 1)
})

const formatNumber = (num) => new Intl.NumberFormat('id-ID').format(num)

const formatDate = (dateString) => {
  if (!dateString) return '-'
  return new Date(dateString).toLocaleString('id-ID', {
    day: '2-digit', month: 'short', year: 'numeric',
    hour: '2-digit', minute:'2-digit'
  })
}

const getProductName = (id) => {
  const item = inventory.value.find(i => i.id === id)
  return item ? item.item_name : 'Barang Tidak Diketahui'
}

const loadSession = () => {
  const session = JSON.parse(localStorage.getItem('userSession') || '{}')
  userRole.value = session.role || 'admin'
  userName.value = session.name || 'User'
}

const fetchData = async () => {
  loading.value = true
  
  // Fetch Inventory
  const { data: invData } = await supabase.from('inventory_retail').select('id, item_name, quantity').order('item_name')
  if (invData) inventory.value = invData

  // Fetch POs
  const { data: poData } = await supabase.from('purchase_orders').select('*').order('created_at', { ascending: false })
  if (poData) purchaseOrders.value = poData

  loading.value = false
}

// Convert image to Base64 (to avoid complex storage setup for prototype)
const handleFileUpload = (e) => {
  const file = e.target.files[0]
  if (!file) return
  
  if (file.size > 5 * 1024 * 1024) {
    alert("Ukuran file terlalu besar! Maksimal 5MB.")
    return
  }

  const reader = new FileReader()
  reader.onload = (event) => {
    form.value.invoice_image_url = event.target.result
  }
  reader.readAsDataURL(file)
}

const submitPO = async () => {
  if (!form.value.product_id) return alert("Pilih barang terlebih dahulu!")
  
  isSubmitting.value = true
  
  const { error } = await supabase.from('purchase_orders').insert({
    product_id: form.value.product_id,
    supplier_name: form.value.supplier_name,
    incoming_price: form.value.incoming_price,
    quantity: form.value.quantity,
    total_price: calculatedTotal.value,
    invoice_image_url: form.value.invoice_image_url,
    status: 'PENDING',
    created_by: userName.value
  })

  isSubmitting.value = false

  if (error) {
    alert("Gagal menyimpan PO: " + error.message)
  } else {
    alert("PO Berhasil Dibuat dan Menunggu Persetujuan Owner!")
    form.value = { product_id: '', supplier_name: '', incoming_price: 0, quantity: 1, invoice_image_url: null }
    activeTab.value = 'list'
    fetchData()
  }
}

const updateStatus = async (po, newStatus) => {
  if (userRole.value !== 'owner') {
    alert("Hanya Owner yang dapat melakukan ini.")
    return
  }

  const confirmMsg = newStatus === 'ACCEPTED' ? 'Terima PO ini dan tambahkan stok?' : 'Tolak PO ini?'
  if (!confirm(confirmMsg)) return

  // 1. Update PO Status
  const { error: poError } = await supabase
    .from('purchase_orders')
    .update({ status: newStatus })
    .eq('id', po.id)

  if (poError) {
    alert("Gagal update status: " + poError.message)
    return
  }

  // 2. Jika ACCEPTED, tambahkan ke stok Inventory
  if (newStatus === 'ACCEPTED') {
    // Ambil qty sekarang
    const item = inventory.value.find(i => i.id === po.product_id)
    if (item) {
      const newQty = Number(item.quantity) + Number(po.quantity)
      const { error: invError } = await supabase
        .from('inventory_retail')
        .update({ quantity: newQty, status: 'Tersedia' }) // pastikan status 'Tersedia' jika asalnya habis
        .eq('id', po.product_id)
      
      if (invError) {
        alert("Status PO diterima, tetapi gagal update stok inventory: " + invError.message)
      }
    }
  }

  fetchData() // Refresh data
}

const viewImage = (url) => {
  selectedImage.value = url
}

onMounted(() => {
  loadSession()
  fetchData()
})
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 6px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: #cbd5e1;
  border-radius: 20px;
}
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input[type=number] {
  -moz-appearance: textfield;
}
</style>
