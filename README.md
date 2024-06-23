# Building a Robust AWS Infrastructure with Terraform
In this blog post, we'll explore how to create a comprehensive AWS infrastructure using Terraform. This guide will cover setting up a VPC, subnets, security groups, an application load balancer (ALB), an auto-scaling group, and other essential components. By the end of this tutorial, you'll have a scalable, secure infrastructure ready for deployment.

## Prerequisites
Before we begin, ensure you have the following:

* An AWS account
* Terraform installed on your local machine
* Basic knowledge of Terraform and AWS services
## Project Overview
Our infrastructure will include the following components:

* VPC with public and private subnets
* Internet Gateway and NAT Gateway for internet access
* Security Groups for controlling access
* Application Load Balancer (ALB)
* Auto-Scaling Group with Launch Template
* Route Tables for routing traffic
## Step-by-Step Configuration
### Step 1: Setting Up the VPC
We'll start by defining a Virtual Private Cloud (VPC):

```
resource "aws_vpc" "vpc-01" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Nii-VPC"
  }
}
```
### Step 2: Creating Subnets
We'll create two public and two private subnets across different availability zones:
```
resource "aws_subnet" "pub-sn-1" {
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = var.public_subnet_01_cidr
  availability_zone       = var.availability_1
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-1"
  }
}

resource "aws_subnet" "pub-sn-2" {
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = var.public_subnet_02_cidr
  availability_zone       = var.availability_2
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-2"
  }
}

resource "aws_subnet" "pri-sn-1" {
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = var.private_subnet_01_cidr
  availability_zone       = var.availability_1
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-1 | App Tier"
  }
}

resource "aws_subnet" "pri-sn-2" {
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = var.private_subnet_02_cidr
  availability_zone       = var.availability_2
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-2 | App tier"
  }
}
```
### Step 3: Internet Gateway and NAT Gateway
Next, we'll set up an Internet Gateway and a NAT Gateway for internet access:

```
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-01.id

  tags = {
    Name = "My-IGW"
  }
}

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
```

### Step 4: Route Tables and Associations
We'll create route tables to manage traffic routing:

```
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

resource "aws_route_table_association" "nat_route_1" {
  subnet_id      = aws_subnet.pri-sn-1.id
  route_table_id = aws_route_table.private-route.id
}

resource "aws_route_table_association" "nat_route_2" {
  subnet_id      = aws_subnet.pri-sn-2.id
  route_table_id = aws_route_table.private-route.id
}

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
```

### Step 5: Security Groups
We'll define security groups to control access to our resources:

```
resource "aws_security_group" "alb_security_group" {
  name        = "ALB Security Group"
  description = "Allow HTTP and HTTPS ports"
  vpc_id      = aws_vpc.vpc-01.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Alb Security Group"
  }
}

resource "aws_security_group" "Webserver_security_group" {
  name        = "Web Server Security Group"
  description = "Enable HTTP/HTTPS ports"
  vpc_id      = aws_vpc.vpc-01.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Webserver Security Group"
  }
}
```

### Step 6: Application Load Balancer
We'll set up an Application Load Balancer to distribute traffic:

```
resource "aws_lb" "application-load-balancer" {
  name                       = "web-external-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_security_group.id]
  subnets                    = [aws_subnet.pub-sn-1.id, aws_subnet.pub-sn-2.id]
  enable_deletion_protection = false

  tags = {
    Name = "App Load balancer"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "app-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-01.id
}

resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.application-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
```

### Step 7: Auto Scaling Group and Launch Template
We'll configure an Auto Scaling Group with a Launch Template for scalability:

```
resource "aws_launch_template" "auto-scaling-group" {
  name_prefix   = "auto-scaling-group"
  image_id      = var.ami
  instance_type = "t3.micro"
  key_name      = "linux_machine"
  user_data     = filebase64("nginx.sh")

  network_interfaces {
    security_groups = [aws_security_group.Webserver_security_group.id]
  }
}

resource "aws_autoscaling_group" "asg-1" {
  vpc_zone_identifier = [aws_subnet.pri-sn-1.id, aws_subnet.pri-sn-2.id]
  desired_capacity    = 2
  min_size            = 1
  max_size            = 5

  launch_template {
    id      = aws_launch_template.auto-scaling-group.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "tg-group" {
  autoscaling_group_name = aws_autoscaling_group.asg-1.id
  lb_target_group_arn    = aws_lb_target_group.alb_target_group.arn
}
```

## Final Thoughts
With this setup, you now have a robust AWS infrastructure capable of handling web traffic, auto-scaling based on demand, and maintaining security best practices. Terraform's declarative approach allows you to manage your infrastructure as code, making it easier to maintain and version control.

Feel free to customize the configurations to fit your specific requirements. Happy coding!

This concludes our step-by-step guide to building an AWS infrastructure using Terraform. If you have any questions or feedback, please leave a comment below.

## Usage
- Execute the command `terraform init` to setup the project workspace.
- Excute the command `terrraform plan` to get a preview of the resources, terraform is going to implement incase you go ahead with it. This will give you detailed informations on resources to be provisioned
- Execute the command `terraform apply` to provision the infrastructure. This will create a VPC with Private and Public Subnets, a NAT Gateway and 1 EC2 instances.
- Execute the command `terraform destroy` to destroy the infrastructure.


## Note
The resources created in this example may incur cost. So please take care to destroy the infrastructure if you don't need it.
