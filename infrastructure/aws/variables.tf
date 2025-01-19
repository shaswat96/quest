variable "aws_account_id" {
  description = "AWS Region deployed to"
  type        = string
  default     = "299770056477"
}

variable "region" {
  description = "AWS Region deployed to"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr1" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.128.0/18"
}

variable "public_subnet_cidr2" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.192.0/18"
}

variable "private_subnet_cidr1" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.0.0/17"
}

variable "public_ip_allowed" {
}

variable "secret_word" {
}

variable "app_docker_image" {
}

variable "port" {
  default = 3000
}

locals {
  common_tags = {
    "shaswatpoc" = "true"
  }
  service_name = "shaswatpoc"
  app_name     = "shaswatpoc-nodeapp"
}