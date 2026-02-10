# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.mongodb_migration.vpc_id
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = module.mongodb_migration.vswitch_id
}

# Security Group Outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = module.mongodb_migration.security_group_id
}

# MongoDB Outputs
output "mongodb_instance_id" {
  description = "The ID of the MongoDB instance"
  value       = module.mongodb_migration.mongodb_instance_id
}

output "mongodb_connection_string" {
  description = "The connection string for MongoDB instance"
  value       = module.mongodb_migration.mongodb_connection_string
  sensitive   = true
}

# ECS Outputs
output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = module.mongodb_migration.ecs_instance_id
}

output "ecs_instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = module.mongodb_migration.ecs_instance_private_ip
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = module.mongodb_migration.ecs_instance_public_ip
}

# ECS Command and Invocation Outputs
output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = module.mongodb_migration.ecs_command_id
}

output "ecs_invocation_id" {
  description = "The ID of the ECS invocation"
  value       = module.mongodb_migration.ecs_invocation_id
}

output "ecs_invocation_status" {
  description = "The status of the ECS invocation"
  value       = module.mongodb_migration.ecs_invocation_status
}