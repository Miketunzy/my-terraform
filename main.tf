provider "aws" {
    region = "ca-central-1"
}

resource "aws_instance" "terra-server" {
    ami                      = "ami-03520d0f674d64df7"
    instance_type            = "t2.micro"
    vpc_security_group_ids   = [aws_security_group.instance.id]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    user_data_replace_on_change = true

      tags = {
        Name = "terra"
    }
}

resource "aws_security_group" "instance" {
  name        = "instance"
  description = "Allow web inbound traffic"

  ingress {
    description      = "web_traffic"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "new_group"
  }
}

output "public_ip" {
    value = "aws_instance.terra-server.public_ip"
    description = "This will output the public ip of the new instance"
}
