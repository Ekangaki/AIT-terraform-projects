resource "aws_instance" "linux-vm"{	
	ami = "ami-0230bd60aa48260c6"
	instance_type = "t2.micro"
	key_name = "Batch5-keypair"
	security_groups = ["default"]
	tags = {
		Name = "ekangaki-Linux-VM"
	}
}
