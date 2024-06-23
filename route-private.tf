resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.vpc-01.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "Private-route-Table"
  }
}

# Route the private subnet to the nat gateway 

resource "aws_route_table_association" "nat_route_1" {
  subnet_id      = aws_subnet.pri-sn-1.id
  route_table_id = aws_route_table.private-route.id
}

resource "aws_route_table_association" "nat_route_2" {
  subnet_id      = aws_subnet.pri-sn-2.id
  route_table_id = aws_route_table.private-route.id
}

# Route the private database to the Nat Gateway
