variable "project_name" { type = string }
variable "environment" { type = string }

variable "force_destroy" {
  description = "Allow terraform destroy even if the bucket has objects (lab-friendly)."
  type        = bool
  default     = true
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "static" {
  bucket        = "${local.name_prefix}-static-${random_id.suffix.hex}"
  force_destroy = var.force_destroy

  tags = {
    Name = "${local.name_prefix}-static"
  }
}

resource "aws_s3_bucket_public_access_block" "static" {
  bucket = aws_s3_bucket.static.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "static" {
  bucket = aws_s3_bucket.static.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static" {
  bucket = aws_s3_bucket.static.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Keep lab storage cheap: expire noncurrent versions after 7 days.
resource "aws_s3_bucket_lifecycle_configuration" "static" {
  bucket = aws_s3_bucket.static.id

  rule {
    id     = "expire-noncurrent"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}
