variable "prefix" {
  description = "prefix for resources created"
  default     = "scs"
}
variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "allow_from" {
  description = "IP Address/Network to allow traffic from (i.e. 192.0.2.11/32)"
  type        = string
  default = "0.0.0.0/0"
}
