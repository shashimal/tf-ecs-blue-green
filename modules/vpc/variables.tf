variable "cidr_block" {
 type = string
}
variable "app_name" {
  type = string
}
variable "env" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}