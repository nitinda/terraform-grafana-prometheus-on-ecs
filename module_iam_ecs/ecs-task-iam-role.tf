// task assume role policy document

resource "aws_iam_role" "demo_iam_role_ecs_task_role" {
  name               = "terraform-demo-iam-role-ecs-task-role"
  path               = "/service-role/"
  assume_role_policy = "${data.aws_iam_policy_document.demo_iam_policy_document_ecs_task_assume_role.json}"
  description        = "IAM Role for ECS Task"
  
  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-task-role",
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "demo_iam_role_policy_ecs_task" {
  name   = "terraform-demo-iam-role-inline-policy-ecs-task-role-1"
  role   = "${aws_iam_role.demo_iam_role_ecs_task_role.name}"
  policy = "${data.aws_iam_policy_document.demo_iam_policy_document_ecs_task_role.json}"
}

resource "aws_iam_role_policy" "demo_iam_role_inline_policy_ecs_task_role" {
  name = "terraform-demo-iam-role-inline-policy-ecs-task-role-2"
  role = "${aws_iam_role.demo_iam_role_ecs_task_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*Volume*",
        "ec2:*Snapshot*",
        "ec2:*networkinterface*",
        "ec2:DeleteTags",
        "ec2:DescribeTags",
        "ec2:CreateTags",
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
        "Sid": "AllowKMS",
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Effect": "Allow",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
          "kms:CreateGrant"
        ],
        "Resource": "*",
        "Condition": {
            "Bool": {
              "kms:GrantIsForAWSResource": true
            }
        }
    },
    {
      "Sid": "AllowEFS",
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:DescribeMountTargets",
        "elasticfilesystem:DescribeTags",
        "elasticfilesystem:CreateFileSystem",
        "elasticfilesystem:DescribeLifecycleConfiguration",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeMountTargetSecurityGroups",
        "elasticfilesystem:CreateTags",
        "elasticfilesystem:DeleteTags",
        "elasticfilesystem:UpdateFileSystem"
        ],
      "Resource": "*"
    },
    {
      "Sid": "AllowCostExplorerService",
      "Effect": "Allow",
      "Action": "ce:*",
      "Resource": "*"
    }
  ]
}
EOF
}