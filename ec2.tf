resource "aws_instance" "nii" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.private-sn1.id
  user_data       = file("userdata.tpl")
  security_groups = [aws_security_group.sg_for_ec2.id]

  tags = {
    Name = var.tags
  }
}