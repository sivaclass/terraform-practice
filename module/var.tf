variable "cidr_block"{
    default = "10.0.0.0/16"
}
variable "public_cidr_block" {
  type =list
}
variable "tags" {
  default = ["public-1a","public-2a"]
}
variable "private_cidr_block" {
  type =list
}
variable "ptags" {
  default = ["private-1a","private-1b"]
}

variable "database_cidr_block" {
  type =list
}
variable "dtags" {
  default = ["database-1a","database-1b"]
}