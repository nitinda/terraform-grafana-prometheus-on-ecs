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
