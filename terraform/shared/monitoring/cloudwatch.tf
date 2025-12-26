# CloudWatch for basic monitoring and cost alerts

# SNS topic for alerts (you'll subscribe your email to this)
resource "aws_sns_topic" "alerts" {
  name = "kuroshio-lab-alerts"

  tags = {
    Name = "kuroshio-lab-alerts"
  }
}

# Cost alarm - alerts when monthly costs exceed threshold
resource "aws_cloudwatch_metric_alarm" "high_cost" {
  alarm_name          = "high-monthly-cost"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600" # 6 hours
  statistic           = "Maximum"
  threshold           = "50" # Alert if costs exceed $50
  alarm_description   = "Alert when monthly AWS costs exceed $50"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    Currency = "USD"
  }
}

# Log group for shared infrastructure logs
resource "aws_cloudwatch_log_group" "shared_infra" {
  name              = "/kuroshio-lab/shared-infrastructure"
  retention_in_days = 7 # Keep logs for 7 days only (cost savings)

  tags = {
    Name = "shared-infrastructure-logs"
  }
}
