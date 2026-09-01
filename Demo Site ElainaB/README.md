# Events by ElainaB — Website

Modern one-page site for **Events by ElainaB LLC**, replacing the outdated [Wix site](https://www.eventsbyelainab.com/).

## Stack

- Static HTML / CSS / JavaScript (no build step)
- AWS: S3 + CloudFront + ACM (+ Route 53 when ready to leave Wix)
- Terraform in `terraform/`

## Design direction

Inspired by premium event planners ([RGI Events](https://explore.rgievents.com/planning-lp/), [Signature Concepts](https://signatureconceptsllc.com/)):

- Full-bleed hero with poolside celebration photo
- Lord Chesterfield quote band (carried from original site)
- Services grid covering all listed offerings
- 9-image gallery from field photos
- Instagram link (@EventsByElainaB)
- Consultation / inquiry contact form

## Quick start

**Preview locally:** open `index.html` in a browser.

**Deploy to AWS:** see [terraform/README.md](terraform/README.md).

## To customize

| Item | Where |
|------|--------|
| Business email | `index.html`, `app.js` (`CONTACT_EMAIL`) |
| Services | `index.html` → `#services` |
| Gallery | `assets/gallery/` + `index.html` + `terraform/main.tf` |
| Logo | Add to `assets/` when available (header uses text branding for now) |
| Additional photos from Wix gallery | Copy to `assets/gallery/` and update HTML |

## Contact info on site

- **Phone:** 202-213-5369
- **Instagram:** [@EventsByElainaB](https://www.instagram.com/EventsByElainaB/)
- **Email:** info@eventsbyelainab.com (confirm with Elaina)

## Photos

Source originals: `../Event Photos/` (Event 1–5).  
Web copies: `assets/hero/`, `assets/about/`, `assets/gallery/`.

More photos from the current Wix gallery can be added anytime.
