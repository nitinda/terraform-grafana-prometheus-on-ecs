# resource "aws_cloudwatch_metric_alarm" "demo_cloudwatch_metric_alarm_grafana_service_high_cpu" {
#   alarm_name          = "grafana-CPU-Utilization-High-40"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "40"

#   dimensions {
#     ClusterName = "${var.ecs_cluster_name}"
#     ServiceName = "${aws_ecs_service.demo_ecs_service_grafana.name}"
#   }

#   alarm_actions = ["${aws_appautoscaling_policy.demo_appautoscaling_policy_ecs_service_up.arn}"]
# }

# resource "aws_cloudwatch_metric_alarm" "demo_cloudwatch_metric_alarm_grafana_service_low_cpu" {
#   alarm_name          = "grafana-CPU-Utilization-Low-29"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = "5"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "29"

#   dimensions {
#     ClusterName = "${var.ecs_cluster_name}"
#     ServiceName = "${aws_ecs_service.demo_ecs_service_grafana.name}"
#   }

#   alarm_actions = ["${aws_appautoscaling_policy.demo_appautoscaling_policy_ecs_service_down.arn}"]
# }