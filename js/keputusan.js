// ============================================================
// LOGIK HALAMAN KEPUTUSAN (keputusan.html)
// ============================================================

let semuaPerlawanan = [];
let kategoriAktif = null;

async function muatkanPerlawanan() {
  const elTabs = document.getElementById("subtab-bar");
  const elList = document.getElementById("senarai-perlawanan");

  const { data, error } = await supabaseClient
    .from("perlawanan_penuh")
    .select("*")
    .order("tarikh", { ascending: true })
    .order("masa", { ascending: true });

  if (error) {
    elTabs.innerHTML = "";
    elList.innerHTML = `<div class="empty-state">Gagal memuatkan keputusan.</div>`;
    console.error(error);
    return;
  }

  semuaPerlawanan = data || [];

  if (semuaPerlawanan.length === 0) {
    elTabs.innerHTML = "";
    elList.innerHTML = `<div class="empty-state">Belum ada perlawanan dijadualkan.</div>`;
    return;
  }

  // Bina senarai kategori sukan unik (untuk sub-tab), susun ikut abjad
  const kategoriList = [...new Set(semuaPerlawanan.map((m) => m.kategori_sukan))].sort();
  kategoriAktif = kategoriList[0];

  elTabs.innerHTML = kategoriList.map((k) => `
    <button class="subtab-btn ${k === kategoriAktif ? "active" : ""}" data-kategori="${escapeHtml(k)}">
      ${escapeHtml(k)}
    </button>
  `).join("");

  elTabs.querySelectorAll(".subtab-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      kategoriAktif = btn.dataset.kategori;
      elTabs.querySelectorAll(".subtab-btn").forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");
      paparkanPerlawanan(kategoriAktif);
    });
  });

  paparkanPerlawanan(kategoriAktif);
}

function paparkanPerlawanan(kategori) {
  const el = document.getElementById("senarai-perlawanan");
  const senarai = semuaPerlawanan.filter((m) => m.kategori_sukan === kategori);

  if (senarai.length === 0) {
    el.innerHTML = `<div class="empty-state">Tiada perlawanan untuk ${escapeHtml(kategori)} buat masa ini.</div>`;
    return;
  }

  // Kumpulkan ikut pusingan (cth: "Kumpulan A", "Suku Akhir", "Final")
  const kumpulan = {};
  senarai.forEach((m) => {
    const key = m.pusingan || "Perlawanan";
    if (!kumpulan[key]) kumpulan[key] = [];
    kumpulan[key].push(m);
  });

  el.innerHTML = Object.entries(kumpulan).map(([pusingan, perlawanan]) => `
    <div class="match-round-group">
      <span class="match-round-title">${escapeHtml(pusingan)}</span>
      <div class="match-list">
        ${perlawanan.map(kadPerlawanan).join("")}
      </div>
    </div>
  `).join("");
}

function kadPerlawanan(m) {
  const sudahTamat = m.status === "selesai" && m.skor_a !== null && m.skor_b !== null;
  const skorPaparan = sudahTamat
    ? `<span>${m.skor_a}</span><span class="vs-label">&ndash;</span><span>${m.skor_b}</span>`
    : `<span class="vs-label">VS</span>`;

  return `
    <div class="match-card">
      <div class="match-card-top">
        <span class="match-date">${formatTarikh(m.tarikh)}${m.masa ? " &middot; " + formatMasa(m.masa) : ""}</span>
        <span class="badge badge-${m.status}">${statusLabel(m.status)}</span>
      </div>
      <div class="match-teams">
        <div class="match-team team-a">
          <span class="team-dot" style="background:${m.warna_pasukan_a || "#00A99D"}"></span>
          ${escapeHtml(m.nama_pasukan_a || "Belum Ditentukan")}
        </div>
        <div class="match-score">${skorPaparan}</div>
        <div class="match-team team-b">
          <span class="team-dot" style="background:${m.warna_pasukan_b || "#00A99D"}"></span>
          ${escapeHtml(m.nama_pasukan_b || "Belum Ditentukan")}
        </div>
      </div>
      <div class="match-card-bottom">
        <span class="match-meta-text">${m.lokasi ? escapeHtml(m.lokasi) : ""}</span>
        ${m.catatan ? `<span class="match-meta-text">${escapeHtml(m.catatan)}</span>` : ""}
      </div>
    </div>
  `;
}

muatkanPerlawanan();

// Kemas kini automatik secara langsung bila skor/status perlawanan berubah
supabaseClient
  .channel("perlawanan-realtime")
  .on("postgres_changes", { event: "*", schema: "public", table: "perlawanan" }, () => {
    muatkanPerlawanan();
  })
  .subscribe();
