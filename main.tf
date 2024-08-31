# create an security group

resource "aws_security_group" "sayanksg" {
  name        = "sayanksg"
  description = "Enable SSH access on Port 22"

  dynamic "ingress" {
    for_each = [22, 80,443]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# creating and send key pair
resource "aws_key_pair" "sayank" {
  key_name   = "sayank"
  public_key = file("${path.module}/sayank.pub")
}


# Create EC2 Instance
resource "aws_instance" "mysql" {
  ami                         = "ami-0d50e5e845c552faf"
  instance_type               = "t2.micro"
  key_name                    = "sayank"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sayanksg.id]
  availability_zone           = "us-west-1a"
  tags = {
    Name = "mysql"
  }

  # Command run in ec2
  user_data = <<-EOF
          #!bin/bash
          sudo apt update
          sudo apt install mysql-server -y
          sudo systemctl status mysql
          sudo mysql
          sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'sayank1605';"
          exit
  EOF

  # Connection Login to Ec2
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./sayank")
    host        = self.public_ip
  }
}

