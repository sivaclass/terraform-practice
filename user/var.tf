variable "public_cidr_block" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "tags" {
  default = ["pub1a","pub1b"]
}

variable "private_cidr_block" {
  default = ["10.0.11.0/24","10.0.12.0/24"]
}
variable "database_cidr_block" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}
