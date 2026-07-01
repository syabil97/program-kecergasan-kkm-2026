-- ============================================================
-- TUKAR PASUKAN: Zon -> Negeri
-- ============================================================
-- Run dalam SQL Editor Supabase.
-- ⚠️ Ini akan PADAM semua pasukan (zon) sedia ada berserta
--    rekod pingat yang berkaitan, dan gantikan dengan negeri.
--    Kalau anda dah ada data pingat SEBENAR (bukan dummy),
--    JANGAN run ni — edit terus dalam Table Editor sebaliknya.
-- ============================================================

-- 1. Padam rekod pingat dahulu (foreign key bergantung kepada pasukan)
delete from pingat;

-- 2. Padam semua pasukan (zon) sedia ada
delete from pasukan;

-- 3. Masukkan semula ikut negeri — edit/padam mana yang tak berkenaan
insert into pasukan (nama, warna) values
  ('Perlis', '#8D99AE'),
  ('Kedah', '#2A9D8F'),
  ('Pulau Pinang', '#E76F51'),
  ('Perak', '#264653'),
  ('Selangor', '#E63946'),
  ('Kuala Lumpur', '#F2B705'),
  ('Putrajaya', '#457B9D'),
  ('Negeri Sembilan', '#6A994E'),
  ('Melaka', '#BC6C25'),
  ('Johor', '#003049'),
  ('Pahang', '#D62828'),
  ('Terengganu', '#0077B6'),
  ('Kelantan', '#6A4C93'),
  ('Sabah', '#F4A261'),
  ('Sarawak', '#2B9348'),
  ('Labuan', '#577590')
on conflict (nama) do nothing;

-- 4. Sahkan
select * from pasukan order by nama;
