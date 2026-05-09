<template>
  <div class="dashboard-home">

    <!-- ===== PENGUMUMAN PERUSAHAAN ===== -->
    <section class="section-block">
      <div class="section-header">
        <span class="section-icon">📢</span>
        <h2 class="section-title">Pengumuman Perusahaan</h2>
        <span class="badge-new">{{ announcements.length }} Baru</span>
      </div>

      <div class="announcements-list">
        <div
          v-for="ann in announcements"
          :key="ann.id"
          class="announcement-card"
          :class="'priority-' + ann.priority"
        >
          <div class="ann-left">
            <span class="ann-icon">{{ ann.icon }}</span>
          </div>
          <div class="ann-body">
            <div class="ann-meta">
              <span class="ann-tag" :class="'tag-' + ann.priority">{{ ann.tag }}</span>
              <span class="ann-date">{{ ann.date }}</span>
            </div>
            <p class="ann-title">{{ ann.title }}</p>
            <p class="ann-desc">{{ ann.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== KPI ===== -->
    <section class="section-block">
      <div class="section-header">
        <span class="section-icon">🎯</span>
        <h2 class="section-title">Key Performance Indicators</h2>
        <span class="period-label">April 2026</span>
      </div>

      <div class="kpi-grid">
        <div
          v-for="kpi in kpiCards"
          :key="kpi.label"
          class="kpi-card"
        >
          <div class="kpi-top">
            <span class="kpi-icon">{{ kpi.icon }}</span>
            <span class="kpi-trend" :class="kpi.positive ? 'trend-up' : 'trend-down'">
              {{ kpi.positive ? '▲' : '▼' }} {{ kpi.change }}
            </span>
          </div>
          <p class="kpi-value">{{ kpi.value }}</p>
          <p class="kpi-label">{{ kpi.label }}</p>
          <div class="kpi-progress-bar">
            <div class="kpi-progress-fill" :style="{ width: kpi.progress + '%', background: kpi.color }"></div>
          </div>
          <p class="kpi-target">Target: {{ kpi.target }}</p>
        </div>
      </div>
    </section>

    <!-- ===== HASIL PENJUALAN ===== -->
    <section class="section-block">
      <div class="section-header">
        <span class="section-icon">📊</span>
        <h2 class="section-title">Hasil Penjualan</h2>
        <span class="period-label">Q1–Q2 2026</span>
      </div>

      <!-- Summary Row -->
      <div class="sales-summary-row">
        <div v-for="s in salesSummary" :key="s.label" class="sales-summary-card">
          <p class="ss-label">{{ s.label }}</p>
          <p class="ss-value">{{ s.value }}</p>
          <p class="ss-sub" :class="s.positive ? 'pos' : 'neg'">{{ s.sub }}</p>
        </div>
      </div>

      <!-- Chart -->
      <div class="sales-chart-wrap">
        <canvas ref="salesChartRef"></canvas>
      </div>

      <!-- Top Products Table -->
      <div class="top-products">
        <h3 class="tp-title">Produk Terlaris</h3>
        <table class="tp-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Produk</th>
              <th>Kategori</th>
              <th>Terjual</th>
              <th>Pendapatan</th>
              <th>Tren</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(prod, i) in topProducts" :key="prod.name">
              <td class="rank">{{ i + 1 }}</td>
              <td class="prod-name">{{ prod.name }}</td>
              <td><span class="prod-cat">{{ prod.category }}</span></td>
              <td>{{ prod.sold }}</td>
              <td class="revenue">{{ prod.revenue }}</td>
              <td>
                <span class="tren-badge" :class="prod.up ? 'up' : 'down'">
                  {{ prod.up ? '↑' : '↓' }} {{ prod.trend }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

  </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { Chart, LineController, LineElement, PointElement, CategoryScale, LinearScale, BarController, BarElement, Legend, Tooltip, Filler } from 'chart.js'

Chart.register(LineController, LineElement, PointElement, CategoryScale, LinearScale, BarController, BarElement, Legend, Tooltip, Filler)

const salesChartRef = ref(null)
let salesChart

// ─── DATA: PENGUMUMAN ────────────────────────────────────────────
const announcements = [
  {
    id: 1,
    icon: '🔴',
    priority: 'urgent',
    tag: 'Penting',
    date: '24 Apr 2026',
    title: 'Rapat Evaluasi Kinerja Q1 — Wajib Hadir',
    description: 'Seluruh kepala divisi wajib hadir pada rapat evaluasi kinerja Q1 tanggal 26 April 2026 pukul 09.00 WIB di Ruang Rapat Utama.'
  },
  {
    id: 2,
    icon: '🟡',
    priority: 'info',
    tag: 'Info',
    date: '23 Apr 2026',
    title: 'Pembaruan Sistem Inventaris v3.2',
    description: 'Sistem inventaris akan diperbarui ke versi 3.2 pada 27 April 2026. Layanan akan down sementara pukul 00.00–02.00 WIB.'
  },
  {
    id: 3,
    icon: '🟢',
    priority: 'success',
    tag: 'Prestasi',
    date: '21 Apr 2026',
    title: 'V Retail Raih Penghargaan Retailer Terbaik 2026',
    description: 'Kami dengan bangga mengumumkan bahwa V Retail meraih penghargaan Retailer Terbaik Regional Jawa Tengah tahun 2026.'
  },
  {
    id: 4,
    icon: '🔵',
    priority: 'info',
    tag: 'Kebijakan',
    date: '18 Apr 2026',
    title: 'Revisi SOP Pengembalian Barang',
    description: 'SOP pengembalian barang telah diperbarui. Harap baca dokumen terbaru di portal internal sebelum 30 April 2026.'
  }
]

// ─── DATA: KPI ───────────────────────────────────────────────────
const kpiCards = [
  { icon: '💰', label: 'Total Pendapatan', value: 'Rp 847 Jt', change: '12.5%', positive: true, progress: 85, target: 'Rp 1 M', color: '#6c5ce7' },
  { icon: '🛒', label: 'Total Transaksi', value: '14.290', change: '8.2%', positive: true, progress: 71, target: '20.000', color: '#00b894' },
  { icon: '👥', label: 'Pelanggan Aktif', value: '2.847', change: '15.3%', positive: true, progress: 57, target: '5.000', color: '#0984e3' },
  { icon: '📦', label: 'Stok Tersedia', value: '3.210 Item', change: '2.4%', positive: false, progress: 64, target: '5.000 Item', color: '#e17055' },
  { icon: '⭐', label: 'Rating Kepuasan', value: '4.7 / 5.0', change: '0.3 poin', positive: true, progress: 94, target: '5.0', color: '#fdcb6e' },
  { icon: '🔄', label: 'Tingkat Return', value: '1.8%', change: '0.5%', positive: false, progress: 18, target: '< 2%', color: '#fd79a8' }
]

// ─── DATA: RINGKASAN PENJUALAN ────────────────────────────────────
const salesSummary = [
  { label: 'Penjualan Bulan Ini', value: 'Rp 218 Jt', sub: '+11.4% vs bulan lalu', positive: true },
  { label: 'Rata-rata / Hari', value: 'Rp 7.3 Jt', sub: '+5.1% vs bulan lalu', positive: true },
  { label: 'Transaksi Gagal', value: '34', sub: '-18.2% membaik', positive: true },
  { label: 'Profit Bersih', value: 'Rp 52.4 Jt', sub: '+9.7% vs bulan lalu', positive: true }
]

// ─── DATA: PRODUK TERLARIS ────────────────────────────────────────
const topProducts = [
  { name: 'Laptop Asus VivoBook 14', category: 'Elektronik', sold: 312, revenue: 'Rp 124.8 Jt', trend: '14%', up: true },
  { name: 'Printer Canon PIXMA', category: 'Elektronik', sold: 278, revenue: 'Rp 55.6 Jt', trend: '8%', up: true },
  { name: 'Kertas HVS A4 80gr', category: 'ATK', sold: 2410, revenue: 'Rp 36.2 Jt', trend: '3%', up: false },
  { name: 'UPS APC 1000VA', category: 'Jaringan', sold: 189, revenue: 'Rp 75.6 Jt', trend: '21%', up: true },
  { name: 'Kabel LAN Cat6 50m', category: 'Jaringan', sold: 541, revenue: 'Rp 27.1 Jt', trend: '6%', up: false }
]

// ─── CHART ────────────────────────────────────────────────────────
onMounted(() => {
  salesChart = new Chart(salesChartRef.value, {
    type: 'line',
    data: {
      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'],
      datasets: [
        {
          label: 'Pendapatan (Jt)',
          data: [145, 178, 162, 218, null, null],
          borderColor: '#6c5ce7',
          backgroundColor: 'rgba(108,92,231,0.12)',
          fill: true,
          tension: 0.4,
          pointBackgroundColor: '#6c5ce7',
          pointRadius: 5
        },
        {
          label: 'Target (Jt)',
          data: [160, 170, 180, 200, 210, 220],
          borderColor: '#b2bec3',
          borderDash: [6, 4],
          fill: false,
          tension: 0.4,
          pointRadius: 3
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { position: 'top' },
        tooltip: { mode: 'index', intersect: false }
      },
      scales: {
        y: {
          grid: { color: 'rgba(0,0,0,0.05)' },
          ticks: { callback: v => 'Rp ' + v + ' Jt' }
        },
        x: { grid: { display: false } }
      }
    }
  })
})

onUnmounted(() => {
  salesChart?.destroy()
})
</script>

<style scoped>
/* ── Layout ── */
.dashboard-home {
  display: flex;
  flex-direction: column;
  gap: 2rem;
  padding: 0.25rem 0;
}

.section-block {
  background: #ffffff;
  border: 1px solid #e8ecf0;
  border-radius: 18px;
  padding: 1.5rem 1.75rem;
  box-shadow: 0 2px 12px rgba(0,0,0,0.045);
}

/* ── Section Header ── */
.section-header {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 1.25rem;
}
.section-icon { font-size: 1.2rem; }
.section-title {
  font-size: 1.05rem;
  font-weight: 700;
  color: #1a1f36;
  margin: 0;
  flex: 1;
}
.badge-new {
  background: #6c5ce7;
  color: #fff;
  font-size: 0.72rem;
  font-weight: 700;
  padding: 2px 10px;
  border-radius: 20px;
}
.period-label {
  font-size: 0.78rem;
  color: #7f8c9a;
  background: #f1f5f9;
  padding: 3px 12px;
  border-radius: 20px;
}

/* ── Announcements ── */
.announcements-list { display: flex; flex-direction: column; gap: 0.85rem; }

.announcement-card {
  display: flex;
  gap: 1rem;
  border-radius: 12px;
  padding: 1rem 1.1rem;
  border-left: 4px solid transparent;
  background: #f8fafc;
  transition: transform 0.18s ease, box-shadow 0.18s ease;
}
.announcement-card:hover { transform: translateY(-2px); box-shadow: 0 4px 16px rgba(0,0,0,0.07); }

.priority-urgent { border-color: #e17055; background: #fff5f4; }
.priority-success { border-color: #00b894; background: #f0fdf8; }
.priority-info    { border-color: #0984e3; background: #f0f7ff; }

.ann-left { font-size: 1.5rem; flex-shrink: 0; padding-top: 2px; }
.ann-body { flex: 1; }
.ann-meta { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.3rem; }
.ann-tag {
  font-size: 0.68rem;
  font-weight: 700;
  padding: 2px 9px;
  border-radius: 12px;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
.tag-urgent  { background: #fde8e4; color: #c0392b; }
.tag-success { background: #d4f7ec; color: #00695c; }
.tag-info    { background: #d9ecff; color: #1565c0; }

.ann-date { font-size: 0.73rem; color: #94a3b8; margin-left: auto; }
.ann-title { font-size: 0.9rem; font-weight: 700; color: #1a1f36; margin: 0 0 0.25rem; }
.ann-desc  { font-size: 0.8rem; color: #64748b; margin: 0; line-height: 1.5; }

/* ── KPI Grid ── */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
  gap: 1rem;
}
.kpi-card {
  background: #f8fafc;
  border: 1px solid #e8ecf0;
  border-radius: 14px;
  padding: 1rem 1.1rem;
  transition: transform 0.18s ease, box-shadow 0.18s ease;
}
.kpi-card:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,0.08); }

.kpi-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; }
.kpi-icon { font-size: 1.4rem; }
.kpi-trend { font-size: 0.72rem; font-weight: 700; padding: 2px 8px; border-radius: 20px; }
.trend-up   { background: #d4f7ec; color: #00695c; }
.trend-down { background: #fde8e4; color: #c0392b; }

.kpi-value { font-size: 1.5rem; font-weight: 800; color: #1a1f36; margin: 0 0 0.15rem; }
.kpi-label { font-size: 0.78rem; color: #64748b; margin: 0 0 0.6rem; }

.kpi-progress-bar {
  height: 5px;
  background: #e2e8f0;
  border-radius: 10px;
  overflow: hidden;
  margin-bottom: 0.35rem;
}
.kpi-progress-fill { height: 100%; border-radius: 10px; transition: width 1s ease; }
.kpi-target { font-size: 0.7rem; color: #94a3b8; margin: 0; }

/* ── Sales Summary ── */
.sales-summary-row {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 0.85rem;
  margin-bottom: 1.5rem;
}
.sales-summary-card {
  background: linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%);
  border-radius: 12px;
  padding: 1rem 1.1rem;
  color: #fff;
}
.ss-label { font-size: 0.73rem; opacity: 0.85; margin: 0 0 0.3rem; }
.ss-value { font-size: 1.3rem; font-weight: 800; margin: 0 0 0.25rem; }
.ss-sub   { font-size: 0.72rem; margin: 0; font-weight: 600; }
.ss-sub.pos { color: #b8f7d4; }
.ss-sub.neg { color: #ffd2cc; }

/* ── Sales Chart ── */
.sales-chart-wrap {
  height: 260px;
  margin-bottom: 1.5rem;
  position: relative;
}

/* ── Top Products Table ── */
.tp-title { font-size: 0.9rem; font-weight: 700; color: #1a1f36; margin: 0 0 0.75rem; }

.tp-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.82rem;
}
.tp-table th {
  text-align: left;
  padding: 0.55rem 0.75rem;
  background: #f1f5f9;
  color: #475569;
  font-weight: 700;
  font-size: 0.73rem;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
.tp-table th:first-child { border-radius: 8px 0 0 8px; }
.tp-table th:last-child  { border-radius: 0 8px 8px 0; }
.tp-table td {
  padding: 0.6rem 0.75rem;
  border-bottom: 1px solid #f1f5f9;
  color: #334155;
}
.tp-table tr:last-child td { border-bottom: none; }
.tp-table tr:hover td { background: #fafbff; }

.rank { font-weight: 800; color: #6c5ce7; }
.prod-name { font-weight: 600; color: #1e293b; }
.prod-cat {
  background: #ede9fe;
  color: #6c5ce7;
  font-size: 0.7rem;
  font-weight: 700;
  padding: 2px 9px;
  border-radius: 12px;
}
.revenue { font-weight: 700; color: #1a1f36; }
.tren-badge {
  font-size: 0.73rem;
  font-weight: 700;
  padding: 2px 9px;
  border-radius: 12px;
}
.tren-badge.up   { background: #d4f7ec; color: #00695c; }
.tren-badge.down { background: #fde8e4; color: #c0392b; }
</style>