resource "aws_ssm_parameter" "demo_ssm_parameter" {
  name        = "${var.ssm_parameter_name}"
  description = "The description of the parameter"
  type        = "SecureString"
  value       = "${var.ssm_parameter_value}"
  key_id      = "${var.kms_key_id}"
  tags        = "${var.common_tags}"
}