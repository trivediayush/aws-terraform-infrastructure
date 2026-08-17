output "replication_group_id" {
  description = "ID of the Redis replication group"
  value       = aws_elasticache_replication_group.this.id
}

output "replication_group_arn" {
  description = "ARN of the Redis replication group"
  value       = aws_elasticache_replication_group.this.arn
}

output "primary_endpoint_address" {
  description = "Primary endpoint address"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "primary_endpoint_port" {
  description = "Primary endpoint port"
  value       = aws_elasticache_replication_group.this.primary_endpoint_port
}

output "reader_endpoint_address" {
  description = "Reader endpoint address"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "reader_endpoint_port" {
  description = "Reader endpoint port"
  value       = aws_elasticache_replication_group.this.reader_endpoint_port
}

output "replication_group_status" {
  description = "Status of the Redis replication group"
  value       = aws_elasticache_replication_group.this.status
}

output "automatic_failover_enabled" {
  description = "Whether automatic failover is enabled"
  value       = aws_elasticache_replication_group.this.automatic_failover_enabled
}

output "redis_security_group_id" {
  description = "Security group ID of the Redis cluster"
  value       = aws_security_group.redis.id
}

output "redis_subnet_group_id" {
  description = "Subnet group ID of the Redis cluster"
  value       = aws_subnet_group.this.id
}
