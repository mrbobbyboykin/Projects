# Events by ElainaB — AWS website (Terraform)

Deploys the static site to **S3 + CloudFront** with **ACM** HTTPS and optional **Route 53** DNS for `eventsbyelainab.com`.

## Current site

The live site at [eventsbyelainab.com](https://www.eventsbyelainab.com/) is on Wix. This replaces it when you're ready to cut over DNS.

## Prerequisites

- AWS account with payment method
- Terraform `>= 1.5`
- Site files in the parent folder

## Local preview

Open `index.html` in a browser, or:

```bat
cd "C:\Users\bboyk\OneDrive\Business\Events By ElainaB LLC\Website"
python -m http.server 8080
```

## Deploy / update

```bat
cd "C:\Users\bboyk\OneDrive\Business\Events By ElainaB LLC\Website\terraform"
copy terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

With `enable_route53 = false`, the site is live at the CloudFront URL immediately.

## Cut over from Wix

1. Set `enable_route53 = true` in `terraform.tfvars`
2. Run `terraform apply`
3. Point domain nameservers to `terraform output route53_name_servers`
4. Cancel Wix hosting when the new site is verified

## Invalidate CloudFront cache

```bat
terraform output cloudfront_distribution_id
aws cloudfront create-invalidation --distribution-id <id> --paths "/*"
```

## Adding gallery photos

1. Add images under `assets/gallery/`
2. Add each path to `local.site_files` in `main.tf`
3. Reference in `index.html`
4. `terraform apply` + invalidate CloudFront

## Cost (low traffic)

| Piece | Notes |
|-------|--------|
| S3 + CloudFront | Cents–low dollars/mo |
| ACM | Free |
| Route 53 hosted zone | ~$0.50/mo |
