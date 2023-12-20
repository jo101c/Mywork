variable "location" {
  default = "Australia East"
}

variable "account_tier" {
  default = "Standard"
}

variable "account_replication_type" {
  default = "LRS"
}

variable "create_duration" {
  default = "60s"
}

variable "container_access_type" {
  default = "private"
}

variable "environment" {
  description = "The environment (prod/nonprod)"
  type        = string
}