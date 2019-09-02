resource "aws_ecs_cluster" "demo_ecs_cluster_ec2" {
  name = "${var.ecs_cluster_name}"
  tags = "${var.common_tags}"
}