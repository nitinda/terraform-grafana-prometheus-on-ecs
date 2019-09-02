resource "aws_db_subnet_group" "demo_db_subnet_group_aurora" {
  name        = "${var.db_subnet_group_name}"
  description = "Subnets to launch RDS database into"
  subnet_ids  = ["${var.db_subnet_ids}"]

  tags = "${merge(var.common_tags, map(
    "Name", "${var.db_subnet_group_name}",
    "Description", "Subnets to use for RDS databases",
    "ManagedBy", "Terraform"
  ))}"
}
