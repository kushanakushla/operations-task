locals {
  tags                 = merge(var.global_tags, var.tags)
  aws_ecr_url          = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  container_definition = <<DEFINITION
  [
      {   "name": "${var.container_name}",
          "essential": true,
          "image": "${module.repo.repo.repository_url}:${var.image_tag}",
          "logConfiguration": {
              "logDriver": "awslogs",
              "options": {
                  "awslogs-group": "${module.app_log_group.log_group_name}",
                  "awslogs-region": "${var.region}",
                  "awslogs-stream-prefix": "${var.container_name}"
              }
            },
          "portMappings": [
              {
                  "containerPort": ${var.container_port},
                  "hostPort": ${var.container_port},
                  "protocol": "tcp"
              }
          ],
          "secrets": [
            {
              "name": "DB_HOST",
              "valueFrom": "${module.rds_postgres_endpoint.secret.arn}"
            },
            {
              "name": "DB_PASSWORD",
              "valueFrom": "${module.rds_postgres_cred.secret.arn}"
            }
          ],
          "environment": [
            {
              "name": "DB_NAME",
              "value": "${var.db_name}"
            },
            {
              "name": "DB_USERNAME",
              "value": "${var.db_username}"
            }
          ]
      }
  ]
  DEFINITION
}
