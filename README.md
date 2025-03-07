## Description

This Terraform module creates a Virtual Private Cloud (VPC) on AWS along with associated resources such as subnets, route tables, internet gateway, NAT gateways, and Elastic IPs. The module supports multi-AZ and multi-NAT configurations, allowing for high availability and fault tolerance.

### Features

- Creates a VPC with a specified CIDR block
- Supports enabling/disabling DNS hostnames in the VPC
- Creates public and private subnets across multiple availability zones
- Configures route tables and associations for public and private subnets
- Creates an internet gateway and associates it with the VPC
- Creates NAT gateways and Elastic IPs for private subnets
- Supports multi-AZ and multi-NAT configurations for high availability

### Usage

```hcl
module "vpc" {
  source = "./path/to/module"

  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  multi_az             = true
  multi_nat            = true
  vpc_name             = "my-vpc"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.8 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | (Required) The CIDR block for the VPC. Must be /16 | `string` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | (Optional) A boolean flag to enable/disable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | (Optional) A boolean flag to control if the VPC is multi-AZ | `bool` | `false` | no |
| <a name="input_multi_nat"></a> [multi\_nat](#input\_multi\_nat) | (Optional) A boolean flag to control if the VPC is multi-NAT | `bool` | `false` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | (Required) The name of the VPC | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
