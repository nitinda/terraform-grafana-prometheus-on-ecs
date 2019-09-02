output "vpc_id" {
  value = "${aws_vpc.demo_vpc.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.demo_vpc.cidr_block}"
}

output "web_subnet_ids" {
  value = "${aws_subnet.demo_subnet_private.*.id}"
}

output "web_subnet_cidr_blocks" {
  value = "${aws_subnet.demo_subnet_private.*.cidr_block}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.demo_subnet_public.*.id}"
}

output "db_subnet_ids" {
  value = "${aws_subnet.demo_subnet_db.*.id}"
}

output "public_subnet_cidr_blocks" {
  value = "${aws_subnet.demo_subnet_public.*.cidr_block}"
}

output "nat_gateway_ids" {
  value = "${aws_nat_gateway.demo_nat_gateway.*.id}"
}