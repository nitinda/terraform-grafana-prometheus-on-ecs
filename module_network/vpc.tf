data "aws_availability_zones" "available" {}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-vpc",
  ))}"
}

resource "aws_subnet" "demo_subnet_public" {
  count             = 2
  vpc_id            = "${aws_vpc.demo_vpc.id}"
  cidr_block        = "172.16.${count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-subnet-public-${count.index}",
  ))}"
}

resource "aws_subnet" "demo_subnet_private" {
  count             = 2
  vpc_id            = "${aws_vpc.demo_vpc.id}"
  cidr_block        = "172.16.${count.index+2}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-subnet-private-${count.index}",
  ))}"
}

resource "aws_subnet" "demo_subnet_db" {
  count             = 2
  vpc_id            = "${aws_vpc.demo_vpc.id}"
  cidr_block        = "172.16.${count.index+4}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-subnet-db-${count.index}",
  ))}"
}

resource "aws_internet_gateway" "demo_internet_gateway" {
  vpc_id = "${aws_vpc.demo_vpc.id}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-internet-gateway",
  ))}"
}

resource "aws_eip" "demo_epi" {
  count = 2
  vpc   = true
  
  tags = "${merge(var.common_tags, map(
    "Name", "terraform_demo-ecs-epi",
  ))}"
}

resource "aws_nat_gateway" "demo_nat_gateway" {
  count = 2
  allocation_id = "${aws_eip.demo_epi.*.id[count.index]}"
  subnet_id     = "${aws_subnet.demo_subnet_public.*.id[count.index]}"
  depends_on    = ["aws_internet_gateway.demo_internet_gateway"]

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-nat-gateway-${count.index}",
  ))}"
}