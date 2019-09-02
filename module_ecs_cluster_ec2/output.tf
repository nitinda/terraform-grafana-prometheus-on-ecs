output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.demo_ecs_cluster_ec2.name}"
}

output "ecs_autoscalling_group_name" {
  value = "${aws_autoscaling_group.demo_ecs_autoscaling_group.name}"
}