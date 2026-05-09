<template>
  <div class="pos-wrapper w-full h-full">
    <div class="screen-only flex flex-col lg:flex-row gap-6 bg-[#f8f9fe] min-h-full transition-all duration-300" :class="scaleClass">
    
    <!-- Left/Center: Transaction Table -->
    <div class="flex-1 flex flex-col space-y-6">
      <!-- Top Search & Scale Settings Area -->
      <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-slate-100 flex flex-col md:flex-row items-center gap-4">
        <div class="relative group flex-1">
          <span class="absolute left-5 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-brand transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </span>
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="Cari nama barang..." 
            class="w-full pl-12 pr-6 py-4 bg-slate-50 rounded-2xl border-2 border-transparent focus:border-brand/20 focus:bg-white outline-none transition-all font-bold"
            @keyup.enter="handleSearchEnter"
          />
          
          <!-- Search Results Dropdown -->
          <div v-if="searchResults.length > 0 && searchQuery" class="absolute left-0 right-0 top-full mt-2 bg-white rounded-2xl shadow-2xl border border-slate-100 z-50 max-h-60 overflow-y-auto overflow-x-hidden">
            <div 
              v-for="item in searchResults" 
              :key="item.id"
              @click="addItemToTransaction(item)"
              class="px-6 py-4 hover:bg-brand/5 cursor-pointer flex items-center justify-between border-b border-slate-50 last:border-b-0"
            >
              <div>
                <div class="font-bold text-slate-800">{{ item.item_name }}</div>
                <div class="text-[10px] text-slate-400 font-bold">Stok: {{ item.quantity }} | {{ item.category }}</div>
              </div>
              <div class="text-brand font-black text-sm">
                Rp {{ formatNumber(getPrice(item)) }}
              </div>
            </div>
          </div>
        </div>

        <!-- Scale Controls -->
        <div class="flex items-center gap-2 bg-slate-100 p-1.5 rounded-2xl shrink-0">
          <button 
            v-for="s in ['small', 'normal', 'large']" 
            :key="s"
            @click="displayScale = s"
            class="px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all"
            :class="displayScale === s ? 'bg-white text-brand shadow-sm' : 'text-slate-400 hover:text-slate-600'"
          >
            {{ s === 'small' ? 'Compact' : (s === 'normal' ? 'Standar' : 'Besar') }}
          </button>
        </div>
      </div>

      <!-- Main Transaction Table -->
      <div class="flex-1 bg-white rounded-[2rem] shadow-sm border border-slate-100 overflow-hidden flex flex-col">
        <div class="px-8 py-5 border-b border-slate-50 flex items-center justify-between">
          <h2 class="text-lg font-black text-slate-800">Item Transaksi</h2>
          <span class="px-3 py-1 bg-slate-100 rounded-full text-[10px] font-bold text-slate-400 uppercase tracking-[0.2em]">
            {{ transactionList.length }} Item
          </span>
        </div>

        <div class="flex-1 overflow-y-auto no-scrollbar">
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="text-[9px] uppercase tracking-[0.3em] text-slate-400 font-black border-b border-slate-50">
                <th class="px-8 py-4">Produk</th>
                <th class="px-6 py-4 text-center">Harga</th>
                <th class="px-6 py-4 text-center">Qty</th>
                <th class="px-6 py-4 text-right">Subtotal</th>
                <th class="px-8 py-4"></th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-50">
              <tr v-if="transactionList.length === 0">
                <td colspan="5" class="px-8 py-16 text-center">
                  <div class="flex flex-col items-center opacity-10">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
                    </svg>
                    <p class="font-black">Belum ada barang</p>
                  </div>
                </td>
              </tr>
              <tr v-for="(item, index) in transactionList" :key="index" class="group hover:bg-slate-50/50 transition-colors">
                <td class="px-8 py-4">
                  <div class="font-bold text-slate-800 leading-tight">{{ item.item_name }}</div>
                  <div class="text-[9px] text-slate-400 font-black uppercase tracking-tighter">{{ item.category }}</div>
                </td>
                <td class="px-6 py-4 text-center font-bold text-slate-600 text-xs">
                  Rp {{ formatNumber(item.price) }}
                </td>
                <td class="px-6 py-4">
                  <div class="flex items-center justify-center gap-2 bg-slate-50 rounded-xl p-1 w-fit mx-auto border border-slate-100">
                    <button @click="updateQty(index, -1)" class="h-7 w-7 flex items-center justify-center rounded-lg bg-white shadow-sm hover:text-rose-500 transition-all font-black">-</button>
                    <span class="text-xs font-black w-5 text-center">{{ item.qty }}</span>
                    <button @click="updateQty(index, 1)" class="h-7 w-7 flex items-center justify-center rounded-lg bg-white shadow-sm hover:text-brand transition-all font-black">+</button>
                  </div>
                </td>
                <td class="px-6 py-4 text-right font-black text-slate-800 text-xs">
                  Rp {{ formatNumber(item.price * item.qty) }}
                </td>
                <td class="px-8 py-4 text-right">
                  <button @click="removeItem(index)" class="p-2 text-slate-300 hover:text-rose-500 transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Right: Checkout Sidebar -->
    <div class="w-full lg:w-[360px] shrink-0">
      <div class="sticky top-6 space-y-6">
        <!-- Summary Card -->
        <div class="bg-white rounded-[2.5rem] shadow-xl shadow-indigo-900/5 p-8 border border-slate-100">
          <div class="flex items-center gap-3 mb-6">
            <div class="h-10 w-10 rounded-xl bg-brand/10 flex items-center justify-center text-brand">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
              </svg>
            </div>
            <h2 class="text-lg font-black text-slate-800">Pembayaran</h2>
          </div>

          <div class="space-y-5">
            <div class="flex items-center justify-between">
              <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Subtotal</span>
              <span class="text-sm font-black text-slate-700">Rp {{ formatNumber(subtotal) }}</span>
            </div>

            <div class="flex items-center justify-between">
              <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Diskon (%)</span>
              <input v-model.number="discount" type="number" min="0" max="100" class="w-16 px-2 py-1.5 bg-slate-50 rounded-xl text-right font-black text-brand outline-none focus:ring-2 focus:ring-brand/20 border-none text-xs" />
            </div>

            <div class="pt-5 border-t-2 border-slate-50 border-dashed">
              <div class="flex flex-col gap-0.5">
                <span class="text-[9px] font-black text-slate-400 uppercase tracking-[0.3em]">Total Akhir</span>
                <div class="text-3xl font-black text-slate-900 tracking-tight">Rp {{ formatNumber(totalPrice) }}</div>
              </div>
            </div>

            <div class="pt-6 space-y-4">
              <!-- Payment Method Selection -->
              <div>
                <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest block mb-2">Metode Pembayaran</label>
                <div class="grid grid-cols-2 gap-2">
                  <button 
                    v-for="method in ['TUNAI', 'QRIS', 'TRANSFER', 'KARTU']" 
                    :key="method"
                    @click="setPaymentMethod(method)"
                    class="py-2 px-3 rounded-xl text-xs font-bold transition-all border"
                    :class="paymentMethod === method ? 'bg-brand text-white border-brand shadow-md' : 'bg-white text-slate-600 border-slate-200 hover:border-brand/30'"
                  >
                    {{ method }}
                  </button>
                </div>
              </div>

              <div v-if="paymentMethod !== 'TUNAI'">
                <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest block mb-2">No. Referensi (Opsional)</label>
                <div class="relative">
                  <span class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                  </span>
                  <input 
                    v-model="paymentReference" 
                    type="text" 
                    class="w-full pl-10 pr-4 py-4 bg-slate-50 border border-slate-100 rounded-2xl font-bold text-sm text-slate-800 outline-none focus:ring-2 focus:ring-brand/20 focus:bg-white transition-all" 
                    placeholder="Contoh: INV-1234 / Trace No."
                  />
                </div>
              </div>

              <div v-if="paymentMethod === 'TUNAI'">
                <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest block mb-2">Nominal Bayar</label>
                <div class="relative">
                  <span class="absolute left-4 top-1/2 -translate-y-1/2 font-black text-slate-400 text-xs">Rp</span>
                  <input 
                    v-model.number="amountPaid" 
                    type="number" 
                    class="w-full pl-10 pr-6 py-4 bg-slate-900 rounded-2xl font-black text-xl text-brand outline-none focus:ring-4 focus:ring-brand/20" 
                    placeholder="0"
                  />
                </div>
              </div>

              <div v-if="paymentMethod === 'TUNAI'" class="p-4 bg-emerald-50 rounded-2xl border border-emerald-100">
                <div class="flex items-center justify-between">
                  <span class="text-[9px] font-black text-emerald-600 uppercase tracking-widest">Kembalian</span>
                  <span class="text-base font-black text-emerald-700">Rp {{ formatNumber(change) }}</span>
                </div>
              </div>

              <button 
                @click="processPayment"
                :disabled="transactionList.length === 0 || (paymentMethod === 'TUNAI' && amountPaid < totalPrice) || isProcessing"
                class="w-full bg-brand text-white py-5 rounded-3xl font-black text-sm shadow-xl shadow-brand/20 hover:bg-brand-dark hover:-translate-y-1 transition-all active:translate-y-0 disabled:opacity-30 disabled:translate-y-0 disabled:shadow-none flex items-center justify-center gap-3"
              >
                <svg v-if="isProcessing" class="animate-spin h-5 w-5" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                {{ isProcessing ? 'MEMPROSES...' : `BAYAR (${paymentMethod})` }}
              </button>
            </div>
          </div>
        </div>

        <!-- Session Card -->
        <div class="bg-[#1e1b4b] rounded-3xl p-6 text-white shadow-lg shadow-indigo-900/20">
          <div class="flex items-center gap-3">
            <div class="h-10 w-10 rounded-xl bg-white/10 flex items-center justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
            </div>
            <div>
              <div class="text-sm font-black">{{ userName }}</div>
              <div class="text-[9px] font-bold text-indigo-300 uppercase tracking-widest">Sesi Kasir Aktif</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Penutup untuk screen-only -->
    </div>

    <!-- Invoice Template (Hidden on screen, visible on print) -->
    <div class="print-invoice hidden">
      <div class="flex justify-between items-start mb-6 border-b-2 border-black pb-4">
        <div>
          <h2 class="text-2xl font-black mb-1 uppercase tracking-wider">PT. V WARE</h2>
          <p class="text-sm">Jl. Teknologi Hardware No. 99, Jakarta</p>
          <p class="text-sm">Telp: (021) 1234-5678</p>
        </div>
        <div class="text-right">
          <h3 class="text-xl font-bold uppercase mb-1">FAKTUR PENJUALAN</h3>
          <p class="text-sm font-bold">Tanggal: {{ receiptData.date }}</p>
          <p class="text-sm">Kasir: {{ userName }}</p>
        </div>
      </div>

      <table class="w-full text-sm mb-6">
        <thead>
          <tr class="border-b-2 border-black text-left">
            <th class="py-2">No</th>
            <th class="py-2">Nama Barang</th>
            <th class="py-2 text-center">Qty</th>
            <th class="py-2 text-right">Harga Satuan</th>
            <th class="py-2 text-right">Jumlah</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in receiptData.items" :key="index" class="border-b border-gray-300">
            <td class="py-3">{{ index + 1 }}</td>
            <td class="py-3 font-bold">{{ item.item_name }}</td>
            <td class="py-3 text-center">{{ item.qty }}</td>
            <td class="py-3 text-right">Rp {{ formatNumber(item.price) }}</td>
            <td class="py-3 text-right font-bold">Rp {{ formatNumber(item.price * item.qty) }}</td>
          </tr>
        </tbody>
      </table>

      <div class="flex justify-end text-sm">
        <div class="w-1/2 min-w-[250px]">
          <div class="flex justify-between py-1">
            <span>Subtotal:</span>
            <span>Rp {{ formatNumber(receiptData.subtotal) }}</span>
          </div>
          <div v-if="receiptData.discount > 0" class="flex justify-between py-1 text-gray-700">
            <span>Diskon ({{ receiptData.discount }}%):</span>
            <span>- Rp {{ formatNumber((receiptData.discount / 100) * receiptData.subtotal) }}</span>
          </div>
          <div class="flex justify-between py-3 mt-1 border-t-2 border-black font-black text-lg">
            <span>Total Akhir:</span>
            <span>Rp {{ formatNumber(receiptData.totalPrice) }}</span>
          </div>
          <div class="flex justify-between py-1 mt-2">
            <span>Metode:</span>
            <span class="font-bold">{{ receiptData.paymentMethod }}</span>
          </div>
          <div v-if="receiptData.paymentMethod !== 'TUNAI' && receiptData.paymentReference" class="flex justify-between py-1">
            <span>No. Referensi:</span>
            <span class="font-bold text-xs">{{ receiptData.paymentReference }}</span>
          </div>
          <template v-if="receiptData.paymentMethod === 'TUNAI'">
            <div class="flex justify-between py-1 mt-1">
              <span>Dibayar:</span>
              <span>Rp {{ formatNumber(receiptData.amountPaid) }}</span>
            </div>
            <div class="flex justify-between py-1 font-bold">
              <span>Kembali:</span>
              <span>Rp {{ formatNumber(receiptData.change) }}</span>
            </div>
          </template>
        </div>
      </div>

      <div class="mt-16 flex justify-between text-sm text-center px-10">
        <div>
          <p class="mb-16">Penerima / Pembeli</p>
          <p class="border-t border-black inline-block px-8">( ............................ )</p>
        </div>
        <div>
          <p class="mb-16">Hormat Kami</p>
          <p class="border-t border-black inline-block px-8">( {{ userName }} )</p>
        </div>
      </div>
      
      <div class="mt-12 text-xs text-center text-gray-600 border-t border-gray-300 pt-4">
        <p>Barang yang sudah dibeli tidak dapat ditukar atau dikembalikan, kecuali ada perjanjian khusus.</p>
        <p>Terima kasih atas kepercayaan Anda berbelanja di PT. V WARE.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '../../lib/supabase'

const loading = ref(false)
const isProcessing = ref(false)
const inventory = ref([])
const transactionList = ref([])
const searchQuery = ref('')
const discount = ref(0)
const amountPaid = ref(0)
const paymentMethod = ref('TUNAI')
const paymentReference = ref('')
const userName = ref('Admin')
const displayScale = ref('small')

const receiptData = ref({
  items: [],
  subtotal: 0,
  discount: 0,
  totalPrice: 0,
  amountPaid: 0,
  change: 0,
  paymentMethod: 'TUNAI',
  paymentReference: '',
  date: ''
})

const scaleClass = computed(() => {
  return {
    'pos-scale-small': displayScale.value === 'small',
    'pos-scale-normal': displayScale.value === 'normal',
    'pos-scale-large': displayScale.value === 'large'
  }
})

// Mock prices based on category
const getPrice = (item) => {
  if (item.category === 'Hardware') return 1500000
  if (item.category === 'Consumable') return 50000
  if (item.category === 'Network') return 750000
  return 100000
}

const fetchInventory = async () => {
  loading.value = true
  const { data, error } = await supabase.from('inventory_retail').select('*').order('item_name')
  loading.value = false
  if (!error) inventory.value = data || []
}

const searchResults = computed(() => {
  if (!searchQuery.value) return []
  const q = searchQuery.value.toLowerCase()
  return inventory.value.filter(item => 
    item.item_name.toLowerCase().includes(q) && Number(item.quantity) > 0
  ).slice(0, 5)
})

const handleSearchEnter = () => {
  if (searchResults.value.length > 0) {
    addItemToTransaction(searchResults.value[0])
  }
}

const addItemToTransaction = (item) => {
  const existing = transactionList.value.find(t => t.id === item.id)
  if (existing) {
    if (existing.qty < Number(item.quantity)) {
      existing.qty++
    }
  } else {
    transactionList.value.push({
      id: item.id,
      item_name: item.item_name,
      category: item.category,
      price: getPrice(item),
      qty: 1,
      maxQty: Number(item.quantity)
    })
  }
  searchQuery.value = ''
}

const updateQty = (index, amount) => {
  const item = transactionList.value[index]
  const newQty = item.qty + amount
  if (newQty > 0 && newQty <= item.maxQty) {
    item.qty = newQty
  } else if (newQty === 0) {
    removeItem(index)
  }
}

const removeItem = (index) => {
  transactionList.value.splice(index, 1)
}

const subtotal = computed(() => {
  return transactionList.value.reduce((acc, item) => acc + (item.price * item.qty), 0)
})

const totalPrice = computed(() => {
  const discValue = (discount.value / 100) * subtotal.value
  return Math.max(0, subtotal.value - discValue)
})

const change = computed(() => {
  return Math.max(0, amountPaid.value - totalPrice.value)
})

const setPaymentMethod = (method) => {
  paymentMethod.value = method
  if (method !== 'TUNAI') {
    amountPaid.value = 0 // Reset, not used for non-cash UI
  }
}

const formatNumber = (num) => {
  return new Intl.NumberFormat('id-ID').format(num)
}

const processPayment = async () => {
  const finalAmountPaid = paymentMethod.value === 'TUNAI' ? amountPaid.value : totalPrice.value
  const finalChange = paymentMethod.value === 'TUNAI' ? change.value : 0

  if (transactionList.value.length === 0 || (paymentMethod.value === 'TUNAI' && finalAmountPaid < totalPrice.value)) return

  isProcessing.value = true
  let success = true

  // 1. Simpan data ke tabel transactions
  const { data: trxData, error: trxError } = await supabase
    .from('transactions')
    .insert({
      total_price: totalPrice.value,
      discount: discount.value,
      payment_nominal: finalAmountPaid,
      change_amount: finalChange,
      payment_method: paymentMethod.value,
      payment_reference: paymentMethod.value !== 'TUNAI' ? paymentReference.value : null
    })
    .select()
    .single()

  if (trxError) {
    success = false
    console.error('Error membuat transaksi:', trxError)
  } else {
    const transactionId = trxData.id

    // 2. Simpan setiap item ke transaction_items & update stok
    for (const item of transactionList.value) {
      // Insert rincian barang
      const { error: itemError } = await supabase
        .from('transaction_items')
        .insert({
          transaction_id: transactionId,
          product_id: item.id,
          quantity: item.qty,
          price_at_sale: item.price
        })

      if (itemError) {
        success = false
        console.error('Error menyimpan rincian barang:', itemError)
      }

      // Update stok inventory
      const { data: current } = await supabase.from('inventory_retail').select('quantity').eq('id', item.id).single()
      const newQty = Number(current.quantity) - item.qty
      const statusText = newQty <= 5 ? (newQty === 0 ? 'Habis' : 'Menipis') : 'Tersedia'

      const { error } = await supabase
        .from('inventory_retail')
        .update({ quantity: newQty, status: statusText })
        .eq('id', item.id)

      if (error) success = false
    }
  }

  isProcessing.value = false
  if (success) {
    // Siapkan data nota
    receiptData.value = {
      items: [...transactionList.value],
      subtotal: subtotal.value,
      discount: discount.value,
      totalPrice: totalPrice.value,
      amountPaid: finalAmountPaid,
      change: finalChange,
      paymentMethod: paymentMethod.value,
      paymentReference: paymentMethod.value !== 'TUNAI' ? paymentReference.value : '',
      date: new Date().toLocaleString('id-ID')
    }

    // Tunggu DOM update, lalu print struk
    setTimeout(() => {
      window.print()
      
      // Reset form setelah dialog print tertutup / struk diprint
      transactionList.value = []
      amountPaid.value = 0
      discount.value = 0
      paymentMethod.value = 'TUNAI'
      paymentReference.value = ''
      fetchInventory()
    }, 150)
  } else {
    window.alert('Terjadi kesalahan saat memproses transaksi.')
  }
}

onMounted(() => {
  fetchInventory()
  const session = JSON.parse(localStorage.getItem('userSession') || '{}')
  if (session.name) userName.value = session.name
})
</script>

<style scoped>
/* Scale Logic */
.pos-scale-small { transform-origin: top left; zoom: 0.85; }
.pos-scale-normal { zoom: 1; }
.pos-scale-large { zoom: 1.15; }

.no-scrollbar::-webkit-scrollbar { display: none; }
.no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
input[type=number] { -moz-appearance: textfield; }

/* Print Styles */
.print-invoice {
  display: none;
}

@media print {
  /* Sembunyikan elemen utama dan background color */
  body {
    background: white !important;
  }
  
  /* Sembunyikan semua elemen UI utama sepenuhnya dari alur dokumen */
  .screen-only {
    display: none !important;
  }
  
  /* Tampilkan hanya bagian faktur */
  .print-invoice {
    display: block !important;
    width: 100%;
    max-width: 210mm; /* Standar kertas A4/A5 */
    padding: 0;
    margin: 0 auto;
    font-family: 'Inter', sans-serif, monospace;
    color: black !important;
    background: white;
  }

  /* Hilangkan margin bawaan halaman saat print */
  @page {
    margin: 5mm;
  }
}
</style>
