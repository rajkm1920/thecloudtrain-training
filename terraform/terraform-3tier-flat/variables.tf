variable "project" {
  type    = string
  default = "ec2Tech-terraform-workshop"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "app_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "db_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.30.0/24", "10.0.31.0/24"]
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "db_username" {
  type    = string
  default = "adminuser"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "ChangeMe12345!"
}

variable "key_name" {
  type    = string
  default = null
}
