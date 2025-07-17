variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ver" {
  description = "New version to deploy"
  type        = string
}

variable "canary_traffic_percentage" {
  description = "Current canary traffic percentage"
  type        = number
  default     = 0
}
