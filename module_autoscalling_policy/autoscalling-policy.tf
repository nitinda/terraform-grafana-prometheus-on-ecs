# resource "aws_autoscaling_policy" "demo_autoscaling_policy_simple_scaling" {
#   count                  = "${var.simplescaling_enabled}"
#   adjustment_type        = "${var.adjustment_type}"
#   autoscaling_group_name = "${var.autoscaling_group_name}"
#   cooldown               = "${var.cooldown}"
#   name                   = "${var.autoscaling_policy_name}"
#   policy_type            = "SimpleScaling"
#   scaling_adjustment     = "${var.scaling_adjustment}"
# }

# resource "aws_autoscaling_policy" "demo_autoscaling_policy_target_tracking_scaling" {
#   count                     = "${var.targettrackingscaling_enabled}"
#   adjustment_type           = "${var.adjustment_type}"
#   autoscaling_group_name    = "${var.autoscaling_group_name}"
#   name                      = "${var.autoscaling_policy_name}"
#   policy_type               = "TargetTrackingScaling"
#   estimated_instance_warmup = 15

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#     target_value = 40.0
#   }
# }