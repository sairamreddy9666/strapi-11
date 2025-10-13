resource "aws_cloudwatch_log_group" "strapi_log_group" {
  name              = "/ecs/strapi"
  retention_in_days = 7
}

# -------------------------------
# CloudWatch Alarms
# -------------------------------

# High CPU Usage Alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when ECS service CPU > 80%"
  dimensions = {
    ClusterName = aws_ecs_cluster.ECS.name
    ServiceName = aws_ecs_service.ECS-Service.name
  }
}

# High Memory Usage Alarm
resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "HighMemoryUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when ECS service memory > 80%"
  dimensions = {
    ClusterName = aws_ecs_cluster.ECS.name
    ServiceName = aws_ecs_service.ECS-Service.name
  }
}

# -------------------------------
# CloudWatch Dashboard
# -------------------------------
resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "Strapi-ECS-Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 6
        properties = {
          metrics = [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.ECS.name, "ServiceName", aws_ecs_service.ECS-Service.name ],
            [ "AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.ECS.name, "ServiceName", aws_ecs_service.ECS-Service.name ]
          ]
          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "ECS Service CPU & Memory"
        }
      }
    ]
  })
}
