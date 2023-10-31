## Description
This is a project for provisioning an EC2 instance in a private VPC, which would be accessed through a NAT GATEWAY wiithin the public subnet.
In this demo, we are provisioning a Nginx instance on AWS EC2 using user data. We also setup a security group with the necessary rules.

## Usage
- Execute the command `terraform init` to setup the project workspace.
- Excute the command `terrraform plan` to get a preview of the resources, terraform is going to implement incase you go ahead with it. This will give you detailed informations on resources to be provisioned
- Execute the command `terraform apply` to provision the infrastructure. This will create a VPC with Private and Public Subnets, a NAT Gateway and 1 EC2 instances.
- Execute the command `terraform destroy` to destroy the infrastructure.


## Note
The resources created in this example may incur cost. So please take care to destroy the infrastructure if you don't need it.
