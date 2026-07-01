// ============================================================
// LOGIK HALAMAN GALERI (galeri.html)
// ============================================================

async function muatkanGaleri() {
  const el = document.getElementById("galeri-grid");

  const { data, error } = await supabaseClient
    .from("galeri")
    .select("*")
    .order("dimuat_naik_pada", { ascending: false });

  if (error) {
    el.innerHTML = `<div class="empty-state">Gagal memuatkan galeri.</div>`;
    console.error(error);
    return;
  }

  if (!data || data.length === 0) {
    el.innerHTML = `<div class="empty-state">Belum ada gambar dimuat naik.</div>`;
    return;
  }

  el.innerHTML = data.map((g) => `
    <div class="gallery-item">
      <img src="${getGaleriUrl(g.image_path)}" alt="${escapeHtml(g.tajuk || "Gambar karnival")}" loading="lazy">
      ${g.tajuk ? `<div class="cap">${escapeHtml(g.tajuk)}</div>` : ""}
    </div>
  `).join("");
}

muatkanGaleri();
