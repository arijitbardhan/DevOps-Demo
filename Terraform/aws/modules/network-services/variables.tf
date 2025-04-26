variable "region" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "map_public_ip_on_launch" {
  type = bool
}

variable "security_group_ingress_ports" {
  type = map(any)
  default = { "ingress1" = [80, 80, [ "0.0.0.0/0" ]],
              "ingress2" = [22, 22,[ "0.0.0.0/0" ]],
              "ingress3" = [443, 443, [ "0.0.0.0/0" ]]
            }  
}
