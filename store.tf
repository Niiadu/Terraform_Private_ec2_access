resource "aws_ssm_parameter" "vpc_id" {
  name  = "/nii/eu-north-1/vpc/myvpc/id"
  type  = "String"
  value = aws_vpc.myvpc.id
}

resource "aws_ssm_parameter" "private-subnets_ids" {
  name  = "/nii/eu-north-1/pri-subnets/id"
  type  = "String"
  value = aws_subnet.private-sn1.id
}

resource "aws_ssm_parameter" "public_subnets_ids" {
  name  = "/nii/eu-north-1/pub-subnets/id"
  type  = "String"
  value = aws_subnet.public_sn1.id
}