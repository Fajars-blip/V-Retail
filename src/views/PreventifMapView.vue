<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="text-3xl font-black text-slate-800 tracking-tight">Preventif Map</h1>
        <p class="text-slate-500 font-medium">Pemantauan status maintenance cabang secara real-time.</p>
      </div>
      <div class="flex items-center gap-3">
        <div class="flex -space-x-2">
          <div v-for="i in 3" :key="i" class="h-8 w-8 rounded-full border-2 border-white bg-slate-200 overflow-hidden">
            <img :src="`https://i.pravatar.cc/150?u=${i}`" alt="user" />
          </div>
        </div>
        <span class="text-xs font-bold text-slate-400">3 Teknisi Aktif</span>
        <!-- Settings Button -->
        <button @click="showSettings = true" class="flex items-center gap-2 px-4 py-2 bg-white border border-slate-200 text-slate-600 text-xs font-black rounded-xl shadow-sm hover:bg-indigo-50 hover:border-indigo-200 hover:text-indigo-600 active:scale-95 transition-all">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
          </svg>
          Pengaturan Siklus
        </button>
      </div>
    </div>

    <!-- Settings Modal -->
    <Transition name="fade">
      <div v-if="showSettings" class="fixed inset-0 z-[9999] flex items-center justify-center p-4" @click.self="showSettings = false">
        <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" @click="showSettings = false"></div>
        <div class="relative bg-white rounded-3xl shadow-2xl w-full max-w-[480px] border border-slate-100 flex flex-col" style="max-height:85vh;">
          
          <!-- Sticky Header -->
          <div class="flex items-center justify-between px-8 py-6 border-b border-slate-100 shrink-0">
            <div>
              <h3 class="text-base font-black text-slate-800">Pengaturan Siklus Maintenance</h3>
              <p class="text-xs text-slate-400 font-medium mt-0.5">Atur interval kunjungan per cabang · Tekan ESC untuk menutup</p>
            </div>
            <button @click="showSettings = false" class="h-9 w-9 rounded-xl bg-slate-100 flex items-center justify-center text-slate-400 hover:bg-red-50 hover:text-red-400 transition shrink-0">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
            </button>
          </div>

          <!-- Scrollable Body -->
          <div class="overflow-y-auto flex-1 px-8 py-5" style="scrollbar-width:thin;scrollbar-color:#c7d2fe transparent;">
            <div class="space-y-3">
              <div v-for="store in stores" :key="store.id" class="flex items-center justify-between p-4 bg-slate-50 hover:bg-indigo-50/50 rounded-2xl border border-slate-100 hover:border-indigo-100 transition-colors">
                <div class="flex items-center gap-3">
                  <div class="h-2.5 w-2.5 rounded-full shrink-0" :style="{ background: getStatus(store).color }"></div>
                  <div>
                    <div class="text-sm font-black text-slate-700">{{ store.name }}</div>
                    <div class="text-[10px] text-slate-400 font-bold mt-0.5">{{ store.area }}</div>
                  </div>
                </div>
                <div class="flex items-center gap-2 shrink-0">
                  <input
                    v-model.number="store.cycle"
                    type="number" min="1" max="365"
                    class="w-16 px-2 py-2 text-sm font-black text-indigo-600 bg-white rounded-xl outline-none text-center border border-indigo-100 focus:ring-2 focus:ring-indigo-300 focus:border-indigo-300 transition"
                    @change="refreshMarkers"
                  />
                  <span class="text-xs font-bold text-slate-400 w-6">hari</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Sticky Footer -->
          <div class="px-8 py-5 border-t border-slate-100 flex gap-3 shrink-0">
            <button @click="applyDefaultCycle" class="flex-1 py-3 bg-slate-100 text-slate-600 text-xs font-black rounded-2xl hover:bg-slate-200 transition">↺ Reset Semua (14 hari)</button>
            <button @click="showSettings = false; refreshMarkers()" class="flex-1 py-3 bg-indigo-600 text-white text-xs font-black rounded-2xl shadow-lg shadow-indigo-200 hover:bg-indigo-700 transition">✓ Terapkan</button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- Status Legend Bar -->
    <div class="bg-white rounded-2xl border border-slate-100 shadow-sm px-6 py-4 flex flex-wrap items-center gap-6">
      <div class="h-10 w-px bg-slate-100 hidden"></div>

      <!-- Legend -->
      <div class="flex items-center gap-5">
        <div class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Status:</div>
        <div class="flex items-center gap-2">
          <div class="h-3 w-8 rounded-full bg-[#2ecc71] shadow shadow-green-300"></div>
          <span class="text-xs font-bold text-slate-600">Baru saja dikunjungi (&gt;50%)</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="h-3 w-8 rounded-full bg-[#f1c40f] shadow shadow-yellow-200"></div>
          <span class="text-xs font-bold text-slate-600">Pertengahan sejak kunjungan (20-50%)</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="h-3 w-8 rounded-full bg-[#e74c3c] shadow shadow-red-200"></div>
          <span class="text-xs font-bold text-slate-600">Segera kunjungi (&lt;20%)</span>
        </div>
      </div>

      <div class="ml-auto">
        <button @click="refreshMarkers" class="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white text-xs font-black rounded-xl shadow-lg shadow-indigo-200 hover:bg-indigo-700 active:scale-95 transition-all">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
          </svg>
          Refresh
        </button>
      </div>
    </div>

    <!-- Map Frame -->
    <div class="relative group">
      <!-- Glow -->
      <div class="absolute -inset-1 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-[2.5rem] blur opacity-20 group-hover:opacity-35 transition duration-1000"></div>

      <div class="relative bg-white rounded-[2rem] shadow-xl border border-indigo-100 overflow-hidden">
        <!-- Frame Header -->
        <div class="px-8 py-5 border-b border-indigo-50 bg-indigo-50/30 flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="h-10 w-10 rounded-xl bg-indigo-600 flex items-center justify-center text-white shadow-lg shadow-indigo-200">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7" />
              </svg>
            </div>
            <div>
              <div class="text-sm font-black text-slate-800">Visualisasi Geografis</div>
              <div class="text-[10px] font-bold text-indigo-400 uppercase tracking-widest">Digital Twin System</div>
            </div>
          </div>
          <div class="flex items-center gap-4">
            <div class="flex items-center gap-2 px-3 py-1.5 bg-white rounded-lg shadow-sm text-xs font-bold text-slate-600">
              <span class="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></span>
              Live Tracking
            </div>
          </div>
        </div>

        <!-- Map -->
        <div class="relative h-[600px] w-full bg-slate-50">
          <div ref="mapRef" class="h-full w-full z-0" />

          <!-- Navigation D-Pad Overlay (bottom-right) -->
          <div class="absolute bottom-5 right-5 z-[500] select-none" style="filter:drop-shadow(0 4px 16px rgba(0,0,0,0.18));">
            <div class="bg-white/90 backdrop-blur-md rounded-2xl p-2 border border-white/60 flex flex-col items-center gap-1">

              <!-- Zoom In -->
              <button @click="mapZoom(1)" title="Zoom In"
                class="h-8 w-8 flex items-center justify-center rounded-xl bg-indigo-600 text-white hover:bg-indigo-700 active:scale-90 transition-all font-black text-base shadow">
                +
              </button>

              <div class="h-px w-6 bg-slate-200 my-0.5"></div>

              <!-- D-Pad row: Left / Up+Down / Right -->
              <div class="flex items-center gap-1">
                <button @click="mapPan(-200, 0)" title="Geser Kiri"
                  class="h-8 w-8 flex items-center justify-center rounded-xl bg-slate-100 hover:bg-indigo-100 text-slate-600 hover:text-indigo-600 active:scale-90 transition-all">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/></svg>
                </button>

                <div class="flex flex-col gap-1">
                  <button @click="mapPan(0, -200)" title="Geser Atas"
                    class="h-8 w-8 flex items-center justify-center rounded-xl bg-slate-100 hover:bg-indigo-100 text-slate-600 hover:text-indigo-600 active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M5 15l7-7 7 7"/></svg>
                  </button>
                  <!-- Center dot -->
                  <div class="h-8 w-8 flex items-center justify-center rounded-xl bg-slate-50 border border-slate-100">
                    <div class="h-2 w-2 rounded-full bg-indigo-300"></div>
                  </div>
                  <button @click="mapPan(0, 200)" title="Geser Bawah"
                    class="h-8 w-8 flex items-center justify-center rounded-xl bg-slate-100 hover:bg-indigo-100 text-slate-600 hover:text-indigo-600 active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"/></svg>
                  </button>
                </div>

                <button @click="mapPan(200, 0)" title="Geser Kanan"
                  class="h-8 w-8 flex items-center justify-center rounded-xl bg-slate-100 hover:bg-indigo-100 text-slate-600 hover:text-indigo-600 active:scale-90 transition-all">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/></svg>
                </button>
              </div>

              <div class="h-px w-6 bg-slate-200 my-0.5"></div>

              <!-- Zoom Out -->
              <button @click="mapZoom(-1)" title="Zoom Out"
                class="h-8 w-8 flex items-center justify-center rounded-xl bg-slate-100 hover:bg-red-50 text-slate-600 hover:text-red-500 active:scale-90 transition-all font-black text-base shadow-sm">
                −
              </button>

              <!-- Fit All -->
              <button @click="mapFitAll" title="Tampilkan Semua Cabang"
                class="mt-1 h-8 w-8 flex items-center justify-center rounded-xl bg-emerald-50 hover:bg-emerald-100 text-emerald-600 active:scale-90 transition-all">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"/></svg>
              </button>

            </div>
          </div>
        </div>

      </div>
    </div>

    <!-- Location Cards Below Map -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div
        v-for="store in stores"
        :key="store.id"
        class="bg-white rounded-2xl border border-slate-100 shadow-sm p-5 hover:shadow-md hover:-translate-y-0.5 transition-all cursor-pointer"
        @click="flyToStore(store)"
      >
        <div class="flex items-start justify-between mb-3">
          <div>
            <div class="font-black text-slate-800 text-sm">{{ store.name }}</div>
            <div class="text-[10px] text-slate-400 font-bold mt-0.5">{{ getStatus(store).diffDays }} hari sejak kunjungan</div>
          </div>
          <div
            class="px-2 py-1 rounded-lg text-[9px] font-black uppercase tracking-widest"
            :style="{ background: getStatus(store).color + '20', color: getStatus(store).color }"
          >
            {{ getStatus(store).label }}
          </div>
        </div>

        <!-- Battery Bar -->
        <div class="flex items-center gap-2">
          <div class="flex-1 h-3 bg-slate-100 rounded-full overflow-hidden relative">
            <div
              class="h-full rounded-full transition-all duration-700"
              :style="{
                width: getStatus(store).percent + '%',
                background: getStatus(store).color,
                boxShadow: `0 0 8px ${getStatus(store).color}80`
              }"
            ></div>
          </div>
          <!-- Battery cap -->
          <div class="h-2 w-1 rounded-r-sm flex-shrink-0" :style="{ background: getStatus(store).color }"></div>
          <span class="text-[10px] font-black w-8 text-right" :style="{ color: getStatus(store).color }">
            {{ Math.round(getStatus(store).percent) }}%
          </span>
        </div>

        <button
          @click.stop="checkIn(store.id)"
          class="mt-4 w-full py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all active:scale-95"
          :style="{
            background: getStatus(store).color,
            color: 'white',
            boxShadow: `0 4px 12px ${getStatus(store).color}40`
          }"
        >
          ✓ Checklist Maintenance
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import 'leaflet/dist/leaflet.css'
import { onMounted, onUnmounted, ref } from 'vue'
import L from 'leaflet'

const mapRef = ref(null)
let map
const markers = {}
let refreshInterval = null

// Configurable cycle days (default 14 days)
const cycledays = ref(14)

const showSettings = ref(false)

const stores = ref([
  { id:  1, name: 'Kudus',          area: 'Kab. Kudus, Jawa Tengah',         lat: -6.8057,  lng: 110.8418, last_visit: '2026-04-18', cycle: 14 },
  { id:  2, name: 'Pati',           area: 'Kab. Pati, Jawa Tengah',          lat: -6.7502,  lng: 111.0391, last_visit: '2026-04-10', cycle: 14 },
  { id:  3, name: 'Juana',          area: 'Kab. Pati, Jawa Tengah',          lat: -6.7282,  lng: 111.0789, last_visit: '2026-04-06', cycle: 14 },
  { id:  4, name: 'Rembang',        area: 'Kab. Rembang, Jawa Tengah',       lat: -6.7041,  lng: 111.3429, last_visit: '2026-04-15', cycle: 14 },
  { id:  5, name: 'Lasem',          area: 'Kab. Rembang, Jawa Tengah',       lat: -6.6924,  lng: 111.4449, last_visit: '2026-04-02', cycle: 14 },
  { id:  6, name: 'Sluke',          area: 'Kab. Rembang, Jawa Tengah',       lat: -6.6632,  lng: 111.5035, last_visit: '2026-04-20', cycle: 14 },
  { id:  7, name: 'Kragan',         area: 'Kab. Rembang, Jawa Tengah',       lat: -6.6812,  lng: 111.3890, last_visit: '2026-03-28', cycle: 14 },
  { id:  8, name: 'Blora',          area: 'Kab. Blora, Jawa Tengah',         lat: -6.9678,  lng: 111.4138, last_visit: '2026-04-12', cycle: 14 },
  { id:  9, name: 'Cepu',           area: 'Kab. Blora, Jawa Tengah',         lat: -7.1447,  lng: 111.5887, last_visit: '2026-04-08', cycle: 14 },
  { id: 10, name: 'Randublatung',   area: 'Kab. Blora, Jawa Tengah',         lat: -7.0455,  lng: 111.5218, last_visit: '2026-03-30', cycle: 14 },
  { id: 11, name: 'Purwodadi',      area: 'Kab. Grobogan, Jawa Tengah',      lat: -7.0855,  lng: 110.9158, last_visit: '2026-04-16', cycle: 14 },
  { id: 12, name: 'Tuban',          area: 'Kab. Tuban, Jawa Timur',          lat: -6.8996,  lng: 112.0481, last_visit: '2026-04-11', cycle: 14 },
  { id: 13, name: 'Jatirogo',       area: 'Kab. Tuban, Jawa Timur',          lat: -6.8742,  lng: 111.8128, last_visit: '2026-04-01', cycle: 14 },
  { id: 14, name: 'Bojonegoro',     area: 'Kab. Bojonegoro, Jawa Timur',     lat: -7.1507,  lng: 111.8818, last_visit: '2026-04-17', cycle: 14 },
  { id: 15, name: 'Malo',           area: 'Kab. Bojonegoro, Jawa Timur',     lat: -7.0732,  lng: 111.6732, last_visit: '2026-04-05', cycle: 14 },
  { id: 16, name: 'Babat',          area: 'Kab. Lamongan, Jawa Timur',       lat: -7.1042,  lng: 112.0101, last_visit: '2026-04-14', cycle: 14 },
  { id: 17, name: 'Ngawi',          area: 'Kab. Ngawi, Jawa Timur',          lat: -7.4064,  lng: 111.4481, last_visit: '2026-03-25', cycle: 14 },
  { id: 18, name: 'Tambakromo',     area: 'Kab. Pati, Jawa Tengah',          lat: -6.9231,  lng: 111.0589, last_visit: '2026-04-09', cycle: 14 },
])

const applyDefaultCycle = () => {
  stores.value.forEach(s => s.cycle = null)
  refreshMarkers()
}

// Calculates health % and color based on time since last visit (uses per-store cycle)
const calculateStatus = (store) => {
  const last = new Date(store.last_visit)
  const now = new Date()
  const diffDays = Math.floor((now - last) / (1000 * 60 * 60 * 24))
  const cycle = store.cycle || 14
  const percent = Math.max(0, Math.min(100, ((cycle - diffDays) / cycle) * 100))

  let color = '#2ecc71'
  let label = 'Baru saja dikunjungi'
  if (percent <= 20) { color = '#e74c3c'; label = 'Segera kunjungi' }
  else if (percent <= 50) { color = '#f1c40f'; label = 'Pertengahan sejak kunjungan' }

  return { percent, color, diffDays, label }
}

// Reactive wrapper for use in template
const getStatus = (store) => calculateStatus(store)

// Build SVG-based custom marker HTML with battery bar on top
const buildMarkerHtml = (store) => {
  const s = calculateStatus(store)
  const pct = Math.round(s.percent)
  const color = s.color

  // Battery bar segments (5 bars)
  const totalBars = 5
  const filledBars = Math.round((pct / 100) * totalBars)

  let barSegments = ''
  for (let i = 0; i < totalBars; i++) {
    const filled = i < filledBars
    barSegments += `<div style="
      flex:1;
      height:100%;
      border-radius:2px;
      background:${filled ? color : 'rgba(0,0,0,0.08)'};
      ${filled ? `box-shadow:0 0 4px ${color}80;` : ''}
      transition:all 0.5s;
    "></div>`
  }

  return `
    <div style="display:flex;flex-direction:column;align-items:center;gap:4px;pointer-events:none;user-select:none;">
      <!-- Battery Widget -->
      <div style="
        background:rgba(255,255,255,0.95);
        border-radius:10px;
        padding:5px 8px;
        box-shadow:0 4px 15px rgba(0,0,0,0.15);
        border:1px solid rgba(255,255,255,0.8);
        min-width:80px;
        backdrop-filter:blur(8px);
      ">
        <div style="font-size:9px;font-weight:900;color:#94a3b8;letter-spacing:0.1em;text-transform:uppercase;text-align:center;margin-bottom:4px;">${store.name}</div>
        <!-- Battery shell -->
        <div style="display:flex;align-items:center;gap:2px;">
          <div style="
            display:flex;
            gap:2px;
            flex:1;
            height:10px;
            background:rgba(0,0,0,0.05);
            border-radius:3px;
            padding:1.5px;
            border:1px solid rgba(0,0,0,0.08);
          ">
            ${barSegments}
          </div>
          <!-- Battery cap nub -->
          <div style="width:3px;height:5px;background:${color};border-radius:0 2px 2px 0;opacity:0.8;"></div>
        </div>
        <div style="font-size:8px;font-weight:900;color:${color};text-align:center;margin-top:3px;">${pct}%</div>
      </div>
      <!-- Pin -->
      <div style="
        width:14px;height:14px;
        background:${color};
        border-radius:50% 50% 50% 0;
        transform:rotate(-45deg);
        border:2px solid white;
        box-shadow:0 3px 8px rgba(0,0,0,0.25);
      "></div>
    </div>
  `
}

// Build popup content element
const buildPopupElement = (store) => {
  const s = calculateStatus(store)
  const container = document.createElement('div')
  container.style.cssText = 'min-width:180px;padding:4px;'

  container.innerHTML = `
    <h3 style="font-size:13px;font-weight:900;color:#1e293b;margin-bottom:12px;text-align:center;">${store.name}</h3>
    <div style="margin-bottom:8px;">
      <div style="font-size:9px;font-weight:800;color:#94a3b8;text-transform:uppercase;letter-spacing:0.1em;margin-bottom:4px;">Status Baterai</div>
      <div style="display:flex;align-items:center;gap:4px;">
        <div style="flex:1;height:12px;background:#f1f5f9;border-radius:99px;overflow:hidden;border:1px solid #e2e8f0;">
          <div style="height:100%;width:${s.percent}%;background:${s.color};border-radius:99px;box-shadow:0 0 8px ${s.color}60;transition:width 0.6s;"></div>
        </div>
        <div style="width:4px;height:6px;background:${s.color};border-radius:0 2px 2px 0;"></div>
        <span style="font-size:10px;font-weight:900;color:${s.color};width:28px;text-align:right;">${Math.round(s.percent)}%</span>
      </div>
    </div>
    <div style="font-size:10px;font-weight:700;color:#64748b;text-align:center;margin-bottom:12px;">
      Kunjungan ${s.diffDays} hari lalu · Siklus ${store.cycle || 14} hari
    </div>
  `

  const btn = document.createElement('button')
  btn.style.cssText = `
    width:100%;padding:8px 12px;border-radius:12px;
    background:${s.color};color:white;font-size:10px;
    font-weight:900;letter-spacing:0.1em;text-transform:uppercase;
    border:none;cursor:pointer;
    box-shadow:0 4px 12px ${s.color}40;
    transition:all 0.2s;
  `
  btn.textContent = '✓ CHECKLIST MAINTENANCE'
  btn.onclick = () => checkIn(store.id)
  container.appendChild(btn)

  return container
}

// Place/update all markers
const renderMarkers = () => {
  if (!map) return
  stores.value.forEach((store) => {
    const icon = L.divIcon({
      className: '',
      html: buildMarkerHtml(store),
      iconSize: [90, 70],
      iconAnchor: [45, 70],
      popupAnchor: [0, -75]
    })

    if (markers[store.id]) {
      markers[store.id].setIcon(icon)
      markers[store.id].setPopupContent(buildPopupElement(store))
    } else {
      const marker = L.marker([store.lat, store.lng], { icon }).addTo(map)
      marker.bindPopup(buildPopupElement(store), {
        maxWidth: 240,
        closeButton: false,
      })
      markers[store.id] = marker
    }
  })
}

const refreshMarkers = () => renderMarkers()

const flyToStore = (store) => {
  if (!map) return
  map.flyTo([store.lat, store.lng], 15, { animate: true, duration: 1 })
  setTimeout(() => markers[store.id]?.openPopup(), 900)
}

const checkIn = (id) => {
  const store = stores.value.find((s) => s.id === id)
  if (!store) return
  store.last_visit = new Date().toISOString().split('T')[0]
  renderMarkers()
  // Close any open popup and reopen with fresh data
  setTimeout(() => {
    markers[id]?.closePopup()
    markers[id]?.openPopup()
  }, 100)
  window.alert(`✅ Maintenance Checklist Berhasil!\n${store.name} — baterai direset ke 100%`)
}

// Auto-refresh every 60s so the bar degrades in near-real-time
const startAutoRefresh = () => {
  refreshInterval = setInterval(() => renderMarkers(), 60_000)
}

onMounted(() => {
  // ESC key closes settings modal
  window.addEventListener('keydown', handleKeydown)

  if (mapRef.value) {
    map = L.map(mapRef.value, { zoomControl: true }).setView([-6.95, 111.35], 8)

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors',
      maxZoom: 19
    }).addTo(map)

    setTimeout(() => {
      map.invalidateSize()
      renderMarkers()
    }, 150)

    startAutoRefresh()
  }
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
  clearInterval(refreshInterval)
  if (map) map.remove()
})

const handleKeydown = (e) => {
  if (e.key === 'Escape') showSettings.value = false
}

// Map navigation helpers
const mapZoom = (delta) => {
  if (!map) return
  map.setZoom(map.getZoom() + delta)
}

const mapPan = (dx, dy) => {
  if (!map) return
  map.panBy([dx, dy], { animate: true, duration: 0.4 })
}

const mapFitAll = () => {
  if (!map || stores.value.length === 0) return
  const bounds = L.latLngBounds(stores.value.map(s => [s.lat, s.lng]))
  map.fitBounds(bounds, { padding: [50, 50], animate: true, duration: 0.8 })
}
</script>

<style>
/* Leaflet popup custom style */
.leaflet-popup-content-wrapper {
  border-radius: 1.5rem !important;
  padding: 10px !important;
  box-shadow: 0 20px 40px -8px rgba(0,0,0,0.15), 0 8px 16px -4px rgba(0,0,0,0.08) !important;
  border: 1px solid rgba(255,255,255,0.8) !important;
  backdrop-filter: blur(12px);
}
.leaflet-popup-tip-container {
  display: none !important;
}
.leaflet-popup-content {
  margin: 4px !important;
}

/* Modal fade transition */
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>