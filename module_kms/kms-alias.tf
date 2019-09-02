resource "aws_kms_alias" "demo_kms_alias" {
  name          = "${var.kmy_key_alias_name}"
  target_key_id = "${aws_kms_key.demo_kms_key.key_id}"
}