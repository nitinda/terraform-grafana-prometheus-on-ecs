provider "aws" {
    alias   = "aws_services"
    region  = "${var.region}"
}

# data "aws_acm_certificate" "demo-aws-acm-certificate" {
#   provider    = "aws.aws_services"
#   domain      = "*.tuiuki.io"
#   statuses    = ["ISSUED"]
#   types       = ["AMAZON_ISSUED"]
#   most_recent = true
# }

