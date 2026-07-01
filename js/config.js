// ============================================================
// KONFIGURASI SUPABASE
// ============================================================
// Isi 2 nilai di bawah dengan maklumat projek Supabase anda.
// Dapatkan dari: Supabase Dashboard -> Project Settings -> API Keys
//
// Bergantung bila projek anda dibuat, anda akan nampak SALAH SATU:
//   - "Publishable key"  (bermula "sb_publishable_...")   <- projek baharu
//   - "anon public" key  (bermula "eyJ...", panjang)        <- projek lama
// Kedua-duanya SELAMAT letak di sini (ia untuk sisi browser/client).
//
// ⚠️ JANGAN sekali-kali letak "Secret key" (sb_secret_...) atau
// "service_role" key di fail ini — itu untuk server sahaja.
// ============================================================

const SUPABASE_URL = "https://tlxvkplyzhrqtulnjujp.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_lQ8k7viyQnOGQtasD8DvwA_OvrrZ4ya";

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Nama bucket Storage untuk gambar galeri (buat dalam Supabase -> Storage)
const GALERI_BUCKET = "galeri-karnival";

// Fungsi bantuan: tukar path gambar Storage -> URL CDN penuh
function getGaleriUrl(path) {
  const { data } = supabaseClient.storage.from(GALERI_BUCKET).getPublicUrl(path);
  return data.publicUrl;
}
