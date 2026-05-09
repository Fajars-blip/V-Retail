-- ==============================================================================
-- SQL Script untuk menambah kolom di transactions dan membuat transaction_items
-- Silakan jalankan script ini di menu "SQL Editor" pada dashboard Supabase Anda
-- ==============================================================================

-- 1. Menambahkan kolom baru ke tabel `transactions` yang sudah ada 
-- (Hapus komentar "--" pada perintah ALTER TABLE di bawah ini jika tabel sudah ada)

-- ALTER TABLE transactions 
-- ADD COLUMN total_price numeric NOT NULL DEFAULT 0,
-- ADD COLUMN discount numeric NOT NULL DEFAULT 0,
-- ADD COLUMN payment_nominal numeric NOT NULL DEFAULT 0,
-- ADD COLUMN change_amount numeric NOT NULL DEFAULT 0,
-- ADD COLUMN payment_method varchar(50) NOT NULL DEFAULT 'TUNAI',
-- ADD COLUMN payment_reference varchar(255);

-- ATAU jika Anda ingin membuat tabel `transactions` dari awal:
CREATE TABLE IF NOT EXISTS transactions (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  total_price numeric NOT NULL DEFAULT 0,
  discount numeric NOT NULL DEFAULT 0,
  payment_nominal numeric NOT NULL DEFAULT 0,
  change_amount numeric NOT NULL DEFAULT 0,
  payment_method varchar(50) NOT NULL DEFAULT 'TUNAI',
  payment_reference varchar(255)
);

-- 2. Membuat tabel `transaction_items`
CREATE TABLE IF NOT EXISTS transaction_items (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  transaction_id uuid REFERENCES transactions(id) ON DELETE CASCADE,
  -- Sesuaikan tipe data product_id dengan primary key di tabel inventory_retail Anda
  -- Jika inventory_retail menggunakan UUID, gunakan "uuid", jika angka, gunakan "bigint" atau "integer"
  product_id bigint REFERENCES inventory_retail(id) ON DELETE RESTRICT,
  quantity integer NOT NULL DEFAULT 1,
  price_at_sale numeric NOT NULL DEFAULT 0
);

-- 3. Setup RLS (Row Level Security) - Opsional namun disarankan
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE transaction_items ENABLE ROW LEVEL SECURITY;

-- Memberikan akses (Policy) agar anonim / authenticated user dapat melakukan insert & select
CREATE POLICY "Allow anon insert" ON transactions FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon select" ON transactions FOR SELECT USING (true);

CREATE POLICY "Allow anon insert" ON transaction_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon select" ON transaction_items FOR SELECT USING (true);

-- ==============================================================================
-- 4. Modul Purchase Order (PO)
-- ==============================================================================

-- A. Menambahkan kolom `role` pada `users_retail` jika belum ada
-- ALTER TABLE users_retail ADD COLUMN role varchar(20) NOT NULL DEFAULT 'admin';
-- Catatan: Untuk menguji fitur approve PO, Anda perlu mengubah role akun Anda menjadi 'owner' via Supabase dashboard.

-- B. Membuat tabel `purchase_orders`
CREATE TABLE IF NOT EXISTS purchase_orders (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  product_id bigint REFERENCES inventory_retail(id) ON DELETE RESTRICT,
  supplier_name varchar(255) NOT NULL,
  incoming_price numeric NOT NULL DEFAULT 0,
  quantity integer NOT NULL DEFAULT 1,
  total_price numeric NOT NULL DEFAULT 0,
  invoice_image_url text, -- Bisa berupa base64 string atau Supabase Storage URL
  status varchar(20) NOT NULL DEFAULT 'PENDING', -- PENDING, ACCEPTED, REJECTED
  created_by varchar(255)
);

-- C. Setup RLS untuk purchase_orders (Opsional)
ALTER TABLE purchase_orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow anon insert" ON purchase_orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon select" ON purchase_orders FOR SELECT USING (true);
CREATE POLICY "Allow anon update" ON purchase_orders FOR UPDATE USING (true);

-- D. Storage Bucket (Jika Anda menggunakan Supabase Storage)
-- Pastikan Anda membuat bucket bernama "invoices" di dashboard Supabase Storage dan membuatnya "Public".
