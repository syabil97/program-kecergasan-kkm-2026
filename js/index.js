// ============================================================
// LOGIK HALAMAN UTAMA (index.html)
// ============================================================

async function muatkanMiniScoreboard() {
  const el = document.getElementById("mini-scoreboard");
  const { data, error } = await supabaseClient
    .from("kiraan_pingat")
    .select("*")
    .order("emas", { ascending: false })
    .order("perak", { ascending: false })
    .order("gangsa", { ascending: false })
    .limit(5);

  if (error) {
    el.innerHTML = `<div class="empty-state" style="color:#fff;opacity:.6">Gagal memuatkan data.</div>`;
    console.error(error);
    return;
  }

  if (!data || data.length === 0) {
    el.innerHTML = `<div class="empty-state" style="color:#fff;opacity:.6">Belum ada pingat direkodkan.</div>`;
    return;
  }

  el.innerHTML = data.map((row, i) => `
    <div class="sb-row">
      <span class="sb-rank">${i + 1}</span>
      <span class="sb-name">${escapeHtml(row.nama_pasukan)}</span>
      <span class="sb-num">${row.emas}</span>
      <span class="sb-num">${row.perak}</span>
      <span class="sb-num">${row.gangsa}</span>
      <span class="sb-total">${row.jumlah}</span>
    </div>
  `).join("");

  document.getElementById("stat-pasukan").textContent = data.length;
}

async function muatkanAcaraTerkini() {
  const el = document.getElementById("acara-terkini");
  const hariIni = new Date().toISOString().slice(0, 10);

  const { data, error } = await supabaseClient
    .from("sukan")
    .select("*")
    .gte("tarikh", hariIni)
    .order("tarikh", { ascending: true })
    .order("masa", { ascending: true })
    .limit(6);

  if (error) {
    el.innerHTML = `<div class="empty-state">Gagal memuatkan acara.</div>`;
    console.error(error);
    return;
  }

  if (!data || data.length === 0) {
    el.innerHTML = `<div class="empty-state">Tiada acara akan datang buat masa ini.</div>`;
    return;
  }

  el.innerHTML = data.map((a) => `
    <div class="card event-card">
      <span class="event-date">${formatTarikh(a.tarikh)}${a.masa ? " &middot; " + formatMasa(a.masa) : ""}</span>
      <span class="event-name">${escapeHtml(a.nama_acara)}</span>
      <div class="event-meta">
        ${a.kategori_sukan ? `<span>${escapeHtml(a.kategori_sukan)}</span>` : ""}
        ${a.lokasi ? `<span>&middot; ${escapeHtml(a.lokasi)}</span>` : ""}
      </div>
      <span class="badge badge-${a.status}">${statusLabel(a.status)}</span>
    </div>
  `).join("");

  document.getElementById("stat-acara").textContent = data.length;
}

async function muatkanInfoTerkini() {
  const el = document.getElementById("info-terkini");
  const { data, error } = await supabaseClient
    .from("info")
    .select("*")
    .order("dibuat_pada", { ascending: false })
    .limit(3);

  if (error) {
    el.innerHTML = `<div class="empty-state">Gagal memuatkan info.</div>`;
    console.error(error);
    return;
  }

  if (!data || data.length === 0) {
    el.innerHTML = `<div class="empty-state">Tiada pengumuman buat masa ini.</div>`;
    return;
  }

  el.innerHTML = data.map((p) => `
    <div class="info-item ${p.penting ? "penting" : ""}">
      ${p.penting ? '<span class="tag">Pengumuman Penting</span>' : ""}
      <h3>${escapeHtml(p.tajuk)}</h3>
      <p>${escapeHtml(p.kandungan)}</p>
      <time>${formatTarikh(p.dibuat_pada.slice(0, 10))}</time>
    </div>
  `).join("");
}

function kiraHariKarnival() {
  // Tarikh karnival — laraskan mengikut tarikh sebenar
  const mula = new Date("2026-08-14T00:00:00");
  const tamat = new Date("2026-08-20T23:59:59");
  const hariIni = new Date();
  let label = "—";

  if (hariIni < mula) {
    const bezaHari = Math.ceil((mula - hariIni) / (1000 * 60 * 60 * 24));
    label = `H-${bezaHari}`;
  } else if (hariIni > tamat) {
    label = "Selesai";
  } else {
    const hariKe = Math.floor((hariIni - mula) / (1000 * 60 * 60 * 24)) + 1;
    label = `Hari ${hariKe}`;
  }
  document.getElementById("stat-hari").textContent = label;
}

kiraHariKarnival();
muatkanMiniScoreboard();
muatkanAcaraTerkini();
muatkanInfoTerkini();
