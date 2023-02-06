resource "aws_iam_role" "role" {
  name               = var.role_name
  path               = var.role_path
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document.json
  description        = var.description
  lifecycle {
    ignore_changes = [
      assume_role_policy
    ]
  }
  tags = var.tags
}

resource "aws_iam_policy" "policy" {
  count  = length(var.policy_documents)
  name   = format("%s-policy%s", var.role_name, count.index)
  policy = var.policy_documents[count.index]
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "role_managed_policy_attachment" {
  count      = length(var.managed_policies)
  role       = aws_iam_role.role.name
  policy_arn = var.managed_policies[count.index]
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_custom" {
  count      = length(var.policy_documents)
  policy_arn = aws_iam_policy.policy[count.index].arn
  role       = aws_iam_role.role.name
}
