# ECS Instance Security group
resource "aws_security_group" "demo_ecs_security_group_ec2" {
    name = "terraform-demo-security-group-ecs-ec2"
    description = "EC2 Security Group"
    vpc_id = "${var.vpc_id}"
    tags = "${merge(var.common_tags, map(
        "Name", "terraform-demo-security-group-ecs-ec2",
    ))}"    
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = [
           "${var.public_subnet_cidr_blocks}"
        ]
    }
    ingress {
        from_port   = 9090
        to_port     = 9090
        protocol    = "tcp"
        cidr_blocks = [
           "${var.public_subnet_cidr_blocks}"
        ]
    }
    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = [
           "${var.public_subnet_cidr_blocks}"
        ]
    }
    ingress {
        from_port   = 50000
        to_port     = 50000
        protocol    = "tcp"
        cidr_blocks = [
            "${var.public_subnet_cidr_blocks}"
        ]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [
           "${var.public_subnet_cidr_blocks}"
        ]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [
            "${var.public_subnet_cidr_blocks}"
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