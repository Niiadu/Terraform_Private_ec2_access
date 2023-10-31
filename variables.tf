variable "vpc-cidr" {
  description = "cidr for vpc"
  default     = "10.0.0.0/16"
}

variable "vpc-name" {
  default = "Nii_Vpc"
}

variable "private-sn1-cidr" {
  default = "10.0.1.0/24"
}

variable "private-sn1-name" {
  default = "private-sn1"
}

variable "public-sn1-cidr" {
  default = "10.0.2.0/24"
}

variable "public-sn1-name" {
  default = "public-sn1"
}

variable "nat_gateway_name" {
  default = "my_nat_gateway"
}

variable "ami" {
  default = "ami-0703b5d7f7da98d1e"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "tags" {
  default = "my_instance"
}