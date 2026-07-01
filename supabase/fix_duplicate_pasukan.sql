-- ============================================================
-- BAIKI: Duplikasi Pasukan (punca error "more than one row
-- returned by a subquery")
-- ============================================================
-- Run SEMUA arahan di bawah ni SEKALI GUS dalam SQL Editor.
-- ============================================================

-- 1. Lihat dulu berapa banyak duplikasi (jalankan & semak hasilnya)
select nama, count(*) as bilangan
from pasukan
group by nama
having count(*) > 1;

-- 2. PENTING: Padam dulu apa-apa rekod 'pingat' yang mungkin
--    sudah sempat masuk (kalau ada), supaya tak clash dengan
--    foreign key semasa kita padam pasukan duplikat.
delete from pingat;

-- 3. Buang duplikat 'pasukan' — kekalkan HANYA rekod PALING AWAL
--    bagi setiap nama, padam yang lain
delete from pasukan a
using pasukan b
where a.nama = b.nama
  and a.dibuat_pada > b.dibuat_pada;

-- 4. Tambah unique constraint supaya masalah ni TAK berulang lagi
alter table pasukan add constraint pasukan_nama_unique unique (nama);

-- 5. Sahkan — patut return TEPAT 4 baris sahaja sekarang
select * from pasukan order by nama;
