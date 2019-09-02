variable "database_name" {
  description = "description"
}

variable "rds_master_password" {
  description = "description"
}

variable "rds_master_username" {
  description = "description"
}

variable "db_subnet_group_name" {
  description = "description"
}

variable "db_cluster_identifier_prefix" {
  description = "description"
}

variable "cluster_instance_identifier_name" {
  description = "description"
}

variable "db_instance_type" {
  description = "the instance size for the Aurora database"
}

variable "max_capacity" {
  type        = "string"
  description = "The max capacity for database"
}

variable "min_capacity" {
  type        = "string"
  description = "The min capacity for database"
}

variable "auto_pause" {
  type        = "string"
  description = "When to perform DB auto pause"
}

variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
}

## VPC

variable "vpc_id" {
  description = "The vpc id where grafana will be deployed"
}

variable "db_subnet_ids" {
  description = "the subnets to launch the Aurora databse"
  type = "list"
}

variable "web_subnet_cidr" {
  description = "description"
  type = "list"
}

## Tags

variable common_tags {
  description = "Resources Tags"
  type        = "map"
}
