locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Architecture = "staging-option-1-prod-single-az"
  }
}
