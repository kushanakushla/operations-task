resource "aws_ecr_repository" "repo" {
  name                 = format("%s-%s", var.name, var.tags["Environment"])
  image_tag_mutability = var.image_tag_mutability
  force_delete = true
  tags                 = var.tags

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}