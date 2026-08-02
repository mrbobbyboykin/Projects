output "pipeline_name" {
  value = aws_codepipeline.deploy.name
}

output "codebuild_project_name" {
  value = aws_codebuild_project.deploy.name
}

output "artifacts_bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}

output "codestar_connection_arn" {
  value = aws_codestarconnections_connection.github.arn
}

output "codestar_connection_status" {
  description = "Must be AVAILABLE before the pipeline can pull from GitHub."
  value       = aws_codestarconnections_connection.github.connection_status
}

output "codestar_connection_console_hint" {
  value = "AWS Console → Developer Tools → Connections → select '${aws_codestarconnections_connection.github.name}' → Update pending connection / Complete handshake with GitHub."
}
