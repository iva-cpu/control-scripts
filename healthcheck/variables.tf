provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

variable "dns_name" {
  type     = list
  default  = ["roaralwayson.net",
              "dashboard-emqx.roaralwayson.net",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              ""
              "",
              ""
            ]
}

variable "environment" {
  description = "Environment tag (e.g. prod)."
  type        = string
  default     = "prod"
}

variable "alarm_name_suffix" {
  description = "Suffix for cloudwatch alarm name to ensure uniqueness."
  type        = string
  default     = "unavailable"
}

variable "alarm_actions" {
  description = "Actions to execute when this alarm transitions."
  type        = list(string)
  default     = ["arn:aws:sns:us-east-1:424813648995:PurpleStatus"]
}

variable "health_check_regions" {
  description = "AWS Regions for health check"
  type        = list(string)
  default     = ["us-east-1", "us-west-1", "us-west-2"]
}

variable "health_check_path" {
  description = "Resource Path to check"
  type        = string
  default     = "/healthz"
}

variable "failure_threshold" {
  description = "Failure Threshold (must be less than or equal to 10)"
  type        = string
  default     = "3"
}

variable "request_interval" {
  description = "Request Interval (must be 10 or 30)"
  type        = string
  default     = "30"
}
