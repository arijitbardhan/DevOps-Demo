terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-south-1"
}

# for getting AMI id
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_server_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.app_server_subnet.id
    
  tags = {
    Name = "AppServer_Instance"
    
  }
  # defining storage
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 8
    volume_type           = gp2
  }

  network_interface {
    delete_om_termination = true
  }
}

resource "aws_vpc" "app_server_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "AppServer_VPC"
  }
}

resource "aws_subnet" "app_server_subnet" {
  vpc_id            = aws_vpc.app_server_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "AppServer_Subnet"
  }
}

resource "aws_network_interface" "app_server_nic" {
  subnet_id   = aws_subnet.app_server_subnet.id
  private_ips = ["10.10.0.100"]
  
  tags = {
    Name = "AppServer_NetworkInterfaceCard"
  }
}

output "AppServer_Instance_ARN" {
  instance_arn = aws_instance.app_server_instance.arn
  
}
