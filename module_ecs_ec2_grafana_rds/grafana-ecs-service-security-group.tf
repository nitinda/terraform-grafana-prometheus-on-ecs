resource "aws_security_group" "demo_security_group_ecs_service_grafana" {
  description = "ingress to the grafana fargate task from the alb"

  vpc_id = "${var.vpc_id}"
  name   = "terraform-demo-security-group-ecs-service-grafana"

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = ["${aws_security_group.demo_security_group_alb_ecs_grafana.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
