output "kms_key_arn" {
  description = "Customer-managed KMS key used for security log encryption."
  value       = aws_kms_key.security.arn
}

output "kms_key_alias" {
  value = aws_kms_alias.security.name
}

output "security_logs_bucket_name" {
  value = aws_s3_bucket.security_logs.id
}

output "cloudtrail_arn" {
  value = aws_cloudtrail.main.arn
}

output "cloudtrail_name" {
  value = aws_cloudtrail.main.name
}

output "config_recorder_name" {
  value = aws_config_configuration_recorder.main.name
}

output "guardduty_detector_id" {
  value = var.enable_guardduty ? aws_guardduty_detector.main[0].id : null
}

output "security_auditor_role_arn" {
  description = "Least-privilege SecurityAudit role (assume with MFA from this account)."
  value       = aws_iam_role.security_auditor.arn
}
