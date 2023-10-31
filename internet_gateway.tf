resource "aws_internet_gateway" "Internet_Gateway" {
  depends_on = [
    aws_vpc.myvpc,
    aws_subnet.public_sn1,
  ]

  # VPC in which it has to be created!
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "IG-Public-VPC"
  }
}


resource "aws_route_table" "Public-Subnet-RT" {
  depends_on = [
    aws_vpc.myvpc,
    aws_internet_gateway.Internet_Gateway
  ]

  # VPC ID
  vpc_id = aws_vpc.myvpc.id

  # NAT Rule
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_Gateway.id
  }

  tags = {
    Name = "Route Table for Internet Gateway"
  }
}


resource "aws_route_table_association" "RT-IG-Association" {

  depends_on = [
    aws_vpc.myvpc,
    aws_subnet.public_sn1,
    aws_subnet.private-sn1,
    aws_route_table.Public-Subnet-RT
  ]

  # Public Subnet ID
  subnet_id = aws_subnet.public_sn1.id

  #  Route Table ID
  route_table_id = aws_route_table.Public-Subnet-RT.id
}


