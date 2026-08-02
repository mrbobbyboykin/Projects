output "site_bucket_name" {
  description = "Private S3 bucket holding the static site."
  value       = module.s3_site.bucket_id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain — open https://<this>/ in a browser."
  value       = module.cloudfront.distribution_domain_name
}

output "cloudfront_url" {
  description = "HTTPS URL for the site."
  value       = "https://${module.cloudfront.distribution_domain_name}"
}

output "visitor_api_url" {
  description = "Direct API URL (also reachable via CloudFront /api/visitors)."
  value       = module.api.invoke_url
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.distribution_id
}
