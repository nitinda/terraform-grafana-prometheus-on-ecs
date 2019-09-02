resource "aws_rds_cluster" "demo_rds_cluster_aurora_serverless" {
  engine                              = "aurora"
  engine_mode                         = "serverless"
  database_name                       = "${var.database_name}"
  cluster_identifier                  = "${format("%s-rds-cluster", var.db_cluster_identifier_prefix)}"
  master_username                     = "${var.rds_master_username}"
  master_password                     = "${var.rds_master_password}"
  storage_encrypted                   = true
  skip_final_snapshot                 = true
  apply_immediately                   = "${var.apply_immediately}"
  db_subnet_group_name                = "${aws_db_subnet_group.demo_db_subnet_group_aurora.name}"
  vpc_security_group_ids              = ["${aws_security_group.demo_security_group_rds_aurora.id}"]
  db_cluster_parameter_group_name     = "${aws_rds_cluster_parameter_group.demo_rds_cluster_parameter_group_aurora.id}"
  iam_database_authentication_enabled = false

  scaling_configuration {
    auto_pause   = "${var.auto_pause}"
    max_capacity = "${var.max_capacity}"
    min_capacity = "${var.min_capacity}"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(var.common_tags, map(
    "Name",        "terraform-demo-rds-cluster-aurora",
    "Description", "RDS Aurora cluster for the grafana environment",
    "ManagedBy",   "Terraform"
  ))}"
}