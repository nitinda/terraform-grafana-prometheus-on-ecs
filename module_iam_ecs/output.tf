output "ecs_instance_profile_name" {
  value = "${aws_iam_instance_profile.demo_instance_profile_ecs_ec2.name}"
}

output "ecs_ec2_iam_role_arn" {
  value = "${aws_iam_role.demo_iam_role_ecs_ec2_role.arn}"
}

output "ecs_service_role_arn" {
  value = "${aws_iam_role.demo_iam_role_ecs_service_role.arn}"
}

output "ecs_service_role_name" {
  value = "${aws_iam_role.demo_iam_role_ecs_service_role.name}"
}

output "ecs_task_execution_role_arn" {
  value = "${aws_iam_role.demo_iam_role_ecs_task_execution_role.arn}"
}

output "ecs_task_role_arn" {
  value = "${aws_iam_role.demo_iam_role_ecs_task_role.arn}"
}
