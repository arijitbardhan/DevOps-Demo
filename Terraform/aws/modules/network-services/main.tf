# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.16"
#     }
#   }

#   required_version = ">= 1.2.0"
# }

# provider "aws" {
#   region  = var.region
#   access_key = var.access_key
#   secret_key = var.secret_key
# }

# Generating an available AZ from region
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "app_server_vpc" {
  cidr_block = var.vpc_cidr_block
  
  tags = {
    Name = "${var.instance_name}_VPC"
  }
}

resource "aws_subnet" "app_server_subnet" {
  vpc_id                  = aws_vpc.app_server_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 15)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = "${var.instance_name}_Subnet"
  }
}

resource "aws_network_interface" "app_server_nic" {
  subnet_id   = aws_subnet.app_server_subnet.id
  private_ips = [ cidrhost(aws_subnet.app_server_subnet.cidr_block, 10) ]
  
  tags = {
    Name = "${var.instance_name}_NetworkInterfaceCard"
  }
}

resource "aws_security_group" "vpc_security_group" {
  name        = "Allow_Ingress_Ports"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.app_server_vpc.id

  tags = {
    Name = "Allow_Ingress_Ports"
  }

  dynamic "ingress" {
    for_each = var.security_group_ingress_ports
    content {
      protocol    = "tcp"
      from_port   = ingress.value[0]
      to_port     = ingress.value[1]
      cidr_blocks = ingress.value[2]
    }
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.vpc_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.vpc_security_group.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_network_interface_sg_attachment" "sg_attachment_ec2" {
  security_group_id     = aws_security_group.vpc_security_group.id
  network_interface_id  = aws_network_interface.app_server_nic.id
}

output "nic_id" {
  value = aws_network_interface.app_server_nic.id  
}