# Route table from the public subnet to the internet gateway
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

#Route table association, to associate the public subnet to the public route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub-sn-1.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pub-sn-2.id
  route_table_id = aws_route_table.public-route.id
}