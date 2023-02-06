resource "aws_flow_log" "vpc" {
  count           = var.vpc_flow_iam_set == false ? 1 : 1
  iam_role_arn    = var.vpc_flow_iam_set == false ? data.aws_iam_role.vpc_flow_role[count.index].arn : aws_iam_role.vpc_flow_role[count.index].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id
  tags            = merge({ Name = "${var.vpc_name}" }, var.tags)
}

resource "aws_cloudwatch_log_group" "vpc_flow" {
  name              = "${var.vpc_name}-vpc-flowlogs"
  retention_in_days = 30
  tags              = merge({ Name = "${var.vpc_name}" }, var.tags)
}
