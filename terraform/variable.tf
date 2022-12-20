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

variable "execution_role_arn" {
  description = "The ARN for the ecs task execution role"
  type = string
}
