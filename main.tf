resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16" # Replace with your desired CIDR block
  tags = {
    Name = "Prod_VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.demo_vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "prod-RT"
  }
}
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.1.0/24" # Replace with your desired CIDR block
  availability_zone = "us-east-1a"
  tags = {
    Name = "prod_subnet"
  }
}

resource "aws_route_table_association" "route_table_asso" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "instance_sg" {
  name        = "webserver_sg"
  description = "Allow inbound SSH and HTTP traffic"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web-traffic"
  }
}

resource "aws_instance" "webserver" {
  ami               = "ami-053b0d53c279acc90" # Replace with your desired AMI
  instance_type     = "t2.micro"              # Replace with your desired instance type
  key_name          = "terrakey"              # Replace with your SSH key pair name
  availability_zone = "us-east-1a"

  tags = {
    Name = "WebServerInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt-get install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo Congratulations! on your first Webserver Installation > /var/www/html/index.html'
              EOF
}
output "public_ip" {
  value = aws_instance.webserver.public_ip
}
