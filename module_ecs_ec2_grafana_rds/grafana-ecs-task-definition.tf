resource "aws_ecs_task_definition" "demo_ecs_task_definition_grafana" {
  family                   = "terraform-demo-ecs-task-definition-grafana"
  container_definitions    = "${data.template_file.demo_template_file_ecs_task_definition_grafana.rendered}"
  requires_compatibilities = ["EC2"]
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = "${var.ecs_task_role_arn}"
  execution_role_arn       = "${var.ecs_task_execution_role_arn}"
  network_mode             = "awsvpc"
}