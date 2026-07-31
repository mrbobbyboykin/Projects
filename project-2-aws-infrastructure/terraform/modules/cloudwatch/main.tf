variable "project_name" { type = string }
variable "environment" { type = string }

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "asg_name" {
  type = string
}

variable "rds_identifier" {
  description = "RDS DB instance id when enable_rds is true; null otherwise."
  type        = string
  default     = null
}

variable "alarm_email" {
  description = "Optional email for SNS alarm notifications. Empty = no subscription."
  type        = string
  default     = ""
}

locals {
  name_prefix   = "${var.project_name}-${var.environment}"
  enable_rds    = var.rds_identifier != null && var.rds_identifier != ""
  enable_sns    = var.alarm_email != ""
  alarm_actions = local.enable_sns ? [aws_sns_topic.alarms[0].arn] : []
}

resource "aws_sns_topic" "alarms" {
  count = local.enable_sns ? 1 : 0
  name  = "${local.name_prefix}-alarms"
}

resource "aws_sns_topic_subscription" "email" {
  count = local.enable_sns ? 1 : 0

  topic_arn = aws_sns_topic.alarms[0].arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${local.name_prefix}-dashboard"

  dashboard_body = jsonencode({
    widgets = concat(
      [
        {
          type   = "metric"
          x      = 0
          y      = 0
          width  = 12
          height = 6
          properties = {
            title  = "ALB RequestCount"
            view   = "timeSeries"
            region = data.aws_region.current.name
            metrics = [
              ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix, { stat = "Sum" }]
            ]
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 0
          width  = 12
          height = 6
          properties = {
            title  = "ALB UnHealthyHostCount"
            view   = "timeSeries"
            region = data.aws_region.current.name
            metrics = [
              ["AWS/ApplicationELB", "UnHealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix, { stat = "Average" }]
            ]
          }
        },
        {
          type   = "metric"
          x      = 0
          y      = 6
          width  = 12
          height = 6
          properties = {
            title  = "ALB HTTP 5xx (ELB)"
            view   = "timeSeries"
            region = data.aws_region.current.name
            metrics = [
              ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.alb_arn_suffix, { stat = "Sum" }]
            ]
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 6
          width  = 12
          height = 6
          properties = {
            title  = "ASG Average CPU"
            view   = "timeSeries"
            region = data.aws_region.current.name
            metrics = [
              ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name, { stat = "Average" }]
            ]
          }
        }
      ],
      local.enable_rds ? [
        {
          type   = "metric"
          x      = 0
          y      = 12
          width  = 12
          height = 6
          properties = {
            title  = "RDS CPUUtilization"
            view   = "timeSeries"
            region = data.aws_region.current.name
            metrics = [
              ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_identifier, { stat = "Average" }]
            ]
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 12
          width  = 12
          height = 6
          properties = {
            title  = "RDS FreeStorageSpace"
            view   = "timeSeries"
            region = data.aws_region.current.name
            metrics = [
              ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.rds_identifier, { stat = "Average" }]
            ]
          }
        }
      ] : []
    )
  })
}

data "aws_region" "current" {}

resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "${local.name_prefix}-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  alarm_description   = "ALB has unhealthy targets"
  treat_missing_data  = "notBreaching"
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "${local.name_prefix}-asg-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "ASG average CPU above 70%"
  treat_missing_data  = "notBreaching"
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  count = local.enable_rds ? 1 : 0

  alarm_name          = "${local.name_prefix}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "RDS CPU above 80%"
  treat_missing_data  = "notBreaching"
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  count = local.enable_rds ? 1 : 0

  alarm_name          = "${local.name_prefix}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 2000000000 # ~2 GB
  alarm_description   = "RDS free storage below ~2 GB"
  treat_missing_data  = "notBreaching"
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }
}
