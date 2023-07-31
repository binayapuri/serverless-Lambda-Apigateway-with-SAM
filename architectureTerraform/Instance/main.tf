  locals{
    tags = {
    "owner"   = "binay"
    "Name"    = "bp-instance"
  }
  }

resource "aws_instance" "bp" {
  ami           = "${var.instance_ami}"
  instance_type = var.instance_type
  subnet_id                   = var.PUBLIC_SUBNET_ID
  key_name                    = var.key_name
  associate_public_ip_address = "true"
  security_groups   = [var.INSTANCE_SG_ID]
  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
  }
  volume_tags = local.tags
  tags = {
    "owner"   = "binay"
    "Name"    = "bp-instance"
    "project" = "major"
  }

}