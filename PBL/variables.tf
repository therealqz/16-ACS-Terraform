# GET THE LIST OF AVAILABILITY ZONES
data "aws_availability_zones" "available" {
  state = "available"
}
variable "region" {
  default = "us-east-2"
}

# Declare variables for the CIDR and all the other arguments 
variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

#  VARIABLE FOR PREFERRED # OF PUBLIC SUBNETS
variable "preferred_number_of_public_subnets" {
  default = 2
}