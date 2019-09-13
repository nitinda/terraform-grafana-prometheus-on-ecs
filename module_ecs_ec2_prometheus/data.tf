data "aws_region" "demo_current" {}

data "template_file" "demo_template_file_ecs_task_definition_prometheus" {
  template = "${file("${path.module}/task-definitions/ecs-task-definition-prometheus.json")}"

  vars {
    prometheus_image_url                = "${var.prometheus_image_url}"
    prometheus_log_group_region         = "${data.aws_region.demo_current.name}"
    prometheus_log_group_name           = "${aws_cloudwatch_log_group.demo_cloudwatch_log_group_ecs_prometheus.name}"
    prometheus_log_group_stream_prefix  = "${var.prometheus_log_group_stream_prefix}"
    prometheus_container_name           = "${var.prometheus_container_name}"
    prometheus_container_container_port = "${var.prometheus_container_container_port}"
    prometheus_container_host_port      = "${var.prometheus_container_host_port}"
  }
}