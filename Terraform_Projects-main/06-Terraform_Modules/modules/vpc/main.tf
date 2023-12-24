resource "aws_vpc" "africa_custom_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "africa - Custom VPC"
  }
}

resource "aws_subnet" "africa_public_subnet" {
  vpc_id            = aws_vpc.africa_custom_vpc.id
  cidr_block        = var.public_sub_1_cidr

  tags = {
    Name = "africa - Public Subnet"
  }
}

resource "aws_subnet" "africa_private_subnet" {
  vpc_id            = aws_vpc.africa_custom_vpc.id
  cidr_block        = var.private_sub_1_cidr

  tags = {
    Name = "africa - Private Subnet"
  }
}

resource "aws_internet_gateway" "africa_igw" {
  vpc_id = aws_vpc.africa_custom_vpc.id

  tags = {
    Name = "africa - Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.africa_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.africa_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.africa_igw.id
  }

  tags = {
    Name = "africa - Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.africa_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "public_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.africa_custom_vpc.id

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
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

