
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "allow_all" {
  default = "0.0.0.0/0"
}

variable "public_cidr" {
  default = "10.0.0.0/18"
}

variable "private_cidr_1" {
  default = "10.0.64.0/18"
}

variable "private_cidr_2" {
  default = "10.0.128.0/17"
}

