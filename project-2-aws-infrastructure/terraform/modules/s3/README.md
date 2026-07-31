# S3 static assets module (Phase 4)

Private S3 bucket for static assets (portfolio / lab). Public access is blocked.

## Resources

- S3 bucket (globally unique name suffix)
- Public access block (all four settings on)
- Versioning enabled
- SSE-S3 (AES256) encryption
- Lifecycle: expire noncurrent versions after 7 days
- `force_destroy = true` so `terraform destroy` works with objects present

## Outputs

`bucket_name`, `bucket_arn`, `bucket_region`
