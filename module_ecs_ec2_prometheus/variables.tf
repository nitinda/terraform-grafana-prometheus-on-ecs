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

variable "prometheus_log_group_stream_prefix" {
  description = "description"
}
variable "prometheus_container_name" {
  description = "description"
}

variable "prometheus_container_container_port" {
  description = "description"
}

variable "prometheus_container_host_port" {
  description = "description"
}

variable "prometheus_source_volume_name" {
  description = "description"
}

variable "prometheus_assume_role_arn" {
  description = "description"
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