-- ============================================================
-- TAMBAHAN: Jadual PERLAWANAN (Keputusan / Fixtures)
-- ============================================================
-- Run dalam SQL Editor Supabase. Ini menambah jadual baharu
-- tanpa menyentuh jadual sedia ada (pasukan, sukan, pingat, dll).
-- ============================================================

create table if not exists perlawanan (
  id uuid primary key default gen_random_uuid(),
  kategori_sukan text not null,        -- cth: "Bola Tampar", "Badminton", "Futsal" (untuk sub-tab)
  pusingan text,                       -- cth: "Kumpulan A", "Suku Akhir", "Separuh Akhir", "Final"
  pasukan_a_id uuid references pasukan(id) on delete set null,
  pasukan_b_id uuid references pasukan(id) on delete set null,
  skor_a int,                          -- kosongkan (null) jika belum tamat
  skor_b int,
  tarikh date not null,
  masa time,
  lokasi text,
  status text default 'akan_datang' check (status in ('akan_datang','sedang_berlangsung','selesai','ditangguhkan')),
  catatan text,                        -- cth: "Selepas tambahan masa", "WO - Zon Timur menarik diri"
  dibuat_pada timestamptz default now()
);

-- Baca terbuka untuk semua, tulis hanya admin — sama seperti jadual lain
alter table perlawanan enable row level security;

create policy "Baca awam" on perlawanan for select using (true);
create policy "Tulis admin sahaja" on perlawanan for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

-- ------------------------------------------------------------
-- VIEW: Perlawanan dengan nama & warna pasukan terus (senang untuk website)
-- ------------------------------------------------------------
create or replace view perlawanan_penuh as
select
  m.id,
  m.kategori_sukan,
  m.pusingan,
  m.tarikh,
  m.masa,
  m.lokasi,
  m.status,
  m.catatan,
  m.skor_a,
  m.skor_b,
  pa.nama  as nama_pasukan_a,
  pa.warna as warna_pasukan_a,
  pb.nama  as nama_pasukan_b,
  pb.warna as warna_pasukan_b
from perlawanan m
left join pasukan pa on pa.id = m.pasukan_a_id
left join pasukan pb on pb.id = m.pasukan_b_id
order by m.tarikh asc, m.masa asc;

-- ------------------------------------------------------------
-- DATA CONTOH (padam/edit ikut keperluan sebenar)
-- ------------------------------------------------------------
insert into perlawanan (kategori_sukan, pusingan, pasukan_a_id, pasukan_b_id, skor_a, skor_b, tarikh, masa, lokasi, status) values
  ('Bola Tampar', 'Kumpulan A', (select id from pasukan where nama = 'Selangor'), (select id from pasukan where nama = 'Johor'), 3, 1, '2026-08-14', '08:00', 'Gelanggang 1', 'selesai'),
  ('Bola Tampar', 'Kumpulan A', (select id from pasukan where nama = 'Kedah'), (select id from pasukan where nama = 'Pahang'), null, null, '2026-08-15', '08:00', 'Gelanggang 1', 'akan_datang'),
  ('Badminton', 'Suku Akhir', (select id from pasukan where nama = 'Perak'), (select id from pasukan where nama = 'Melaka'), 2, 0, '2026-08-14', '10:30', 'Dewan Badminton', 'selesai'),
  ('Badminton', 'Suku Akhir', (select id from pasukan where nama = 'Kelantan'), (select id from pasukan where nama = 'Sarawak'), null, null, '2026-08-16', '10:30', 'Dewan Badminton', 'sedang_berlangsung'),
  ('Futsal', 'Separuh Akhir', (select id from pasukan where nama = 'Sabah'), (select id from pasukan where nama = 'Terengganu'), null, null, '2026-08-17', '14:00', 'Gelanggang Futsal 2', 'akan_datang')
on conflict do nothing;
