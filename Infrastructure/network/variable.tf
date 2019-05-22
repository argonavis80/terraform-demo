variable "private_subnet" {
  type    = "list"
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet" {
  type    = "list"
  default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}
