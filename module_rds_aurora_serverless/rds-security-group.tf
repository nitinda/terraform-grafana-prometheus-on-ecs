resource "aws_security_group" "demo_security_group_rds_aurora" {
  name_prefix = "terraform-demo-security-group-rds-aurora-"
  description = "RDS Aurora access from internal security groups"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description = "Allow 3306 from defined security groups"
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["${var.web_subnet_cidr}"]
  }

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-security-group-rds-aurora",
    "Description", "RDS Aurora access from internal security groups",
    "ManagedBy", "Terraform"
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}
