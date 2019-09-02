# resource "aws_appautoscaling_policy" "demo_appautoscaling_policy_ecs_service_up" {
#   name               = "terraform-demo-ecs-service-grafana-scale-up"
#   service_namespace  = "ecs"
#   resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.demo_ecs_service_grafana.name}"
#   scalable_dimension = "ecs:service:DesiredCount"

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 150
#     metric_aggregation_type = "Average"

#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = 2
#     }
#   }

#   depends_on = [
#     "aws_appautoscaling_target.demo_appautoscaling_target_service_scale_target",
#   ]
# }

# resource "aws_appautoscaling_policy" "demo_appautoscaling_policy_ecs_service_down" {
#   name               = "terraform-demo-ecs-service-grafana-scale-down"
#   service_namespace  = "ecs"
#   resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.demo_ecs_service_grafana.name}"
#   scalable_dimension = "ecs:service:DesiredCount"

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 1500
#     metric_aggregation_type = "Average"

#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   }

#   depends_on = [
#     "aws_appautoscaling_target.demo_appautoscaling_target_service_scale_target",
#   ]
# }

# resource "aws_appautoscaling_target" "demo_appautoscaling_target_service_scale_target" {
#   service_namespace  = "ecs"
#   resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.demo_ecs_service_grafana.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   min_capacity       = 2
#   max_capacity       = 8

#   depends_on = [
#     "aws_ecs_service.demo_ecs_service_grafana",
#   ]
# }
