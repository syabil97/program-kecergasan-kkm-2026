// ============================================================
// LOGIK HALAMAN KIRAAN PINGAT (pingat.html)
// ============================================================

async function muatkanJadualPingat() {
  const el = document.getElementById("jadual-pingat");

  const { data, error } = await supabaseClient
    .from("kiraan_pingat")
    .select("*")
    .order("emas", { ascending: false })
    .order("perak", { ascending: false })
    .order("gangsa", { ascending: false });

  if (error) {
    el.innerHTML = `<tr><td colspan="5" class="loading-pulse">Gagal memuatkan data.</td></tr>`;
    console.error(error);
    return;
  }

  if (!data || data.length === 0) {
    el.innerHTML = `<tr><td colspan="5" class="loading-pulse">Belum ada pingat direkodkan.</td></tr>`;
    return;
  }

  el.innerHTML = data.map((row) => `
    <tr>
      <td>
        <span class="team-dot" style="background:${row.warna || "#00A99D"}"></span>
        ${escapeHtml(row.nama_pasukan)}
      </td>
      <td class="col-emas">${row.emas}</td>
      <td class="col-perak">${row.perak}</td>
      <td class="col-gangsa">${row.gangsa}</td>
      <td class="col-jumlah">${row.jumlah}</td>
    </tr>
  `).join("");
}

muatkanJadualPingat();

// Kemas kini automatik secara langsung (realtime) apabila ada pingat baharu direkodkan
supabaseClient
  .channel("pingat-realtime")
  .on("postgres_changes", { event: "*", schema: "public", table: "pingat" }, () => {
    muatkanJadualPingat();
  })
  .subscribe();
