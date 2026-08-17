locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Architecture = "staging-option-2-prod-multi-az"
  }
}
