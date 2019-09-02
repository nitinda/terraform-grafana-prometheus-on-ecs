output "ssm_parameter_name" {
  value = "${aws_ssm_parameter.demo_ssm_parameter.name}"
}

output "ssm_parameter_value" {
  value = "${aws_ssm_parameter.demo_ssm_parameter.value}"
}