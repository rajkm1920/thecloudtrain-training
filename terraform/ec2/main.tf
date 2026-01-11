# ===============================
# Provider Block
# ===============================
provider "aws" {
  region = "us-east-1"   # Change to your preferred region
}

# ===============================
# Security Group
# ===============================
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ===============================
# EC2 Instance
# ===============================
resource "aws_instance" "my_ec2" {
  ami           = "ami-0c7217cdde317cfec" # Amazon Linux 2 in us-east-1 (update if region changes)
  instance_type = "t3.micro"

  key_name      = "ansible-key" # Replace with your key pair name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "HandsOn-EC2"
  }
}

# ===============================
# Outputs
# ===============================
output "ec2_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.my_ec2.public_dns
}
