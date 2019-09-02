resource "aws_iam_role" "demo_iam_role_ecs_service_role" {
  name               = "terraform-demo-iam-role-ecs-service"
  path               = "/service-role/"
  assume_role_policy = "${data.aws_iam_policy_document.demo_iam_policy_document_ecs_assume_role.json}"
  description        = "IAM Role for ECS Service"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-iam-role-ecs-service",
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "demo_iam_role_policy_attachment_ecs_service_AmazonEC2ContainerServiceRole" {
  role       = "${aws_iam_role.demo_iam_role_ecs_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy" "demo_iam_role_policy_ecs_service_role_inline_policy" {
  name = "terraform-demo-iam-role-inline-policy-ecs-service"
  role = "${aws_iam_role.demo_iam_role_ecs_service_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "ec2:*Volume*",
              "ec2:*Snapshot*",
              "ec2:*networkinterface*",
              "ec2:DeleteTags",
              "ec2:DescribeTags",
              "ec2:CreateTags"
            ],
            "Resource": "*"
        },
        {
          "Sid": "VisualEditor1",
          "Effect": "Allow",
          "Action": "iam:PassRole",
          "Resource": "*"
        }
    ]
}
EOF
}

##############################


resource "aws_iam_role" "demo_iam_role_ecs_ec2_role" {
  name               = "terraform-demo-iam-role-ecs-ec2-role"
  path               = "/service-role/"
  assume_role_policy = "${data.aws_iam_policy_document.demo_iam_policy_document_ec2_assume_role.json}"
  description        = "IAM Role for EC2 Instance Profile Role"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-iam-role-ecs-ec2-role",
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "demo_ecs_instance_role_attachment_AmazonEC2ContainerServiceforEC2Role" {
  role       = "${aws_iam_role.demo_iam_role_ecs_ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "demo_ecs_instance_role_attachment_AmazonEC2RoleforSSM" {
  role       = "${aws_iam_role.demo_iam_role_ecs_ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "demo_ecs_instance_role_attachment_Cloutwatch" {
  role       = "${aws_iam_role.demo_iam_role_ecs_ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrailFullAccess"
}

resource "aws_iam_instance_profile" "demo_instance_profile_ecs_ec2" {
  name = "terraform-demo-iam-instance-profile-ecs-ec2"
  path = "/service-role/"
  role = "${aws_iam_role.demo_iam_role_ecs_ec2_role.id}"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "aws_iam_role_policy" "demo_iam_role_inline_policy_ecs_ec2" {
  name = "terraform-demo-role-inline-policy-ecs-ec2"
  role = "${aws_iam_role.demo_iam_role_ecs_ec2_role.id}"

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
      "Effect": "Allow",
      "Action": "ec2-instance-connect:SendSSHPublicKey",
      "Resource": "arn:aws:ec2:${data.aws_region.demo_region_current.name}:${data.aws_caller_identity.demo_caller_identity_current.account_id}:instance/*",
      "Condition": {
        "StringEquals": {
          "ec2:osuser": "ec2-user"
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
      "Sid": "AllowIAMPassRole",
      "Effect": "Allow",
      "Action": "iam:PassRole",
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