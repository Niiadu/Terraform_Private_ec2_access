resource "aws_eip" "Nat-Gateway-EIP" {
  domain = "vpc"
  depends_on = [
    aws_route_table_association.RT-IG-Association
  ]

}

resource "aws_nat_gateway" "NAT_GATEWAY" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.Nat-Gateway-EIP.id

  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.public_sn1.id
  tags = {
    Name = "Nat-Gateway_Project"
  }
}


resource "aws_route_table" "sh_rt_private" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route" "public-internet-route" {
  route_table_id         = aws_route_table.sh_rt_private.id
  gateway_id             = aws_internet_gateway.Internet_Gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

# associate the route table with private subnet
resource "aws_route_table_association" "sh_rta3" {
  subnet_id      = aws_subnet.private-sn1.id
  route_table_id = aws_route_table.sh_rt_private.id
}