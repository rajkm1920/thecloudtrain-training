module "ec2machine" {
    source = "./mymodule"
    instance_type = "t2.nano"
    Name = "devops-test-env"
    terraform = "true"
}


module "ec2machine2" {
    source = "./mymodule"
    instance_type = "t2.nano"
    Name = "devops-Stage-env"
    terraform = "true"
}