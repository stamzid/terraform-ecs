variable "region" {
  description = "AWS region name"
  type = string
  default = "us-east-1"
}

variable "app_image" {
  description = "ECR docker image for the service"
  type = string
}

variable "vpc_id" {
  description = "Id of the vpc where the service will be hosted"
  type = string
}


variable "subnets" {
  description = "Subnet ids of the vpc where the service will be hosted"
  type = list(string)
}

variable "vpc_cidr_blocks" {
  description = "CIDR block ingress"
  type = list(string)
}

variable "instance_ami" {
  description = "AWS AMI for the ec2 instance"
  type = string
  default = "ami-0e72545e0a1a5c759" # ECS Optmized AMI
}

variable "instance_type" {
  description = "AWS Instance type"
  type = string
  default = "r5dn.large"
}

variable "AWS_ACCESS" {
  type = string
}

variable "AWS_SECRET" {
  type = string
}

variable "ec2_key_name" {
  type = string
}
