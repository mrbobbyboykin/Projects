(function () {
  const CONTACT_EMAIL = "info@eventsbyelainab.com";
  const form = document.getElementById("contact-form");
  const note = document.getElementById("form-note");
  const year = document.getElementById("year");
  const navToggle = document.querySelector(".nav-toggle");
  const siteNav = document.getElementById("site-nav");
  const siteHeader = document.querySelector(".site-header");

  if (year) {
    year.textContent = String(new Date().getFullYear());
  }

  if (navToggle && siteNav && siteHeader) {
    navToggle.addEventListener("click", function () {
      const open = siteHeader.classList.toggle("nav-open");
      navToggle.setAttribute("aria-expanded", open ? "true" : "false");
      navToggle.setAttribute("aria-label", open ? "Close menu" : "Open menu");
    });

    siteNav.querySelectorAll("a").forEach(function (link) {
      link.addEventListener("click", function () {
        siteHeader.classList.remove("nav-open");
        navToggle.setAttribute("aria-expanded", "false");
        navToggle.setAttribute("aria-label", "Open menu");
      });
    });
  }

  if (!form) return;

  form.addEventListener("submit", function (event) {
    event.preventDefault();

    const data = new FormData(form);
    const name = String(data.get("name") || "").trim();
    const eventType = String(data.get("event_type") || "").trim();
    const email = String(data.get("email") || "").trim();
    const phone = String(data.get("phone") || "").trim();
    const message = String(data.get("message") || "").trim();

    if (!name || !eventType || !email || !message) {
      note.hidden = false;
      note.textContent = "Please fill in name, event type, email, and event details.";
      return;
    }

    const subject = encodeURIComponent("Event inquiry — " + eventType);
    const body = encodeURIComponent(
      [
        "Name: " + name,
        "Event type: " + eventType,
        "Email: " + email,
        "Phone: " + phone,
        "",
        "Event details:",
        message,
      ].join("\n")
    );

    note.hidden = false;
    note.textContent = "Opening your email app…";
    window.location.href =
      "mailto:" + CONTACT_EMAIL + "?subject=" + subject + "&body=" + body;
  });
})();
