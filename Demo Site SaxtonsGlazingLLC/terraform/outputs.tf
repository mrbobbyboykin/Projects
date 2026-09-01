output "website_cloudfront_url" {
  description = "CloudFront URL (works immediately; use while DNS is not configured)."
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.site.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.site.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.site.id
}

output "domain_name" {
  value = var.domain_name
}

output "route53_name_servers" {
  description = "If enable_route53=true, set these as the domain nameservers at your registrar."
  value       = var.enable_route53 ? aws_route53_zone.site[0].name_servers : null
}

output "apex_url" {
  description = "Public site URL after nameservers propagate."
  value       = var.enable_route53 ? "https://${var.domain_name}" : null
}

output "www_url" {
  value = var.enable_route53 ? "https://www.${var.domain_name}" : null
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.site.arn
}

output "security_headers_policy_id" {
  description = "CloudFront response headers policy (HSTS, CSP, nosniff, frame deny)."
  value       = aws_cloudfront_response_headers_policy.security.id
}
