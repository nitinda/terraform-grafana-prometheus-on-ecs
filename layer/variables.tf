# Glboal
variable "region" {
  description = "AWS region that will be used to create resources in."
  default     = "eu-central-1"
}

variable common_tags {
  description = "Resources Tags"
  type = "map"
  default = {
    Project      = "ECS POC"
    Owner        = "Platform Team"
    Environment  = "prod"
    BusinessUnit = "Platform Team"
  }  
}

variable "ecs_cluster_name" {
    default = "terraform-demo-ecs-cluster-ec2"  
}

variable "ecs_cluster_fargate_name" {
  description = "description"
  default = "terraform-demo-ecs-cluster-fargate"
}


variable "new_aws_account_ids" {
  description = "description"
  type = "map"
  default = {
    Account-1 = "760341739473"
  }
}

variable "override_instance_types" {
  description = "The size of instance to launch, minimum 2 types must be specified."
  type        = "list"
  default     = ["t3.xlarge", "t3.large"]
}
