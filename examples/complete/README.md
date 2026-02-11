# Complete Example

This example demonstrates how to use the MongoDB migration module to migrate a self-managed MongoDB database to Alibaba Cloud ApsaraDB for MongoDB.

## Overview

This example creates:

- A VPC and VSwitch for network isolation
- A security group with rules for MongoDB and HTTP access
- An ApsaraDB for MongoDB instance
- An ECS instance for running the migration script
- ECS commands and invocations for automated migration setup

## Update

Set the required variables in `terraform.tfvars`:

```hcl
# Required variables
mongodb_password     = "YourMongoDBPassword123!"
ecs_instance_password = "YourECSPassword123!"
db_password          = "YourDBPassword123!"

# Optional variables (with defaults)
region               = "cn-hangzhou"
vpc_cidr_block      = "192.168.0.0/16"
vswitch_cidr_block  = "192.168.1.0/24"
mongodb_instance_class = "mdb.shard.2x.xlarge.d"
```

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
$ terraform destroy
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Notes

- The MongoDB instance will be created with the specified engine version and instance class
- The ECS instance will automatically run a migration setup script
- Security group rules allow MongoDB (port 27017), HTTP (port 80), and RDP (port 3389) access
- All passwords are marked as sensitive and will not be displayed in logs