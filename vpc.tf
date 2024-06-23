resource "aws_vpc" "vpc-01" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Nii-VPC"
  }
}

resource "aws_subnet" "pub-sn-1" {
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = var.public-subnet-01-cidr
  availability_zone       = var.availability-1
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-1"
  }
}

resource "aws_subnet" "pub-sn-2" {
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = var.public-subnet-02-cidr
  availability_zone       = var.availability-2
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-2"
  }
}

resource "aws_subnet" "pri-sn-1" {
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = var.private-subnet-01-cidr
  availability_zone       = var.availability-1
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-1 | App Tier"
  }
}

resource "aws_subnet" "pri-sn-2" {
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = var.private-subnet-02-cidr
  availability_zone       = var.availability-2
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-2 | App tier"
  }
}
