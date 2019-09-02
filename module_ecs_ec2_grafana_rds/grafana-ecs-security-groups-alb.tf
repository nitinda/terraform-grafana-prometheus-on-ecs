resource "aws_security_group" "demo_security_group_alb_ecs_grafana" {
    name = "terraform-demo-security-group-alb-ecs-grafana"
    description = "The alb security group that allows port 80/443 from whitelisted ips"
    vpc_id = "${var.vpc_id}"
    
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }
    egress {
        # allow all traffic to private SN
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }
}