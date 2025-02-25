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
  region  = var.region
  access_key = var.access_key
  secret_key = var.secret_key
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

resource "aws_key_pair" "app_server_instance_key" {
  #key_name = concat(var.instance_name, "_key_pair")
  key_name   = "${var.instance_name}_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDjjRLbp1E33tjqSgvJdPy0d0O0skPuUuUHg98u4EDoYR5J1B5MLjiTao1AAtdngilUxHv7bXHbVSJCEbH9/6+Xs3gug8TThhuNfqcDt4r/SxKVshiaDd/iK1pFFo0YxXc47n0111zuanhKoDt/pUCrJ1h84lfoBEp7cUBnlrYa5vi1qApMOffHmlOwdMihJhIVXq+Y0br7rRMirAgfZtTn8Qeg3xnxRtrrFmKIdvvegnY86pTHCAnqiYWWytbKEazXopAJcR+kT6MHLEsco/w7ImP/3pu8yIqQYjjvD8ynyw17L663AIryuEPG4a623xLcKsR4GdTZl5mAwJpmnQBrIYfOhziW6EXNXCVUUbFfVPtMMtJa+xHqAmBYYKe/t71Afa0iB35liP+lYGJ+IsM980JbGAkQLQWPEr/iv67hhhMv8FlAsnVJciGwenWYDGZ0wR8vUrHrmAOdsnynFhUP9etuOn+s6iPAL40VzUrqRlUdX8XjmQg2Qr2a5zPbNV/x/+I7NIZk3RLQVFlHNSdOOsl6tNYYjJE+n4s0oejlBG+sxS53IJrHgCfmKIPkl9M0pS/BjTix3fg8OeFzmXKIuAO53dObvbD7WO2DH/cASpHLlyxfiH/sbiYmqqonKhEzJL3wb54FrwpETQ3P6utFXedcWLh0/lpN/HSF7d0E9Q== ubuntu@ip-172-31-46-136"
}

resource "aws_instance" "app_server_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
    
  tags = {
    Name = var.instance_name
  }

  key_name = aws_key_pair.app_server_instance_key.key_name

  # defining storage
  root_block_device {
    delete_on_termination = var.root_block_device_delete_on_termination
    encrypted             = var.root_block_device_encrypted
    volume_size           = var.root_block_device_volume_size
    volume_type           = var.root_block_device_volume_type
  }

  network_interface {
    #delete_on_termination = true
    device_index          = var.ec2_network_interface_device_index
    network_interface_id  = aws_network_interface.app_server_nic.id
  }
}

resource "aws_ebs_volume" "instance_storage" {
  availability_zone = var.instance_storage_availability_zone 
  size              = var.instance_storage_size            # Specify the size of the volume in GiB

  tags = {
    Name = "${var.instance_name}_EBS"
  }
}

resource "aws_volume_attachment" "ebs_attachment_to_ec2" {
  device_name = var.ebs_attachment_to_ec2_device_name
  volume_id   = aws_ebs_volume.instance_storage.id
  instance_id = aws_instance.app_server_instance.id
}

resource "aws_vpc" "app_server_vpc" {
  cidr_block = var.app_server_vpc_cidr_block
  
  tags = {
    Name = "${var.instance_name}_VPC"
  }
}

resource "aws_subnet" "app_server_subnet" {
  vpc_id            = aws_vpc.app_server_vpc.id
  cidr_block        = var.app_server_subnet_cidr_block
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = var.app_server_subnet_public_ip
  tags = {
    Name = "${var.instance_name}_Subnet"
  }
}

resource "aws_network_interface" "app_server_nic" {
  subnet_id   = aws_subnet.app_server_subnet.id
  private_ips = ["10.0.0.100"]
  
  tags = {
    Name = "${var.instance_name}_NetworkInterfaceCard"
  }
}

resource "aws_security_group" "vpc_security_group" {
  name        = "Allow_HTTP_HTTPS_SSH"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.app_server_vpc.id

  tags = {
    Name = "Allow_HTTP_HTTPS_SSH"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.vpc_security_group.id
  cidr_blocks       = [ "0.0.0.0/0" ]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.vpc_security_group.id
  cidr_blocks       = [ aws_vpc.app_server_vpc.cidr_block ]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
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

output "AppServer_Instance_ARN" {
  value = aws_instance.app_server_instance.arn
}
