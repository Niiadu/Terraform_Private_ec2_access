resource "aws_eip" "eip-nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.pub-sn-1.id

  tags = {
    Name = "Nat GW"
  }
}