resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "private-sn1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.private-sn1-cidr
  map_public_ip_on_launch = false # private subnet

  tags = {
    Name = var.private-sn1-name
  }
}


resource "aws_subnet" "public_sn1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public-sn1-cidr
  map_public_ip_on_launch = true # public subnet

  tags = {
    Name = var.public-sn1-name
  }
}


