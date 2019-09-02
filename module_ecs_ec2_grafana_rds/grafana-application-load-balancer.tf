resource "aws_alb" "demo_alb_ecs_grafana" {
    name                = "terraform-demo-alb-ecs-grafana"
    security_groups     = ["${aws_security_group.demo_security_group_alb_ecs_grafana.id}"]
    subnets             = ["${var.public_subnet_ids}"]

    tags = "${merge(var.common_tags, map(
        "Name", "terraform-demo-alb-ecs-grafana",
    ))}"
}

resource "aws_alb_target_group" "demo_alb_target_group_ip_ecs_grafana" {
    name                 = "grafana-tg"
    port                 = "3000"
    protocol             = "HTTP"
    vpc_id               = "${var.vpc_id}"
    deregistration_delay = 5
    target_type          = "ip"
    depends_on           = ["aws_alb.demo_alb_ecs_grafana"]

    lifecycle {
        create_before_destroy = true
    }

    health_check {
        healthy_threshold   = "2"
        unhealthy_threshold = "2"
        interval            = "5"
        matcher             = "200"
        path                = "/login"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "3"
    }

    tags = "${merge(var.common_tags, map(
        "Name", "terraform-demo-alb-target-group-ip-ecs-grafana",
        "Description", "Target Group for Grafana",
    ))}"
}

resource "aws_alb_listener" "demo_alb_listener_ecs_grafana_front_end_http" {
    load_balancer_arn = "${aws_alb.demo_alb_ecs_grafana.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.demo_alb_target_group_ip_ecs_grafana.arn}"
        type             = "forward"
    }
}