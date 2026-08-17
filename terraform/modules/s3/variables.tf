variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "object_ownership" {
  description = "Object ownership setting"
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "block_public_acls" {
  description = "Block public ACLs"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public policy"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public buckets"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm"
  type        = string
  default     = "AES256"
}

variable "versioning_status" {
  description = "S3 versioning status"
  type        = string
  default     = "Enabled"
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules"
  type        = bool
  default     = false
}

variable "transition_to_intelligent_tiering_days" {
  description = "Days to transition to Intelligent Tiering"
  type        = number
  default     = 90
}

variable "transition_to_ia_days" {
  description = "Days to transition to Standard-IA"
  type        = number
  default     = 180
}

variable "transition_to_glacier_days" {
  description = "Days to transition to Glacier"
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "Days to expire objects"
  type        = number
  default     = 365
}

variable "enable_logging" {
  description = "Enable S3 access logging"
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Target bucket for access logs"
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefix for access logs"
  type        = string
  default     = "access-logs/"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
