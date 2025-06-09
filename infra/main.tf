provider "aws" {
  region = "us-east-1"
}
 
resource "aws_vpc" "main_vpc" {
cidr_block = "10.0.0.0/16"
}
 
resource "aws_subnet" "main_subnet" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = "10.0.1.0/24"
}
 
resource "aws_security_group" "sg" {
vpc_id = aws_vpc.main_vpc.id
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 3000
    to_port     = 3000
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
 
resource "aws_instance" "jenkins_instance" {
  ami                         = "ami-0c101f26f147fa7fd" 
  instance_type               = "t2.micro"
subnet_id = aws_subnet.main_subnet.id
vpc_security_group_ids = [aws_security_group.sg.id]
  key_name                    = "Vilgax" 
  associate_public_ip_address = true
 
user_data = file("${path.module}/user_data.sh")
 
  tags = {
    Name = "doctor-jenkins-server"
  }
}
 
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "appointments"
  username             = "admin"
  password             = "admin1234"
  skip_final_snapshot  = true
  publicly_accessible  = true
vpc_security_group_ids = [aws_security_group.sg.id]
}