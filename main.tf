resource "aws_key_pair" "terra_key"{
    key_name = "terraform_key"
    public_key = file("terraform_key.pub")
}

resource "aws_default_vpc" "vpc_ec2" {
  
}

resource "aws_security_group" "ec2_sg" {
    name = "ec2_sg"
    description = "this is the security group for aws ec2"
    vpc_id = aws_default_vpc.vpc_ec2.id
    
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_instance" "ec2_instance" {
    instance_type = "t2.micro"
    ami = "ami-0360c520857e3138f" 
    key_name = aws_key_pair.terra_key.key_name
    security_groups = [ aws_security_group.ec2_sg.name ]


    root_block_device {
      volume_size = 8
      volume_type = "gp3"
    }
    
    tags = {
      Name="Terra_ec2"
    }
}