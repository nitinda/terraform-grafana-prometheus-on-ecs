terraform {
  required_version = ">= 0.11.7"
}



#######################  IAM

module "aws_resources_module_iam_ecs" {
  source  = "../module_iam_ecs"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags     = "${var.common_tags}"
  aws_account_ids = {
    Accounts-1 = "760341739473"
    Accounts-2 = "${data.aws_caller_identity.demo_caller_identity_current.account_id}"
  }
}

module "aws_resources_module_iam_grafana" {
  source  = "../module_iam_grafana"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags       = "${var.common_tags}"
  ecs_task_role_arn = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
  aws_account_ids = {
    Accounts-1 = "760341739473"
    Accounts-2 = "${data.aws_caller_identity.demo_caller_identity_current.account_id}"
  }
}

# ########################## SSM Parameters

module "aws_resources_module_kms_ssm_parameters" {
  source = "../module_kms"

  common_tags        = "${var.common_tags}"
  kmy_key_alias_name = "alias/terraform-demo-kms-key-ssm-parameters"
  kmy_key_name       = "terraform-demo-kms-key-ssm-parameters"  
}

module "aws_resources_module_ssm_parameters_rds_database_password" {
  source  = "../module_ssm_parameters"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags = "${var.common_tags}"
  ssm_parameter_name  = "/grafana/terraform-demo-ssm-parameter-rds-database-password"
  ssm_parameter_value = "asdaj1k23hjh1234fghj"
  kms_key_id          = "${module.aws_resources_module_kms_ssm_parameters.kms_key_arn}"
}

module "aws_resources_module_ssm_parameters_rds_database_user" {
  source  = "../module_ssm_parameters"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags = "${var.common_tags}"
  ssm_parameter_name  = "/grafana/terraform-demo-ssm-parameter-rds-database-user"
  ssm_parameter_value = "grafana"
  kms_key_id          = "${module.aws_resources_module_kms_ssm_parameters.kms_key_arn}"
}


module "aws_resources_module_ssm_parameters_grafana_password" {
  source  = "../module_ssm_parameters"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags = "${var.common_tags}"
  ssm_parameter_name  = "/grafana/terraform-demo-ssm-parameter-grafana-password"
  ssm_parameter_value = "asdaj1k23hjh1234fghj"
  kms_key_id          = "${module.aws_resources_module_kms_ssm_parameters.kms_key_arn}"
}



########################## Network

module "network" {
  source               = "git::https://github.com/nitinda/terraform_aws_module_network.git?ref=master"

  providers = {
    "aws"  = "aws.aws_services"
  }

  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  # Subnet
  public_subnets_cidr  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnets_cidr = ["10.20.3.0/24", "10.20.4.0/24"]
  db_subnets_cidr      = ["10.20.5.0/24", "10.20.6.0/24"]
  availability_zones   = ["eu-central-1a", "eu-central-1b"]

  # Tags
  common_tags = "${var.common_tags}"
}



# ########################## RDS

module "aws_resources_module_rds_aurora_serverless_grafana" {
  source = "../module_rds_aurora_serverless"
  
  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags     = "${var.common_tags}"
  vpc_id          = "${module.network.vpc_id}"
  db_subnet_ids   = "${module.network.db_subnet_ids}"
  web_subnet_cidr = "${module.network.web_subnet_cidr_blocks}"

  db_instance_type                   = "db.t2.small"
  cluster_instance_identifier_name   = "terraform-demo-db-cluster-instance-identifier-grafana"
  db_subnet_group_name               = "terraform-demo-db-subnet-group-aurora-grafana"
  rds_master_password                = "${module.aws_resources_module_ssm_parameters_rds_database_password.ssm_parameter_value}"
  rds_master_username                = "${module.aws_resources_module_ssm_parameters_rds_database_user.ssm_parameter_value}"
  database_name                      = "${module.aws_resources_module_ssm_parameters_rds_database_user.ssm_parameter_value}"
  auto_pause                         = true
  max_capacity                       = 8
  min_capacity                       = 1
  apply_immediately                  = true
  db_cluster_identifier_prefix       = "${module.aws_resources_module_ssm_parameters_rds_database_user.ssm_parameter_value}"
}



########################## ECS on EC2

module "aws_resources_module_ecs_cluster_ec2" {
  source  = "../module_ecs_cluster_ec2"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags               = "${var.common_tags}"
  ecs_cluster_name          = "${var.ecs_cluster_name}"
  vpc_id                    = "${module.network.vpc_id}"
  web_subnet_ids            = "${module.network.web_subnet_ids}"
  public_subnet_ids         = "${module.network.public_subnet_ids}"
  public_subnet_cidr_blocks = "${module.network.public_subnet_cidr_blocks}"
  ecs_instance_profile_name = "${module.aws_resources_module_iam_ecs.ecs_instance_profile_name}"
  override_instance_types   = "${var.override_instance_types}"
}


module "aws_resources_module_ecs_cluster_ec2_autoscalling_policy" {
  source  = "../module_autoscalling_policy"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags             = "${var.common_tags}"
  autoscaling_group_name  = "${module.aws_resources_module_ecs_cluster_ec2.ecs_autoscalling_group_name}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 30
  scaling_adjustment      = 8
  autoscaling_policy_name = "terraform-demo-ecs-autoscaling-policy-target-tracking-scaling"
  simplescaling_enabled   = false
  targettrackingscaling_enabled = true
}


# ##################################################################################
# ##########################    Grafana ECS EC2  ###################################


module "aws_resources_module_ecs_ec2_grafana_rds" {
  source  = "../module_ecs_ec2_grafana_rds"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags                 = "${var.common_tags}"
  vpc_id                      = "${module.network.vpc_id}"
  public_subnet_ids           = "${module.network.public_subnet_ids}"
  web_subnet_ids              = "${module.network.web_subnet_ids}"
  ecs_cluster_name            = "${module.aws_resources_module_ecs_cluster_ec2.ecs_cluster_name}"
  ecs_task_execution_role_arn = "${module.aws_resources_module_iam_ecs.ecs_task_execution_role_arn}"
  ecs_task_role_arn           = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
  grafana_image_url           = "grafana/grafana:6.2.5"

  rds_cluster_endpoint            = "${module.aws_resources_module_rds_aurora_serverless_grafana.rds_cluster_endpoint}"
  grafana_database_password       = "${module.aws_resources_module_ssm_parameters_grafana_password.ssm_parameter_value}"
  rds_cluster_database_name       = "${module.aws_resources_module_rds_aurora_serverless_grafana.rds_cluster_database_name}"
  grafana_security_admin_password = "${module.aws_resources_module_ssm_parameters_grafana_password.ssm_parameter_value}"
}



# ##########################    Prometheus ECS EC2  ###################################


module "aws_resources_module_ecs_ec2_prometheus" {
  source  = "../module_ecs_ec2_prometheus"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags                         = "${var.common_tags}"
  vpc_id                              = "${module.network.vpc_id}"
  public_subnet_ids                   = "${module.network.public_subnet_ids}"
  web_subnet_ids                      = "${module.network.web_subnet_ids}"
  ecs_cluster_name                    = "${module.aws_resources_module_ecs_cluster_ec2.ecs_cluster_name}"
  ecs_task_execution_role_arn         = "${module.aws_resources_module_iam_ecs.ecs_task_execution_role_arn}"
  ecs_task_role_arn                   = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
  prometheus_image_url                = "nitindas/prometheus-custom:latest"
  prometheus_log_group_stream_prefix  = "terraform-demo-prometheus"
  prometheus_container_name           = 9090
  prometheus_container_container_port = 9090
}