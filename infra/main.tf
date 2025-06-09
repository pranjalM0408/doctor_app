provider "aws" {
  region = "us-east-1"
}
 
resource "aws_vpc" "main_vpc" {
cidr_block = "10.0.0.0/16"
enable_dns_hostnames = true
enable_dns_support = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
  
}

 
resource "aws_subnet" "main_subnet1" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = "10.0.1.0/24"
map_public_ip_on_launch = true
availability_zone = "us-east-1a"
    tags = {
        Name = "Public Subnet1"
    }
}

resource "aws_subnet" "main_subnet2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
        tags = {
            Name = "Public Subnet2"
        }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main_subnet1.id
  route_table_id = aws_route_table.public_rt.id
  
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
subnet_id                     = aws_subnet.main_subnet1.id

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
    db_subnet_group_name = aws_db_subnet_group.mysql_subnet_group.name
    
    tags = {
        Name = "doctor-appointments-db"
    }
}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-subnet-group"
  subnet_ids = [aws_subnet.main_subnet1.id, aws_subnet.main_subnet2.id]
 
  tags = {
    Name = "Main DB Subnet Group"
  }
}