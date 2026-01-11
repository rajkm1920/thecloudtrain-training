output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "app_subnet_ids" {
  value = [for s in aws_subnet.app : s.id]
}

output "db_subnet_ids" {
  value = [for s in aws_subnet.db : s.id]
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}
