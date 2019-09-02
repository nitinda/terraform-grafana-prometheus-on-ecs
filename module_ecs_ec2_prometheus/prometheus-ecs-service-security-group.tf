resource "aws_security_group" "demo_security_group_ecs_service_prometheus" {
  description = "ingress to the prometheus task from the alb"

  vpc_id = "${var.vpc_id}"
  name   = "terraform-demo-security-group-ecs-service-prometheus"

  ingress {
    protocol        = "tcp"
    from_port       = 9090
    to_port         = 9090
    security_groups = ["${aws_security_group.demo_security_group_alb_ecs_prometheus.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
