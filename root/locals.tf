locals {
  profile_name = "profile"
  domain_name = "iamobaro.com"
}

data "aws_acm_certificate" "domain" {
  domain = "api.${local.domain_name}"
}
