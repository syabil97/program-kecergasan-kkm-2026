-- ============================================================
-- DATA DUMMY UNTUK TEST (Karnival Sukan KKM 2026)
-- ============================================================
-- Run fail ni dalam Supabase SQL Editor SELEPAS anda run
-- schema.sql. Tujuannya untuk isi data contoh supaya anda
-- boleh test website sebelum masukkan data sebenar.
--
-- ⚠️ PADAM data ni sebelum karnival sebenar bermula
--    (lihat arahan "BUANG DATA DUMMY" di bahagian bawah fail ini)
-- ============================================================

-- ------------------------------------------------------------
-- 1. PASUKAN (skip kalau dah ada dari schema.sql)
-- ------------------------------------------------------------
insert into pasukan (nama, warna) values
  ('Zon Utara', '#E63946'),
  ('Zon Tengah', '#00A99D'),
  ('Zon Selatan', '#F2B705'),
  ('Zon Timur', '#3D5A80')
on conflict do nothing;

-- ------------------------------------------------------------
-- 2. SUKAN / ACARA
-- ------------------------------------------------------------
insert into sukan (nama_acara, kategori_sukan, tarikh, masa, lokasi, status, keputusan) values
  ('Bola Tampar Lelaki - Kumpulan A', 'Bola Tampar', '2026-08-14', '08:00', 'Gelanggang 1', 'selesai', 'Zon Utara menang 3-1 ke atas Zon Selatan'),
  ('Badminton Beregu Wanita - Suku Akhir', 'Badminton', '2026-08-14', '10:30', 'Dewan Badminton', 'selesai', 'Zon Tengah menang 2-0'),
  ('Larian 4x100m Relay Lelaki', 'Olahraga', '2026-08-15', '09:00', 'Trek Utama', 'akan_datang', null),
  ('Bola Sepak Futsal - Separuh Akhir', 'Futsal', '2026-08-15', '14:00', 'Gelanggang Futsal 2', 'akan_datang', null),
  ('Ping Pong Perseorangan Lelaki', 'Ping Pong', '2026-08-16', '11:00', 'Dewan Serbaguna', 'sedang_berlangsung', null),
  ('Renang 50m Gaya Bebas Wanita', 'Renang', '2026-08-16', '15:30', 'Kolam Renang', 'akan_datang', null),
  ('Tarik Tali Terbuka', 'Tarik Tali', '2026-08-17', '16:00', 'Padang Utama', 'ditangguhkan', 'Ditangguhkan disebabkan hujan, tarikh baharu akan dimaklumkan'),
  ('Bola Jaring Wanita - Final', 'Bola Jaring', '2026-08-18', '13:00', 'Gelanggang 3', 'akan_datang', null);

-- ------------------------------------------------------------
-- 3. PINGAT
-- ------------------------------------------------------------
-- Nota: guna subquery untuk cari pasukan_id ikut nama, senang nak baca
insert into pingat (pasukan_id, jenis, kategori) values
  ((select id from pasukan where nama = 'Zon Utara'), 'emas', 'Bola Tampar Lelaki'),
  ((select id from pasukan where nama = 'Zon Utara'), 'emas', 'Larian 100m'),
  ((select id from pasukan where nama = 'Zon Utara'), 'perak', 'Badminton Beregu'),
  ((select id from pasukan where nama = 'Zon Tengah'), 'emas', 'Badminton Beregu Wanita'),
  ((select id from pasukan where nama = 'Zon Tengah'), 'emas', 'Ping Pong Lelaki'),
  ((select id from pasukan where nama = 'Zon Tengah'), 'gangsa', 'Renang 50m'),
  ((select id from pasukan where nama = 'Zon Selatan'), 'perak', 'Bola Tampar Lelaki'),
  ((select id from pasukan where nama = 'Zon Selatan'), 'gangsa', 'Larian 100m'),
  ((select id from pasukan where nama = 'Zon Selatan'), 'gangsa', 'Ping Pong Lelaki'),
  ((select id from pasukan where nama = 'Zon Timur'), 'perak', 'Renang 50m'),
  ((select id from pasukan where nama = 'Zon Timur'), 'emas', 'Bola Jaring Wanita');

-- ------------------------------------------------------------
-- 4. INFO / PENGUMUMAN
-- ------------------------------------------------------------
insert into info (tajuk, kandungan, penting) values
  ('Selamat Datang ke Karnival Sukan KKM 2026', 'Terima kasih kerana menyertai Karnival Sukan KKM 2026. Semoga semangat kesukanan dan perpaduan dapat dipupuk sepanjang minggu ini.', false),
  ('Perubahan Lokasi: Tarik Tali Ditangguhkan', 'Acara Tarik Tali Terbuka pada 17 Ogos ditangguhkan disebabkan cuaca hujan. Tarikh dan masa baharu akan dimaklumkan tidak lama lagi.', true),
  ('Pengangkutan Shuttle Disediakan', 'Perkhidmatan bas shuttle disediakan dari Hotel Utama ke Kompleks Sukan setiap 30 minit bermula jam 7:00 pagi.', false),
  ('Peringatan: Bawa Kad Peserta', 'Semua peserta diminta membawa kad peserta rasmi untuk kemasukan ke semua gelanggang dan dewan pertandingan.', true);

-- ------------------------------------------------------------
-- 5. GALERI — ⚠️ TIDAK disertakan dalam data dummy
-- ------------------------------------------------------------
-- Galeri perlu gambar SEBENAR yang dimuat naik ke Supabase Storage
-- dahulu (bucket "galeri-karnival"), sebab column image_path
-- merujuk kepada fail sebenar dalam Storage. Kalau anda insert
-- row dummy di sini tanpa fail sebenar wujud, gambar akan "broken"
-- (ikon gambar pecah) di halaman galeri.
--
-- Untuk test galeri:
-- 1. Pergi Storage -> bucket "galeri-karnival" -> Upload file
--    (upload mana-mana 2-3 gambar contoh untuk test)
-- 2. Selepas upload, salin PATH fail tersebut (cth: "test/foto1.jpg")
-- 3. Run arahan di bawah, gantikan path dengan path sebenar anda:
--
-- insert into galeri (tajuk, image_path) values
--   ('Gambar Ujian 1', 'test/foto1.jpg'),
--   ('Gambar Ujian 2', 'test/foto2.jpg');

-- ============================================================
-- BUANG DATA DUMMY (run ini SEBELUM karnival sebenar bermula)
-- ============================================================
-- Padam SEMUA data dummy di atas dan mula bersih untuk data sebenar:
--
-- truncate table pingat, sukan, info, galeri restart identity cascade;
-- -- (pasukan tak perlu dipadam — anda boleh terus guna 4 zon di atas,
-- --  atau edit nama/warna terus dalam Table Editor jika perlu)
