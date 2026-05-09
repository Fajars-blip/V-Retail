<template>
  <div class="customers-page">

    <!-- ── Header ── -->
    <div class="page-header">
      <div class="page-header-left">
        <h1 class="page-title">Database Pelanggan</h1>
        <p class="page-sub">Kelola dan pantau seluruh data pelanggan V Retail</p>
      </div>
      <button class="btn-add" @click="showAddModal = true">
        <span class="btn-icon">＋</span> Tambah Pelanggan
      </button>
    </div>

    <!-- ── Stats Row ── -->
    <div class="stats-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <span class="stat-icon">{{ s.icon }}</span>
        <div>
          <p class="stat-value">{{ s.value }}</p>
          <p class="stat-label">{{ s.label }}</p>
        </div>
      </div>
    </div>

    <!-- ── Search & Filter ── -->
    <div class="toolbar">
      <div class="search-wrap">
        <span class="search-ico">🔍</span>
        <input
          v-model="search"
          type="text"
          placeholder="Cari nama, email, atau telepon..."
          class="search-input"
        />
      </div>
      <div class="filter-tabs">
        <button
          v-for="f in filters"
          :key="f.key"
          class="filter-btn"
          :class="{ active: activeFilter === f.key }"
          @click="activeFilter = f.key"
        >{{ f.label }}</button>
      </div>
    </div>

    <!-- ── Customer Table ── -->
    <div class="table-card">
      <table class="cust-table">
        <thead>
          <tr>
            <th>Pelanggan</th>
            <th>Kontak</th>
            <th>Bergabung</th>
            <th>Total Belanja</th>
            <th>Transaksi</th>
            <th>Status</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="filteredCustomers.length === 0">
            <td colspan="7" class="empty-row">
              <div class="empty-state">
                <span style="font-size:2.5rem">👥</span>
                <p>Tidak ada pelanggan ditemukan</p>
              </div>
            </td>
          </tr>
          <tr
            v-for="cust in filteredCustomers"
            :key="cust.id"
            class="cust-row"
          >
            <!-- Avatar + Nama -->
            <td class="td-cust">
              <div class="cust-info">
                <div class="avatar" :style="{ background: cust.avatarBg }">
                  <span class="avatar-letter">{{ cust.name.charAt(0).toUpperCase() }}</span>
                  <span class="avatar-badge" :class="'tier-' + cust.tier">{{ tierIcon(cust.tier) }}</span>
                </div>
                <div>
                  <p class="cust-name">{{ cust.name }}</p>
                  <p class="cust-id">#CUS-{{ String(cust.id).padStart(4, '0') }}</p>
                </div>
              </div>
            </td>

            <!-- Kontak -->
            <td class="td-contact">
              <p class="contact-email">{{ cust.email }}</p>
              <p class="contact-phone">{{ cust.phone }}</p>
            </td>

            <!-- Bergabung -->
            <td class="td-date">{{ cust.joinDate }}</td>

            <!-- Total Belanja -->
            <td class="td-spend">Rp {{ formatNum(cust.totalSpend) }}</td>

            <!-- Transaksi -->
            <td class="td-trx">
              <span class="trx-badge">{{ cust.transactions }}x</span>
            </td>

            <!-- Status -->
            <td>
              <span class="status-badge" :class="'st-' + cust.status">
                {{ cust.status === 'active' ? 'Aktif' : 'Tidak Aktif' }}
              </span>
            </td>

            <!-- Aksi -->
            <td class="td-action">
              <button class="action-btn" title="Lihat Detail">👁</button>
              <button class="action-btn" title="Edit">✏️</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- ── Pagination ── -->
    <div class="pagination">
      <span class="pag-info">Menampilkan {{ filteredCustomers.length }} dari {{ customers.length }} pelanggan</span>
      <div class="pag-btns">
        <button class="pag-btn" disabled>‹ Prev</button>
        <button class="pag-btn active">1</button>
        <button class="pag-btn">2</button>
        <button class="pag-btn">Next ›</button>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const search = ref('')
const activeFilter = ref('all')
const showAddModal = ref(false)

const filters = [
  { key: 'all',      label: 'Semua' },
  { key: 'active',   label: 'Aktif' },
  { key: 'inactive', label: 'Tidak Aktif' },
  { key: 'vip',      label: '⭐ VIP' }
]

const avatarColors = [
  '#6c5ce7', '#0984e3', '#00b894', '#e17055',
  '#fd79a8', '#fdcb6e', '#6c5ce7', '#00cec9'
]

const customers = ref([
  { id: 1,  name: 'Budi Santoso',      email: 'budi@email.com',    phone: '0812-1234-5678', joinDate: '12 Jan 2024', totalSpend: 4850000,  transactions: 14, status: 'active',   tier: 'vip',    avatarBg: '#6c5ce7' },
  { id: 2,  name: 'Siti Rahayu',       email: 'siti@email.com',    phone: '0856-2345-6789', joinDate: '3 Feb 2024',  totalSpend: 2100000,  transactions: 8,  status: 'active',   tier: 'gold',   avatarBg: '#0984e3' },
  { id: 3,  name: 'Ahmad Fauzi',       email: 'ahmad@email.com',   phone: '0821-3456-7890', joinDate: '21 Feb 2024', totalSpend: 780000,   transactions: 3,  status: 'inactive', tier: 'silver', avatarBg: '#00b894' },
  { id: 4,  name: 'Dewi Permata',      email: 'dewi@email.com',    phone: '0878-4567-8901', joinDate: '5 Mar 2024',  totalSpend: 6320000,  transactions: 21, status: 'active',   tier: 'vip',    avatarBg: '#e17055' },
  { id: 5,  name: 'Eko Prasetyo',      email: 'eko@email.com',     phone: '0813-5678-9012', joinDate: '18 Mar 2024', totalSpend: 1540000,  transactions: 6,  status: 'active',   tier: 'silver', avatarBg: '#fd79a8' },
  { id: 6,  name: 'Fitri Handayani',   email: 'fitri@email.com',   phone: '0857-6789-0123', joinDate: '2 Apr 2024',  totalSpend: 3200000,  transactions: 11, status: 'active',   tier: 'gold',   avatarBg: '#fdcb6e' },
  { id: 7,  name: 'Gilang Ramadhan',   email: 'gilang@email.com',  phone: '0822-7890-1234', joinDate: '14 Apr 2024', totalSpend: 420000,   transactions: 2,  status: 'inactive', tier: 'bronze', avatarBg: '#6c5ce7' },
  { id: 8,  name: 'Hani Kusuma',       email: 'hani@email.com',    phone: '0879-8901-2345', joinDate: '28 Apr 2024', totalSpend: 9100000,  transactions: 34, status: 'active',   tier: 'vip',    avatarBg: '#00cec9' },
])

const stats = computed(() => [
  { icon: '👥', label: 'Total Pelanggan',   value: customers.value.length },
  { icon: '✅', label: 'Pelanggan Aktif',    value: customers.value.filter(c => c.status === 'active').length },
  { icon: '⭐', label: 'Member VIP',         value: customers.value.filter(c => c.tier === 'vip').length },
  { icon: '💰', label: 'Total Pendapatan',   value: 'Rp ' + formatNum(customers.value.reduce((a, c) => a + c.totalSpend, 0)) }
])

const filteredCustomers = computed(() => {
  let list = customers.value
  if (activeFilter.value === 'active')   list = list.filter(c => c.status === 'active')
  if (activeFilter.value === 'inactive') list = list.filter(c => c.status === 'inactive')
  if (activeFilter.value === 'vip')      list = list.filter(c => c.tier === 'vip')
  if (search.value.trim()) {
    const q = search.value.toLowerCase()
    list = list.filter(c =>
      c.name.toLowerCase().includes(q) ||
      c.email.toLowerCase().includes(q) ||
      c.phone.includes(q)
    )
  }
  return list
})

const tierIcon = (tier) => {
  return { vip: '⭐', gold: '🥇', silver: '🥈', bronze: '🥉' }[tier] || ''
}

const formatNum = (n) => new Intl.NumberFormat('id-ID').format(n)
</script>

<style scoped>
/* ── Page ── */
.customers-page {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

/* ── Header ── */
.page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
}
.page-title {
  font-size: 1.4rem;
  font-weight: 800;
  color: #1a1f36;
  margin: 0 0 0.15rem;
}
.page-sub { font-size: 0.82rem; color: #64748b; margin: 0; }

.btn-add {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  background: #6c5ce7;
  color: #fff;
  border: none;
  padding: 0.6rem 1.2rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 700;
  cursor: pointer;
  transition: background 0.18s, transform 0.18s;
}
.btn-add:hover { background: #5a4bd1; transform: translateY(-1px); }
.btn-icon { font-size: 1rem; }

/* ── Stats ── */
.stats-row {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
  gap: 0.9rem;
}
.stat-card {
  background: #fff;
  border: 1px solid #e8ecf0;
  border-radius: 14px;
  padding: 1rem 1.2rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  box-shadow: 0 1px 6px rgba(0,0,0,0.04);
}
.stat-icon { font-size: 1.6rem; }
.stat-value { font-size: 1.3rem; font-weight: 800; color: #1a1f36; margin: 0; }
.stat-label { font-size: 0.72rem; color: #64748b; margin: 0; }

/* ── Toolbar ── */
.toolbar {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}
.search-wrap {
  position: relative;
  flex: 1;
  min-width: 200px;
}
.search-ico {
  position: absolute;
  left: 0.9rem;
  top: 50%;
  transform: translateY(-50%);
  font-size: 0.9rem;
}
.search-input {
  width: 100%;
  padding: 0.65rem 1rem 0.65rem 2.4rem;
  border: 1.5px solid #e2e8f0;
  border-radius: 12px;
  font-size: 0.85rem;
  background: #fff;
  outline: none;
  transition: border-color 0.18s;
  box-sizing: border-box;
}
.search-input:focus { border-color: #6c5ce7; }

.filter-tabs { display: flex; gap: 0.4rem; }
.filter-btn {
  padding: 0.5rem 1rem;
  border: 1.5px solid #e2e8f0;
  border-radius: 10px;
  background: #fff;
  font-size: 0.78rem;
  font-weight: 700;
  color: #64748b;
  cursor: pointer;
  transition: all 0.18s;
}
.filter-btn:hover { border-color: #6c5ce7; color: #6c5ce7; }
.filter-btn.active { background: #6c5ce7; border-color: #6c5ce7; color: #fff; }

/* ── Table Card ── */
.table-card {
  background: #fff;
  border: 1px solid #e8ecf0;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0,0,0,0.04);
}

.cust-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.83rem;
}
.cust-table th {
  background: #f8fafc;
  padding: 0.7rem 1rem;
  text-align: left;
  font-size: 0.7rem;
  font-weight: 800;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  border-bottom: 1px solid #f1f5f9;
}
.cust-table td {
  padding: 0.85rem 1rem;
  border-bottom: 1px solid #f8fafc;
  vertical-align: middle;
  color: #334155;
}
.cust-row:last-child td { border-bottom: none; }
.cust-row:hover td { background: #fafbff; }

/* ── Avatar ── */
.cust-info { display: flex; align-items: center; gap: 0.75rem; }

.avatar {
  position: relative;
  width: 42px;
  height: 42px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}
.avatar-letter {
  font-size: 1.1rem;
  font-weight: 900;
  color: #fff;
  line-height: 1;
}
.avatar-badge {
  position: absolute;
  bottom: -4px;
  right: -4px;
  font-size: 0.65rem;
  background: #fff;
  border-radius: 50%;
  width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 1px 4px rgba(0,0,0,0.15);
}

.cust-name { font-weight: 700; color: #1e293b; margin: 0 0 2px; }
.cust-id   { font-size: 0.68rem; color: #94a3b8; font-weight: 700; margin: 0; }

/* ── Cells ── */
.contact-email { font-weight: 600; color: #1e293b; margin: 0 0 2px; font-size: 0.8rem; }
.contact-phone { font-size: 0.72rem; color: #64748b; margin: 0; }
.td-date  { color: #64748b; font-size: 0.78rem; white-space: nowrap; }
.td-spend { font-weight: 700; color: #1a1f36; white-space: nowrap; }
.trx-badge {
  background: #ede9fe;
  color: #6c5ce7;
  font-weight: 800;
  font-size: 0.75rem;
  padding: 2px 10px;
  border-radius: 20px;
}

/* ── Status ── */
.status-badge {
  font-size: 0.72rem;
  font-weight: 700;
  padding: 3px 10px;
  border-radius: 20px;
}
.st-active   { background: #d4f7ec; color: #00695c; }
.st-inactive { background: #f1f5f9; color: #64748b; }

/* ── Action ── */
.td-action { display: flex; gap: 0.3rem; }
.action-btn {
  width: 30px;
  height: 30px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background: #fff;
  cursor: pointer;
  font-size: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.15s;
}
.action-btn:hover { background: #f1f5f9; border-color: #6c5ce7; transform: scale(1.08); }

/* ── Empty ── */
.empty-row { text-align: center; padding: 3rem !important; }
.empty-state { display: flex; flex-direction: column; align-items: center; gap: 0.5rem; opacity: 0.4; }
.empty-state p { font-weight: 700; color: #64748b; }

/* ── Pagination ── */
.pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 0.75rem;
}
.pag-info { font-size: 0.78rem; color: #64748b; }
.pag-btns { display: flex; gap: 0.35rem; }
.pag-btn {
  padding: 0.4rem 0.85rem;
  border: 1.5px solid #e2e8f0;
  border-radius: 8px;
  background: #fff;
  font-size: 0.78rem;
  font-weight: 700;
  color: #64748b;
  cursor: pointer;
  transition: all 0.15s;
}
.pag-btn:hover:not(:disabled) { border-color: #6c5ce7; color: #6c5ce7; }
.pag-btn.active { background: #6c5ce7; border-color: #6c5ce7; color: #fff; }
.pag-btn:disabled { opacity: 0.4; cursor: not-allowed; }
</style>