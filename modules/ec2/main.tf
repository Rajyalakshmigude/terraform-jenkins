resource "aws_instance" "main" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name

    tags = {
        Name = var.ec2_tag
    }


  
}