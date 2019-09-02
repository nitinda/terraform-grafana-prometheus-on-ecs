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

variable "prometheus_image_url" {
  description = "the image url for the prometheus image"
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