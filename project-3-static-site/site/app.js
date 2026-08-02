(function () {
  const btn = document.getElementById("count-btn");
  const line = document.getElementById("count-line");

  async function countVisit() {
    btn.disabled = true;
    line.textContent = "Visits: …";
    try {
      const res = await fetch("/api/visitors", {
        method: "GET",
        headers: { Accept: "application/json" },
      });
      if (!res.ok) {
        throw new Error("HTTP " + res.status);
      }
      const data = await res.json();
      line.textContent = "Visits: " + data.visits;
    } catch (err) {
      console.error(err);
      line.textContent = "Visits: unavailable";
    } finally {
      btn.disabled = false;
    }
  }

  btn.addEventListener("click", countVisit);
})();
