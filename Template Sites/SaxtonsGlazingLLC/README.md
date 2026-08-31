# Saxton's Glazing & Aluminum — Website

One-page commercial contracting site for **Saxton's Glazing & Aluminum, LLC**.

## Stack

- Static HTML / CSS / JavaScript (no build step)
- AWS: S3 + CloudFront + ACM (+ Route 53 when domain is ready)
- Terraform in `terraform/`

## Design direction

Inspired by professional GC sites ([HITT DC](https://www.hitt.com/locations/washington-dc/), [Grunley](https://grunley.com/), [First American GC](https://firstamericangeneralcontracting.com/)):

- Hero with fleet photo and clear commercial positioning
- Services grid (core glazing capabilities; additional trades TBD)
- Project gallery from field photos
- MBE / licensed / bonded credentials
- Contact form (mailto) + phone CTA

## Quick start

**Preview locally:** open `index.html` in a browser.

**Deploy to AWS:** see [terraform/README.md](terraform/README.md).

## To customize

| Item | Where |
|------|--------|
| Business email | `index.html`, `app.js` (`CONTACT_EMAIL`) |
| Services list | `index.html` → `#services` |
| Gallery images | `assets/gallery/` + `index.html` + `terraform/main.tf` |
| Domain | `terraform/terraform.tfvars` |

## Photos

Source originals: `../Photos/` (organized by project).  
Web copies: `assets/hero/`, `assets/gallery/`.

When you have a clean services list from your dad, we can update the services section and add project captions.
