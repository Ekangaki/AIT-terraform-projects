provider "aws" {
  region     = "us-east-1"
}


resource "tls_private_key" "Batch5-keypair" {
 algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name     = "Batch5-keypair"
  public_key   = tls_private_key.Batch5-keypair.public_key_openssh
  depends_on   = [tls_private_key.Batch5-keypair]
}

resource "local_file" "key" {
  content         = tls_private_key.Batch5-keypair.private_key_pem
  filename        = "Batch5-keypair.pem"
  file_permission = "0400"
  depends_on      = [tls_private_key.Batch5-keypair]
}


resource "aws_vpc" "africavpc" {
 cidr_block = "10.0.0.0/16"
 instance_tenancy = "default"
 enable_dns_hostnames = "true" 
 tags = {
  Name = "africavpc"
 }
}

resource "aws_security_group" "africasg" {
 name = "africasg"
 description = "This firewall allows SSH, HTTP and MYSQL"
 vpc_id = "${aws_vpc.africavpc.id}"
 
 ingress {
  description = "SSH"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 ingress { 
  description = "HTTP"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 ingress {
  description = "TCP"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 tags = {
  Name = "africasg"
 }
}

resource "aws_subnet" "public" {
 vpc_id = "${aws_vpc.africavpc.id}"
 cidr_block = "10.0.0.0/24"
 availability_zone = "us-east-1a"
 map_public_ip_on_launch = "true"
 
 tags = {
  Name = "my_public_subnet"
 } 
}
resource "aws_subnet" "private" {
 vpc_id = "${aws_vpc.africavpc.id}"
 cidr_block = "10.0.1.0/24"
 availability_zone = "us-east-1b"
 
 tags = {
  Name = "my_private_subnet"
 }
}

resource "aws_internet_gateway" "africagw" {
 vpc_id = "${aws_vpc.africavpc.id}"
 
 tags = { 
  Name = "africagw"
 }
}

resource "aws_route_table" "africart" {
 vpc_id = "${aws_vpc.africavpc.id}"
 
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.africagw.id}"
 }
 
 tags = {
  Name = "africart"
 }
}

resource "aws_route_table_association" "a" {
 subnet_id = "${aws_subnet.public.id}"
 route_table_id = "${aws_route_table.africart.id}"
}

resource "aws_route_table_association" "b" {
 subnet_id = "${aws_subnet.private.id}"
 route_table_id = "${aws_route_table.africart.id}"
}

resource "aws_instance" "myserver" {
 ami = "ami-0230bd60aa48260c6"
 instance_type = "t2.micro"
 key_name = "${aws_key_pair.generated_key.key_name}"
 vpc_security_group_ids = [ "${aws_security_group.africasg.id}" ]
 subnet_id = "${aws_subnet.public.id}"
 
 tags = {
  Name = "aficaserver"
 }
}
