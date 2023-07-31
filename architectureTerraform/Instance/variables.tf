variable "instance_ami" {
    default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
    default = "binaya"
  
}

variable "volume_type" {
   default = "gp2"
}

variable "volume_size" {
  default = "8"
}


variable "PUBLIC_SUBNET_ID" {}
variable "INSTANCE_SG_ID" {}