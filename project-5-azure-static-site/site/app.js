(function () {
  const btn = document.getElementById("count-btn");
  const line = document.getElementById("count-line");
  const apiUrl =
    (window.PORTFOLIO_CONFIG && window.PORTFOLIO_CONFIG.visitorApiUrl) ||
    "/api/visitors";

  async function countVisit() {
    btn.disabled = true;
    line.textContent = "Total visits: …";
    try {
      const res = await fetch(apiUrl, {
        method: "GET",
        headers: { Accept: "application/json" },
      });
      if (!res.ok) {
        throw new Error("HTTP " + res.status);
      }
      const data = await res.json();
      line.textContent = "Total visits: " + data.visits;
    } catch (err) {
      console.error(err);
      line.textContent = "Total visits: unavailable (API disabled or quota pending)";
    } finally {
      btn.disabled = false;
    }
  }

  btn.addEventListener("click", countVisit);
})();
