data "aws_iam_policy_document" "assume_role_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = var.assume_role_identifiers
      type        = "Service"
    }
    principals {
      identifiers = var.assume_role_accounts
      type        = "AWS"
    }
  }
}