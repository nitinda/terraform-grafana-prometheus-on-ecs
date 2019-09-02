output "kms_key_arn" {
  value = "${aws_kms_key.demo_kms_key.arn}"
}

output "kms_key_alias_arn" {
  value = "${aws_kms_alias.demo_kms_alias.arn}"
}