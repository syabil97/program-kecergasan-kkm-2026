// ============================================================
// LOGIK HALAMAN INFO (info.html)
// ============================================================

async function muatkanSenaraiInfo() {
  const el = document.getElementById("senarai-info");

  const { data, error } = await supabaseClient
    .from("info")
    .select("*")
    .order("penting", { ascending: false })
    .order("dibuat_pada", { ascending: false });

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

muatkanSenaraiInfo();
