resource "aws_ecs_service" "demo_ecs_service_grafana" {
  name            = "terraform-demo-ecs-service-grafana"
  cluster         = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.demo_ecs_task_definition_grafana.family}:${max("${aws_ecs_task_definition.demo_ecs_task_definition_grafana.revision}", "${aws_ecs_task_definition.demo_ecs_task_definition_grafana.revision}")}"
  desired_count   = 1
  launch_type     = "EC2"
  health_check_grace_period_seconds = 300

  network_configuration {
    security_groups = ["${aws_security_group.demo_security_group_ecs_service_grafana.id}"]
    subnets         = ["${var.web_subnet_ids}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.demo_alb_target_group_ip_ecs_grafana.arn}"
    container_name   = "terraform-demo-container-definition-grafana"
    container_port   = 3000
  }

  # lifecycle {
  #   create_before_destroy = true
  #   ignore_changes = [
  #     "task_definition",
  #     "load_balancer",
  #   ]
  # }
  
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-central-1a, eu-central-1b]"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = ["aws_alb.demo_alb_ecs_grafana"]
}