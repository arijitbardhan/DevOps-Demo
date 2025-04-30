# Defining AWS provider config
provider "aws" {
  region  = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Key Pair resource for accessing EC2 instance
resource "aws_key_pair" "app_server_instance_key" {
  key_name   = "${var.instance_name}_key"
  public_key = var.public_key    # Generating public key data through tls_private_key resource at root level
}

#EC2 configurations
resource "aws_instance" "app_server_instance" {
  ami           = var.ami
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
    device_index          = var.device_index
    network_interface_id  = var.network_interface_id
  }
}

output "ec2_instance_id" {
  value = aws_instance.app_server_instance.id
}