data "aws_iam_role" "vpc_flow_role" {
  count = var.vpc_flow_iam_set == false ? 1 : 0
  name  = "VPCFlowLogsRole"
}

resource "aws_iam_role" "vpc_flow_role" {
  count = var.vpc_flow_iam_set == true ? 1 : 0
  name  = "VPCFlowLogsRole"
  tags  = var.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_policy" {
  count  = var.vpc_flow_iam_set == true ? 1 : 0
  name   = "VPCFlowLogsPolicy"
  role   = aws_iam_role.vpc_flow_role[count.index].id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
