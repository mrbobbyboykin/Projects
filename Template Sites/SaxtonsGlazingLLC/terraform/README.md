# Saxton's Glazing & Aluminum — AWS website (Terraform)

Deploys the static site to **S3 + CloudFront** with **ACM** HTTPS and optional **Route 53** DNS.

Same cost-efficient pattern as the OEMVending site: private S3 origin, CloudFront OAC, security headers, no build step.

## Prerequisites

- AWS account with payment method
- Terraform `>= 1.5`
- Site files in the parent folder

## Local preview

Open `index.html` in a browser, or use a simple static server:

```bat
cd "C:\Users\bboyk\OneDrive\Business\Saxton Glazing & Aluminum LLC\Website"
python -m http.server 8080
```

Then visit `http://localhost:8080`.

## Deploy / update

```bat
cd "C:\Users\bboyk\OneDrive\Business\Saxton Glazing & Aluminum LLC\Website\terraform"
copy terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

With `enable_route53 = false` (default), the site is live at the CloudFront URL immediately — useful before a domain is purchased.

## Domain setup (when ready)

1. Register a domain in Route 53 (e.g. `saxtonsglazing.com`)
2. Set `enable_route53 = true` in `terraform.tfvars`
3. Run `terraform apply`
4. Point the registered domain nameservers to `terraform output route53_name_servers`

## Invalidate CloudFront cache

```bat
terraform output cloudfront_distribution_id
aws cloudfront create-invalidation --distribution-id <id> --paths "/*"
```

## Adding photos

1. Add images under `assets/gallery/` (or other `assets/` subfolders)
2. Add each file path to `local.site_files` in `main.tf`
3. Reference in `index.html`
4. `terraform apply` + invalidate CloudFront

## Before go-live checklist

- [ ] Confirm business email — update `index.html` and `CONTACT_EMAIL` in `app.js`
- [ ] Finalize services list in `index.html`
- [ ] Add extracted logo PNG (replace text "SGA" mark in header if desired)
- [ ] Purchase domain and enable Route 53
- [ ] Rename project folders in `Photos/` for clearer gallery captions

## Cost (low traffic)

| Piece | Notes |
|-------|--------|
| S3 + CloudFront | Cents–low dollars/mo |
| ACM | Free |
| Route 53 hosted zone | ~$0.50/mo |
| `.com` registration | ~$15/yr |

## Related folders

| Path | Purpose |
|------|---------|
| `../Photos/` | Source project and truck photos |
| `../Website/assets/` | Web-optimized copies deployed to S3 |
