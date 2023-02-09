### Terraform data configuration

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

data "aws_iam_policy_document" "policy_document_ecr_access" {
  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"

    ]
    effect = "Allow"
    resources = [
      "${module.repo.repo.repository_url}"
    ]

  }
}

data "aws_iam_policy_document" "policy_document_cwlogs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = [
      "${module.app_log_group.log_group_arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "policy_document_secret_manager_access" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    effect = "Allow"
    resources = [
      "${module.rds_postgres_endpoint.secret.arn}",
      "${module.rds_postgres_cred.secret.arn}"
    ]
  }
}

### Fetch latest amazon-linux ami ID
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

data "external" "check_image_exsists" {
  program = ["/bin/bash", "${path.module}/check_docker_image.sh", var.application_image_name, var.image_tag]
}
