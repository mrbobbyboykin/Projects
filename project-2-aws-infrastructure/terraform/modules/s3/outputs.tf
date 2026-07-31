output "bucket_name" {
  value = aws_s3_bucket.static.id
}

output "bucket_arn" {
  value = aws_s3_bucket.static.arn
}

output "bucket_region" {
  value = aws_s3_bucket.static.region
}
