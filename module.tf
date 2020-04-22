data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

module "splunk" {
  source = "./splunk"
  account_id = data.aws_caller_identity.current.account_id
}

module "ubuntu" {
  source = "./ubuntu"
}
