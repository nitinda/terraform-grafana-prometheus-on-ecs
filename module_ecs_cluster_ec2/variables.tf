variable "ecs_cluster_name" {
  description = "description"
}

variable "web_subnet_ids" {
  description = "description"
  type = "list"
}

variable "public_subnet_ids" {
  description = "description"
  type = "list"
}

variable "public_subnet_cidr_blocks" {
  description = "description"
  type = "list"
}

variable "vpc_id" {
  description = "description"
}

variable common_tags {
  description = "Resources Tags"
  type        = "map"
}

## IAM 
variable "ecs_instance_profile_name" {
  description = "description"
}


locals {
  instance_types  = ["${data.null_data_source.null_resource_override_instance_types.*.outputs}"]
}

variable "override_instance_types" {
  description = "The size of instance to launch, minimum 2 types must be specified."
  type        = "list"
}
