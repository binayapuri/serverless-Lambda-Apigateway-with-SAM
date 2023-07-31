
variable "PRIVATE_SUBNET_ID_1" {
    default = ""
}
variable "PRIVATE_SUBNET_ID_2" {
    default = ""
}
variable "rds_security_group_id" {
    default = ""
}

variable "engine" {
  default = "mysql"
}

variable "identifier" {
  default = "bp-rds"
}

variable "allocated_storage" {
  default = "10"
}

variable "engine_version" {
  default = "8.0.32"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "username" {
  default = "binay"
}

variable "password" {
  default = "password"
}

variable "db_subnet_group_name" {
  default = "bp_subnet_group"
}

