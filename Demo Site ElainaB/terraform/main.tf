locals {
  site_root  = "${path.module}/.."
  www_domain = "www.${var.domain_name}"

  site_files = {
    "index.html"                               = "${local.site_root}/index.html"
    "styles.css"                               = "${local.site_root}/styles.css"
    "app.js"                                   = "${local.site_root}/app.js"
    "assets/logo.jpg"                          = "${local.site_root}/assets/logo.jpg"
    "assets/hero/hero.jpg"                     = "${local.site_root}/assets/hero/hero.jpg"
    "assets/about/about.jpg"                   = "${local.site_root}/assets/about/about.jpg"
    "assets/gallery/gallery-01-poolside.jpg"   = "${local.site_root}/assets/gallery/gallery-01-poolside.jpg"
    "assets/gallery/gallery-02-main-squeeze.jpg" = "${local.site_root}/assets/gallery/gallery-02-main-squeeze.jpg"
    "assets/gallery/gallery-03-catering.jpg"   = "${local.site_root}/assets/gallery/gallery-03-catering.jpg"
    "assets/gallery/gallery-04-sneaker-ball.jpg" = "${local.site_root}/assets/gallery/gallery-04-sneaker-ball.jpg"
    "assets/gallery/gallery-05-wedding-table.jpg" = "${local.site_root}/assets/gallery/gallery-05-wedding-table.jpg"
    "assets/gallery/gallery-06-dessert-station.jpg" = "${local.site_root}/assets/gallery/gallery-06-dessert-station.jpg"
    "assets/gallery/gallery-07-50th-birthday.jpg" = "${local.site_root}/assets/gallery/gallery-07-50th-birthday.jpg"
    "assets/gallery/gallery-08-baby-shower.jpg" = "${local.site_root}/assets/gallery/gallery-08-baby-shower.jpg"
    "assets/gallery/gallery-09-kids-party.jpg" = "${local.site_root}/assets/gallery/gallery-09-kids-party.jpg"
  }

  content_types = {
    html = "text/html; charset=utf-8"
    css  = "text/css; charset=utf-8"
    js   = "application/javascript; charset=utf-8"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    png  = "image/png"
  }
}

data "aws_caller_identity" "current" {}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "aws_s3_bucket" "site" {
  bucket        = "${var.name_prefix}-${var.environment}-web-${random_id.suffix.hex}"
  force_destroy = var.force_destroy_bucket

  tags = {
    Name = "${var.name_prefix}-${var.environment}-web"
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "site" {
  for_each = local.site_files

  bucket       = aws_s3_bucket.site.id
  key          = each.key
  source       = each.value
  etag         = filemd5(each.value)
  content_type = lookup(local.content_types, reverse(split(".", each.key))[0], "application/octet-stream")
}

resource "aws_acm_certificate" "site" {
  domain_name               = var.domain_name
  subject_alternative_names = [local.www_domain]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name_prefix}-cert"
  }
}

resource "aws_route53_zone" "site" {
  count = var.enable_route53 ? 1 : 0
  name  = var.domain_name

  tags = {
    Name = "${var.name_prefix}-zone"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = var.enable_route53 ? {
    for dvo in aws_acm_certificate.site.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.site[0].zone_id
}

resource "aws_acm_certificate_validation" "site" {
  count = var.enable_route53 ? 1 : 0

  certificate_arn         = aws_acm_certificate.site.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "${var.name_prefix}-${var.environment}-oac"
  description                       = "OAC for Events by ElainaB website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_response_headers_policy" "security" {
  name    = "${var.name_prefix}-${var.environment}-security-headers"
  comment = "HSTS, nosniff, frame deny, referrer policy, CSP for Events by ElainaB site"

  security_headers_config {
    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }

    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }

    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }

    content_security_policy {
      override                = true
      content_security_policy = "default-src 'self'; img-src 'self' data:; style-src 'self' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; script-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self' mailto:"
    }
  }

  custom_headers_config {
    items {
      header   = "Permissions-Policy"
      override = true
      value    = "camera=(), microphone=(), geolocation=(), payment=()"
    }
  }
}

resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Events by ElainaB LLC website"
  default_root_object = "index.html"
  price_class         = var.cloudfront_price_class
  aliases             = var.enable_route53 ? [var.domain_name, local.www_domain] : []

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "${var.name_prefix}-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  default_cache_behavior {
    target_origin_id           = "${var.name_prefix}-s3"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 300
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.enable_route53 ? false : true
    acm_certificate_arn            = var.enable_route53 ? aws_acm_certificate_validation.site[0].certificate_arn : null
    ssl_support_method             = var.enable_route53 ? "sni-only" : null
    minimum_protocol_version       = var.enable_route53 ? "TLSv1.2_2021" : null
  }

  tags = {
    Name = "${var.name_prefix}-${var.environment}-cdn"
  }
}

data "aws_iam_policy_document" "site_bucket" {
  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.site.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.site_bucket.json
}

resource "aws_route53_record" "apex" {
  count = var.enable_route53 ? 1 : 0

  zone_id = aws_route53_zone.site[0].zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex_aaaa" {
  count = var.enable_route53 ? 1 : 0

  zone_id = aws_route53_zone.site[0].zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  count = var.enable_route53 ? 1 : 0

  zone_id = aws_route53_zone.site[0].zone_id
  name    = local.www_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_aaaa" {
  count = var.enable_route53 ? 1 : 0

  zone_id = aws_route53_zone.site[0].zone_id
  name    = local.www_domain
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}
