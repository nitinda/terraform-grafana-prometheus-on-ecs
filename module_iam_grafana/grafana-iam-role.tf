resource "aws_iam_role" "demo_iam_role_grafana" {
  name               = "terraform-demo-iam-role-grafana-assume"
  assume_role_policy = "${data.aws_iam_policy_document.demo_iam_role_policy_document_grafana_assume.json}"
  description        = "IAM Role for Grafana service"
  path               = "/service-role/"
  
  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-iam-role-grafana",
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "demo_iam_role_policy_grafana_access" {
  name   = "terraform-demo-iam-role-policy-grafana-access"
  role   = "${aws_iam_role.demo_iam_role_grafana.name}"
  policy = "${data.aws_iam_policy_document.demo_iam_role_policy_document_grafana_aceess.json}"
}

data "aws_iam_policy_document" "demo_iam_role_policy_document_grafana_assume" {
  statement {
    sid     = "AllowTrustedAccountsToAssumeTheRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${var.ecs_task_role_arn}"]
    }
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    
  }
}

data "aws_iam_policy_document" "demo_iam_role_policy_document_grafana_aceess" {
  statement {
    sid    = "AllowReadingMetricsFromCloudWatch"
    effect = "Allow"

    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowReadingTagsFromEC2"
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeRegions",
      "ec2:DescribeSpotFleetInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeReservedInstancesOfferings",
      "ec2:DescribeFleetInstances",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeReservedInstances",
      "ec2:DescribeInstanceStatus"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowReadingResourcesForTags"
    effect = "Allow"

    actions = [
      "tag:GetResources"
    ]

    resources = ["*"]
  }
}