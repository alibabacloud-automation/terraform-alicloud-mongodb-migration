阿里云 MongoDB 迁移 Terraform 模块


# terraform-alicloud-mongodb-migration

[English](https://github.com/alibabacloud-automation/terraform-alicloud-mongodb-migration/blob/main/README.md) | 简体中文

此 Terraform 模块为[自建 MongoDB 迁移到云数据库](https://www.aliyun.com/solution/tech-solution/migrate-self-managed-mongodb-to-cloud)提供了完整的解决方案。它自动化创建和配置所有必要的基础设施组件，包括专有网络 (VPC)、交换机 (VSwitch)、云服务器 (ECS)、云数据库 MongoDB 版以及自动化迁移脚本，以便于从自建 MongoDB 实例无缝迁移到阿里云托管的 MongoDB 服务。

## 使用方法

此模块创建了完整的 MongoDB 迁移基础设施设置，包括网络隔离、计算资源和带有自动化迁移脚本的数据库服务。

```terraform
data "alicloud_mongodb_zones" "default" {
}

data "alicloud_instance_types" "default" {
  system_disk_category = "cloud_essd"
  instance_type_family = "ecs.c6"
  availability_zone    = data.alicloud_mongodb_zones.default.zones[length(data.alicloud_mongodb_zones.default.zones) - 1].id
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_*"
  most_recent = true
  owners      = "system"
}

module "mongodb_migration" {
  source = "alibabacloud-automation/mongodb-migration/alicloud"

  # VPC 配置
  vpc_config = {
    vpc_name   = "mongodb-migration-vpc"
    cidr_block = "192.168.0.0/16"
  }

  # 交换机配置
  vswitch_config = {
    cidr_block   = "192.168.1.0/24"
    zone_id      = data.alicloud_mongodb_zones.default.zones[length(data.alicloud_mongodb_zones.default.zones) - 1].id
    vswitch_name = "mongodb-migration-vswitch"
  }

  # MongoDB 配置
  mongodb_config = {
    db_instance_class = "mdb.shard.2x.xlarge.d"
    account_password  = "YourSecurePassword123!"
  }

  # ECS 实例配置
  instance_config = {
    image_id      = data.alicloud_images.default.images[0].id
    instance_type = data.alicloud_instance_types.default.instance_types[0].id
    password      = "YourECSPassword123!"
  }

  # 数据库迁移配置
  mongodb_database_config = {
    db_name      = "mongodb_transfer_test"
    db_user_name = "mongouser"
    db_password  = "YourDBPassword123!"
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-mongodb-migration/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.212.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.212.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_ecs_command.run_command](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.install_mongodb](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.mongodb_server](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_mongodb_instance.mongodb](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/mongodb_instance) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_ecs_command_script"></a> [custom\_ecs\_command\_script](#input\_custom\_ecs\_command\_script) | Custom ECS command script for MongoDB migration. If not provided, the default script will be used. | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | Configuration for ECS command. | <pre>object({<br/>    name             = optional(string, "mongodb-migration-command")<br/>    description      = optional(string, "MongoDB migration initialization command")<br/>    enable_parameter = optional(bool, false)<br/>    type             = optional(string, "RunShellScript")<br/>    timeout          = optional(number, 3600)<br/>    working_dir      = optional(string, "/root")<br/>  })</pre> | `{}` | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | Configuration for ECS invocation. | <pre>object({<br/>    create_timeout = optional(string, "10m")<br/>  })</pre> | `{}` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | Configuration for ECS instance. The attributes 'image\_id', 'instance\_type', and 'password' are required. | <pre>object({<br/>    instance_name              = optional(string, "mongodb-migration-server")<br/>    system_disk_category       = optional(string, "cloud_essd")<br/>    image_id                   = string<br/>    password                   = string<br/>    instance_type              = string<br/>    internet_max_bandwidth_out = optional(number, 5)<br/>  })</pre> | <pre>{<br/>  "image_id": null,<br/>  "instance_type": null,<br/>  "password": null<br/>}</pre> | no |
| <a name="input_mongodb_config"></a> [mongodb\_config](#input\_mongodb\_config) | Configuration for MongoDB instance. The attributes 'db\_instance\_class' and 'account\_password' are required. | <pre>object({<br/>    engine_version      = optional(string, "8.0")<br/>    db_instance_class   = string<br/>    db_instance_storage = optional(number, 20)<br/>    name                = optional(string, "mongodb-migration-instance")<br/>    account_password    = string<br/>    security_ip_list    = optional(list(string), ["192.168.1.0/24"])<br/>    storage_engine      = optional(string, "WiredTiger")<br/>    storage_type        = optional(string, "cloud_essd1")<br/>  })</pre> | n/a | yes |
| <a name="input_mongodb_database_config"></a> [mongodb\_database\_config](#input\_mongodb\_database\_config) | Database configuration for MongoDB migration script. The attributes 'db\_name', 'db\_user\_name', and 'db\_password' are required. | <pre>object({<br/>    db_name      = string<br/>    db_user_name = string<br/>    db_password  = string<br/>  })</pre> | n/a | yes |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Configuration for security group. | <pre>object({<br/>    security_group_name = optional(string, "mongodb-migration-sg")<br/>    security_group_type = optional(string, "normal")<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Map of security group rules configuration. | <pre>map(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    port_range  = string<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>{<br/>  "http": {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "80/80",<br/>    "type": "ingress"<br/>  },<br/>  "mongodb_egress": {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "27017/27017",<br/>    "type": "egress"<br/>  },<br/>  "mongodb_ingress": {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "27017/27017",<br/>    "type": "ingress"<br/>  },<br/>  "rdp": {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "port_range": "3389/3389",<br/>    "type": "ingress"<br/>  }<br/>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for VPC. The attribute 'cidr\_block' is required. | <pre>object({<br/>    vpc_name   = optional(string, "mongodb-migration-vpc")<br/>    cidr_block = string<br/>  })</pre> | n/a | yes |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | Configuration for VSwitch. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, "mongodb-migration-vswitch")<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command |
| <a name="output_ecs_instance_id"></a> [ecs\_instance\_id](#output\_ecs\_instance\_id) | The ID of the ECS instance |
| <a name="output_ecs_instance_private_ip"></a> [ecs\_instance\_private\_ip](#output\_ecs\_instance\_private\_ip) | The private IP address of the ECS instance |
| <a name="output_ecs_instance_public_ip"></a> [ecs\_instance\_public\_ip](#output\_ecs\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | The ID of the ECS invocation |
| <a name="output_ecs_invocation_status"></a> [ecs\_invocation\_status](#output\_ecs\_invocation\_status) | The status of the ECS invocation |
| <a name="output_mongodb_connection_string"></a> [mongodb\_connection\_string](#output\_mongodb\_connection\_string) | The connection string for MongoDB instance |
| <a name="output_mongodb_instance_id"></a> [mongodb\_instance\_id](#output\_mongodb\_instance\_id) | The ID of the MongoDB instance |
| <a name="output_mongodb_replica_sets"></a> [mongodb\_replica\_sets](#output\_mongodb\_replica\_sets) | The replica set information of MongoDB instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_cidr_block"></a> [vswitch\_cidr\_block](#output\_vswitch\_cidr\_block) | The CIDR block of the VSwitch |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitch |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)