-- ============================================================
-- Karnival Sukan KKM 2026 — Skema Pangkalan Data (Supabase/Postgres)
-- ============================================================
-- Cara guna:
-- 1. Buat projek baharu di https://supabase.com
-- 2. Buka "SQL Editor" dalam dashboard Supabase
-- 3. Salin & tampal SEMUA kandungan fail ini, klik "Run"
-- ============================================================

-- ------------------------------------------------------------
-- 1. JADUAL PASUKAN / ZON / KONTINJEN
-- ------------------------------------------------------------
create table if not exists pasukan (
  id uuid primary key default gen_random_uuid(),
  nama text not null,                 -- cth: "Zon Utara", "Bahagian Kejururawatan"
  warna text default '#00A99D',       -- kod warna hex untuk paparan (cth badge)
  logo_url text,                      -- link logo (boleh upload ke Storage)
  dibuat_pada timestamptz default now()
);

-- ------------------------------------------------------------
-- 2. JADUAL SUKAN / ACARA (senarai acara & jadual)
-- ------------------------------------------------------------
create table if not exists sukan (
  id uuid primary key default gen_random_uuid(),
  nama_acara text not null,           -- cth: "Bola Tampar Lelaki - Suku Akhir"
  kategori_sukan text,                -- cth: "Bola Tampar", "Larian", "Badminton"
  tarikh date not null,
  masa time,
  lokasi text,
  status text default 'akan_datang' check (status in ('akan_datang','sedang_berlangsung','selesai','ditangguhkan')),
  keputusan text,                     -- ringkasan keputusan (cth: "Zon Utara menang 3-1")
  dibuat_pada timestamptz default now()
);

-- ------------------------------------------------------------
-- 3. JADUAL PINGAT (medal tally — direkod SETIAP kali pingat diberi)
-- ------------------------------------------------------------
create table if not exists pingat (
  id uuid primary key default gen_random_uuid(),
  pasukan_id uuid references pasukan(id) on delete cascade,
  sukan_id uuid references sukan(id) on delete set null,
  jenis text not null check (jenis in ('emas', 'perak', 'gangsa')),
  kategori text,                      -- cth: "Lelaki", "Wanita", "Terbuka"
  dianugerah_pada timestamptz default now()
);

-- ------------------------------------------------------------
-- 4. JADUAL INFO / PENGUMUMAN
-- ------------------------------------------------------------
create table if not exists info (
  id uuid primary key default gen_random_uuid(),
  tajuk text not null,
  kandungan text not null,
  penting boolean default false,      -- true = paparkan sebagai pengumuman penting
  dibuat_pada timestamptz default now()
);

-- ------------------------------------------------------------
-- 5. JADUAL GALERI (rujukan gambar dalam Supabase Storage)
-- ------------------------------------------------------------
create table if not exists galeri (
  id uuid primary key default gen_random_uuid(),
  tajuk text,
  image_path text not null,           -- path dalam Storage bucket 'galeri-karnival'
  sukan_id uuid references sukan(id) on delete set null,
  dimuat_naik_pada timestamptz default now()
);

-- ------------------------------------------------------------
-- 6. VIEW: Jumlah Pingat Setiap Pasukan (untuk carta pingat)
-- ------------------------------------------------------------
create or replace view kiraan_pingat as
select
  p.id as pasukan_id,
  p.nama as nama_pasukan,
  p.warna,
  p.logo_url,
  count(*) filter (where m.jenis = 'emas')   as emas,
  count(*) filter (where m.jenis = 'perak')  as perak,
  count(*) filter (where m.jenis = 'gangsa') as gangsa,
  count(*) as jumlah
from pasukan p
left join pingat m on m.pasukan_id = p.id
group by p.id, p.nama, p.warna, p.logo_url
order by emas desc, perak desc, gangsa desc;

-- ------------------------------------------------------------
-- 7. ROW LEVEL SECURITY — benarkan SEMUA orang BACA (public),
--    tapi hanya pengguna log masuk (admin) boleh TULIS/EDIT
-- ------------------------------------------------------------
alter table pasukan enable row level security;
alter table pingat  enable row level security;
alter table sukan   enable row level security;
alter table info    enable row level security;
alter table galeri  enable row level security;

-- Baca (SELECT) — dibuka untuk semua (pelawat website)
create policy "Baca awam" on pasukan for select using (true);
create policy "Baca awam" on pingat  for select using (true);
create policy "Baca awam" on sukan   for select using (true);
create policy "Baca awam" on info    for select using (true);
create policy "Baca awam" on galeri  for select using (true);

-- Tulis (INSERT/UPDATE/DELETE) — HANYA untuk pengguna yang log masuk (admin/AJK)
-- Nota: anda perlu buat akaun admin melalui Supabase Auth (lihat README.md)
create policy "Tulis admin sahaja" on pasukan for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "Tulis admin sahaja" on pingat  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "Tulis admin sahaja" on sukan   for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "Tulis admin sahaja" on info    for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "Tulis admin sahaja" on galeri  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ------------------------------------------------------------
-- 8. DATA CONTOH (boleh padam selepas anda masukkan data sebenar)
-- ------------------------------------------------------------
insert into pasukan (nama, warna) values
  ('Zon Utara', '#E63946'),
  ('Zon Tengah', '#00A99D'),
  ('Zon Selatan', '#F2B705'),
  ('Zon Timur', '#3D5A80')
on conflict do nothing;
