data "aws_region" "demo_current" {}

data "template_file" "demo_template_file_ecs_task_definition_grafana" {
  template = "${file("${path.module}/task-definitions/ecs-task-definition-grafana-rds.json")}"

  vars {
    grafana_image_url          = "${var.grafana_image_url}"
    grafana_log_group_region   = "${data.aws_region.demo_current.name}"
    grafana_log_group_name     = "${aws_cloudwatch_log_group.demo_cloudwatch_log_group_ecs_grafana.name}"
    GF_DATABASE_HOST           = "${var.rds_cluster_endpoint}"
    GF_DATABASE_TYPE           = "mysql"
    GF_DATABASE_USER           = "grafana"
    GF_DATABASE_PASSWORD       = "${var.grafana_database_password}"
    GF_DATABASE_NAME           = "${var.rds_cluster_database_name}"
    GF_SECURITY_ADMIN_PASSWORD = "${var.grafana_security_admin_password}"
  }
}