variable "instances" {
  default = {
    "frontend"    = "t3.micro"
    "backend"     = "t3.medium"
    "db" = "t3.small"
  }
}

resource "aws_instance" "example" {
  for_each     = var.instances
  ami          = "ami-0533f2ba8a1995cf9"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}