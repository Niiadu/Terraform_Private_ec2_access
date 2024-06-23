resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-route-Table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub-sn-1.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pub-sn-2.id
  route_table_id = aws_route_table.public-route.id
}