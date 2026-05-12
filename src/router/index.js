import { createRouter, createWebHashHistory } from 'vue-router'

import AuthView from '../views/AuthView.vue'
import DashboardLayout from '../layouts/DashboardLayout.vue'
import DashboardHome from '../views/dashboard/DashboardHome.vue'
import POSView from '../views/dashboard/POSView.vue'
import InventoryView from '../views/dashboard/InventoryView.vue'
import OrdersView from '../views/dashboard/OrdersView.vue'
import CustomersView from '../views/dashboard/CustomersView.vue'
import SettingsView from '../views/dashboard/SettingsView.vue'
import PurchaseOrdersView from '../views/dashboard/PurchaseOrdersView.vue'
import PreventifMapView from '../views/PreventifMapView.vue'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'login',
    component: AuthView,
    meta: { guestOnly: true }
  },
  {
    path: '/register',
    name: 'register',
    component: AuthView,
    meta: { guestOnly: true }
  },
  {
    path: '/app',
    component: DashboardLayout,
    meta: { requiresAuth: true },
    children: [
      { path: '', redirect: '/app/dashboard' },
      { path: 'dashboard', name: 'dashboard', component: DashboardHome },
      { path: 'pos', name: 'pos', component: POSView },
      { path: 'orders', name: 'orders', component: OrdersView },
      { path: 'inventory', name: 'inventory', component: InventoryView },
      { path: 'customers', name: 'customers', component: CustomersView },
      { path: 'purchase-orders', name: 'purchase-orders', component: PurchaseOrdersView },
      { path: 'settings', name: 'settings', component: SettingsView },
      { path: 'preventif-map', name: 'preventif-map', component: PreventifMapView }
    ]
  }
]

const router = createRouter({
  history: createWebHashHistory('/V-Retail/'),
  routes
})

router.beforeEach((to) => {
  const session = localStorage.getItem('userSession')

  if (to.meta.requiresAuth && !session) {
    return { name: 'login' }
  }

  if (to.meta.guestOnly && session) {
    return { name: 'dashboard' }
  }

  return true
})

export default router