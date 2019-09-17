resource "aws_launch_template" "demo_launch_template_ecs_worker_node" {
  name_prefix   = "terraform-demo-launch-template-ecs-worker-node-"
  description   = "This is launch template for ecs worker nodes"
  image_id      = "${data.aws_ami.demo_ami_ecs_node.id}"
  ebs_optimized = true
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_size           = 50
      volume_type           = "gp2"
    }
  }
  iam_instance_profile = {
    name               = "${var.ecs_instance_profile_name}"
  }  
  vpc_security_group_ids = ["${aws_security_group.demo_ecs_security_group_ec2.id}"]
  monitoring {
    enabled = false
  }
  tag_specifications {
    resource_type = "instance"
    tags          = "${merge(var.common_tags, map(
      "Name", "terraform-demo-lt-ecs-worker-node-ec2",
    ))}"
  }
  tag_specifications {
    resource_type = "volume"
    tags          = "${merge(var.common_tags, map(
      "Name", "terraform-demo-lt-ecs-worker-node-ec2",
    ))}"
  }
  user_data = "${base64encode("${data.template_file.demo_template_data.rendered}")}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-launch-template-ecs-worker-node",
  ))}"
}

data "template_file" "demo_template_data" {
  template = "${file("${path.module}/../module_ecs_cluster_ec2/files/userdata.sh")}"
  vars {
    ECS_CLUSTER_NAME = "${var.ecs_cluster_name}"
    EBS_REGION       = "${data.aws_region.demo_region_current.name}"
    EFS_REGION       = "${data.aws_region.demo_region_current.name}"
  }
}

data "aws_ami" "demo_ami_ecs_node" {
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*x86_64-ebs"]
  }
  most_recent = true
  owners      = ["591542846629"] # Amazon ecs AMI Account ID
}
