data "template_file" "instance_store" {
  template = "${file("scripts/setup.sh")}"
}

resource "aws_instance" "ec2_instance" {
  ami                    = var.instance_ami
  subnet_id              = var.subnets[0]
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.unstructured-ecs-instance-profile.name
  vpc_security_group_ids = [aws_security_group.service_sg.id]
  ebs_optimized          = "false"
  source_dest_check      = "false"
  user_data              = data.template_file.instance_store.rendered
  key_name               = var.ec2_key_name

  ephemeral_block_device {
    device_name = "/dev/xvdf"
    virtual_name = "ephemeral0"
  }

  tags = {
    Name                   = "unstructured-ec2"
  }
}
