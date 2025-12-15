variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "VPC-Peering"
}

variable "instance_type" {
  default = "t2.micro"
}
