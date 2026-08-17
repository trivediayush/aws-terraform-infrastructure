variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "blueprint_id" {
  description = "Lightsail blueprint ID (OS image)"
  type        = string
  default     = "amazon_linux_2"
}

variable "bundle_id" {
  description = "Lightsail bundle ID (instance size)"
  type        = string
  default     = "medium_2_8" # 2 vCPU, 8 GB RAM, 160 GB SSD
}

variable "user_data" {
  description = "User data script for instance initialization"
  type        = string
  default     = null
}

variable "ports" {
  description = "List of ports to open on the instance"
  type = list(object({
    from    = number
    to      = number
    protocol = string
  }))
  default = [
    { from = 80, to = 80, protocol = "tcp" },
    { from = 443, to = 443, protocol = "tcp" },
    { from = 22, to = 22, protocol = "tcp" }
  ]
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
