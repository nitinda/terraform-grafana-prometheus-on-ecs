resource "aws_autoscaling_group" "demo_ecs_autoscaling_group" {
    name                        = "terraform-demo-ecs-autoscaling-group"
    max_size                    = 3
    min_size                    = 2
    desired_capacity            = 2
    vpc_zone_identifier         = ["${var.web_subnet_ids}"]
    health_check_type           = "EC2"
    health_check_grace_period   = 2
    default_cooldown            = 2
    force_delete                = true
    lifecycle {
        create_before_destroy = true
    }
    tag {
        key                 = "Name"
        value               = "terraform-demo-ecs-ec2-worker-node"
        propagate_at_launch = true
    }
    tag {
        key                 = "Owner"
        value               = "${lookup(var.common_tags, "Owner")}"
        propagate_at_launch = true
    }
    tag {
        key                 = "Project"
        value               = "${lookup(var.common_tags, "Project")}"
        propagate_at_launch = true
    }
    tag {
        key                 = "BusinessUnit"
        value               = "${lookup(var.common_tags, "BusinessUnit")}"
        propagate_at_launch = true
    }
    mixed_instances_policy {
        launch_template {
            launch_template_specification {
                launch_template_id = "${aws_launch_template.demo_launch_template_ecs_worker_node.id}"
                version            = "$$Latest"
            }
            override = ["${local.instance_types}"]
        }
        instances_distribution {
            on_demand_percentage_above_base_capacity = 0
            on_demand_allocation_strategy = "prioritized"
            on_demand_base_capacity       = 0
            spot_allocation_strategy      = "capacity-optimized"
        }
  }
}