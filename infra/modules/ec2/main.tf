resource "aws_instance" "ec2_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  tags          = var.tags
  key_name      = var.key_name
  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = var.root_volume_delete_on_termination
    tags                  = var.tags
  }
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_instance_profile

  lifecycle {
    ignore_changes = [
      tags, root_block_device
    ]
  }

}
