resource "aws_rds_cluster_parameter_group" "demo_rds_cluster_parameter_group_aurora" {
  name        = "terraform-demo-rds-cluster-parameter-group-aurora"
  family      = "aurora5.6"
  description = "terraform-demo-rds-cluster-parameter-group-aurora-mysql"
  
  tags = "${merge(var.common_tags, map(
    "Description", "RDS Aurora cluster for the grafana environment",
    "ManagedBy", "Terraform"
  ))}"
}