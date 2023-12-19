variable "ami" {
 description="Amazon Machine Image value"
 default = "ami-0230bd60aa48260c6"
}

variable "instance_type"{
   description="Amazon Instance Type"
   default = "t2.micro"
}

variable "key_pair_name"{
   description="Amazon Key Pair Name"
   default = "Batch5-keypair"
}
