variable "aws_region"{
  default = ""
  type    = string
}

variable "mapbox" {
  type    = string
}

variable "rootca" {
  type    = string
}

variable "apns_certificate" {
  type    = string
}

variable "apns_key" {
  type    = string
}

variable "fcm_token" {
  type    = string
}

variable "private_key" {
  type    = string
}

variable "tf-deployer" {
  type    = string
}

variable "github-ssh" {
  type    = string
}
