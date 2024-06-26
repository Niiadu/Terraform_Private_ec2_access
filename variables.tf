variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public-subnet-01-cidr" {
  default = "10.0.1.0/24"
}

variable "public-subnet-02-cidr" {
  default = "10.0.2.0/24"
}

variable "private-subnet-01-cidr" {
  default = "10.0.3.0/24"
}

variable "private-subnet-02-cidr" {
  default = "10.0.4.0/24"
}

variable "availability-1" {
  default = "eu-north-1a"
}

variable "availability-2" {
  default = "eu-north-1b"
}

