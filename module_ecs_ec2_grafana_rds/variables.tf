variable "ecs_cluster_name" {
  description = "description"
}

variable "ecs_task_role_arn" {
  description = "description"
}

variable "ecs_task_execution_role_arn" {
  description = "description"
}

variable common_tags {
  description = "Resources Tags"
  type = "map"
}

variable "grafana_image_url" {
  description = "the image url for the grafana image"
}


####

variable "public_subnet_ids" {
  description = "the load balancer subnets"
  type        = "list"
}

variable "web_subnet_ids" {
  description = "the subnets used for the grafana task"
  type = "list"
}

variable "vpc_id" {
  description = "The vpc id where grafana will be deployed"
}

variable "rds_cluster_endpoint" {
  description = "description"
}

variable "grafana_database_password" {
  description = "description"
}

variable "grafana_security_admin_password" {
  description = "description"
}


variable "rds_cluster_database_name" {
  description = "description"
}
