resource "aws_ecs_task_definition" "demo_ecs_task_definition_prometheus" {
  family                   = "terraform-demo-ecs-task-definition-prometheus"
  container_definitions    = "${data.template_file.demo_template_file_ecs_task_definition_prometheus.rendered}"
  requires_compatibilities = ["EC2"]
  cpu                      = 512
  memory                   = 1024
  # task_role_arn            = "${var.ecs_task_role_arn}"
  execution_role_arn       = "${var.ecs_task_execution_role_arn}"
  network_mode             = "awsvpc"
  volume {
    name = "${var.prometheus_source_volume_name}"
    docker_volume_configuration {
      scope         = "shared"
      autoprovision = false
        # driver = "cloudstor-ebs:aws"
        # driver_opts {
        #   size        = 50,
        #   volumetype  = "gp2"
        #   relocatable = "backing"
        # }
        # labels {
        #   Project      = "${replace(var.common_tags["Project"], " ", "-")}"
        #   Owner        = "${replace(var.common_tags["Owner"], " ", "-")}"
        #   Environment  = "${replace(var.common_tags["Environment"], " ", "-")}"
        #   BusinessUnit = "${replace(var.common_tags["BusinessUnit"], " ", "-")}"
        # }
        driver = "rexray-aws-ebs"
        driver_opts {
          size       = 50,
          volumetype = "gp2"
        }

    }
  }
}