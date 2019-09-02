data "aws_region" "demo_region_current" {}

data "aws_caller_identity" "demo_caller_identity_current" {}

## Assume Role

data "aws_iam_policy_document" "demo_iam_policy_document_ecs_task_assume_role" {
  statement {
    sid    = "AllowECSTasksToAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "demo_iam_policy_document_ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    # principals {
    #   type        = "AWS"
    #   identifiers = ["arn:aws:iam::735276988266:role/service-role/terraform-demo-iam-role-grafana-assume"]
    # }
  }
}

data "aws_iam_policy_document" "demo_iam_policy_document_ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}





data "aws_iam_policy_document" "demo_iam_policy_document_ecs_task_role" {
  statement {
    sid     = "AllowServiceToAccessSecretsFromSSM"
    effect  = "Allow"
    actions = ["ssm:GetParametersByPath"]
    resources = [
      "arn:aws:ssm:${data.aws_region.demo_region_current.name}:${data.aws_caller_identity.demo_caller_identity_current.account_id}:parameter/grafana/*",
    ]
  }
  statement {
    sid       = "AllowAccessToKMSForDecryptingSSMParameters"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${data.aws_region.demo_region_current.name}:${data.aws_caller_identity.demo_caller_identity_current.account_id}:alias/aws/ssm"]
  }
  statement {
    sid       = "AllowAccessToAssumeGrafanaRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["${formatlist("arn:aws:iam::%s:role/terraform-demo-iam-role-grafana-assume", values(var.aws_account_ids))}"]
  }
  statement {
    sid       = "AllowAccessToAssumeEC2Role"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.demo_iam_role_ecs_ec2_role.arn}"]
  }
  statement {
    sid    = "DenyEverythingElse"
    effect = "Deny"
    not_actions = [
      "kms:Decrypt",
      "ssm:GetParametersByPath",
      "sts:AssumeRole",
    ]
    resources = ["*"]
  }
}