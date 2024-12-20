provider "aws" {}

resource "aws_route53_health_check" "https" {
  count             = length(var.dns_name)
  fqdn              = var.dns_name[count.index]
  port              = 443
  type              = "HTTPS"
  failure_threshold = var.failure_threshold
  request_interval  = var.request_interval
  resource_path     = "/healthz"
  regions           = var.health_check_regions
  measure_latency   = true

  tags = {
    Name            = "${var.dns_name[count.index]}-https"
    Environment     = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "https" {
  count             = length(var.dns_name)
  provider          = aws.virginia
  alarm_name        = "${var.dns_name[count.index]}-status-https-${var.alarm_name_suffix}"
  alarm_description = "Route53 health check status for ${var.dns_name[count.index]}"

  namespace         = "AWS/Route53"
  metric_name       = "HealthCheckStatus"

  dimensions = {
    HealthCheckId = aws_route53_health_check.https[count.index].id
  }

  comparison_operator = "LessThanThreshold"
  statistic           = "Minimum"
  threshold           = "1"

  evaluation_periods = "1"
  period             = "60"

  actions_enabled           = "true"
  alarm_actions             = var.alarm_actions
  ok_actions                = var.alarm_actions
  insufficient_data_actions = var.alarm_actions
}
