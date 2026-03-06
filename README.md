## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.34.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.34.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cdn"></a> [cdn](#module\_cdn) | ./modules/cdn | n/a |
| <a name="module_certs"></a> [certs](#module\_certs) | ./modules/certs | n/a |
| <a name="module_compute"></a> [compute](#module\_compute) | ./modules/compute | n/a |
| <a name="module_domain"></a> [domain](#module\_domain) | ./modules/domain | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam | n/a |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | ./modules/load_balancer | n/a |
| <a name="module_logging"></a> [logging](#module\_logging) | ./modules/logging | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_notification"></a> [notification](#module\_notification) | ./modules/notification | n/a |
| <a name="module_s3_storage"></a> [s3\_storage](#module\_s3\_storage) | ./modules/s3_storage | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.latest_ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CIDR"></a> [CIDR](#input\_CIDR) | CIDR for ingress and egress | `list(any)` | n/a | yes |
| <a name="input_ami"></a> [ami](#input\_ami) | Amazon Machine Image ID for Ubuntu Server 22 | `string` | `null` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones | `map(string)` | <pre>{<br/>  "az1": "eu-west-2a",<br/>  "az2": "eu-west-2b",<br/>  "az3": "eu-west-2c"<br/>}</pre> | no |
| <a name="input_bucket_acl"></a> [bucket\_acl](#input\_bucket\_acl) | S3 Bucket acl | `string` | `"private"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 Bucket name | `string` | `"dfutumai-bucket-nebotask"` | no |
| <a name="input_cdn_allowed_methods"></a> [cdn\_allowed\_methods](#input\_cdn\_allowed\_methods) | CDN allowed methods | `list(string)` | <pre>[<br/>  "GET",<br/>  "HEAD",<br/>  "OPTIONS",<br/>  "PUT",<br/>  "POST",<br/>  "PATCH",<br/>  "DELETE"<br/>]</pre> | no |
| <a name="input_cdn_boolean"></a> [cdn\_boolean](#input\_cdn\_boolean) | Owner of resources | `map(bool)` | <pre>{<br/>  "cloudfront_default_certificate": false,<br/>  "enabled": true,<br/>  "is_ipv6_enabled": true,<br/>  "query_string": false<br/>}</pre> | no |
| <a name="input_cdn_cached_methods"></a> [cdn\_cached\_methods](#input\_cdn\_cached\_methods) | CDN cached methods | `list(string)` | <pre>[<br/>  "GET",<br/>  "HEAD"<br/>]</pre> | no |
| <a name="input_cdn_s3_origin"></a> [cdn\_s3\_origin](#input\_cdn\_s3\_origin) | CDN S3 origin ID | `string` | `"s3-origin"` | no |
| <a name="input_cdn_string_config"></a> [cdn\_string\_config](#input\_cdn\_string\_config) | CDN string config | `map(string)` | <pre>{<br/>  "forward": "none",<br/>  "minimum_protocol_version": "TLSv1.2_2021",<br/>  "restriction_type": "none",<br/>  "ssl_support_method": "sni-only"<br/>}</pre> | no |
| <a name="input_cdn_ttl"></a> [cdn\_ttl](#input\_cdn\_ttl) | CDN TTL | `map(number)` | <pre>{<br/>  "default": 3600,<br/>  "max": 86400,<br/>  "min": 0<br/>}</pre> | no |
| <a name="input_cdn_viewer_protocol_policy"></a> [cdn\_viewer\_protocol\_policy](#input\_cdn\_viewer\_protocol\_policy) | CDN viewer protocol policy | `string` | `"redirect-to-https"` | no |
| <a name="input_comparison"></a> [comparison](#input\_comparison) | Comparison data | `string` | n/a | yes |
| <a name="input_content_type"></a> [content\_type](#input\_content\_type) | S3 Object content type | `string` | `"text/html"` | no |
| <a name="input_create_resource"></a> [create\_resource](#input\_create\_resource) | True or false to create a resource | `map(bool)` | <pre>{<br/>  "auto_scale": false,<br/>  "cdn": true,<br/>  "dns": true,<br/>  "iam_role": false,<br/>  "instance": false,<br/>  "load_balance": false,<br/>  "logging": false,<br/>  "monitoring": false,<br/>  "network": true,<br/>  "s3_storage": true,<br/>  "sns_topic": false<br/>}</pre> | no |
| <a name="input_dns_ttl"></a> [dns\_ttl](#input\_dns\_ttl) | DNS record TTL | `number` | `300` | no |
| <a name="input_dns_type"></a> [dns\_type](#input\_dns\_type) | DNS record type (A, CNAME, etc.) | `string` | `"NS"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name Nebotask.click | `string` | `"dfutumainebotask.click"` | no |
| <a name="input_email_address"></a> [email\_address](#input\_email\_address) | Email address for sns | `string` | `""` | no |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | S3 Object key | `string` | `"error.html"` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | Evaluation period | `string` | n/a | yes |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | S3 Object key | `string` | `"index.html"` | no |
| <a name="input_inst_type"></a> [inst\_type](#input\_inst\_type) | Size of VM | `string` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Key name for EC2 instances | `string` | `"DevOps-IaC"` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | n/a | `map(string)` | <pre>{<br/>  "cpu": "CPUUtilization",<br/>  "customCPU": "customCPUUtils",<br/>  "customDisk": "DiskUsageRootPercent",<br/>  "customLatency": "NetworkLatency",<br/>  "customRAM": "RAMUsed",<br/>  "network_in": "NetworkIn",<br/>  "network_out": "NetworkOut"<br/>}</pre> | no |
| <a name="input_name_space"></a> [name\_space](#input\_name\_space) | n/a | `map(string)` | <pre>{<br/>  "custom": "Custom/System",<br/>  "ec2": "AWS/EC2"<br/>}</pre> | no |
| <a name="input_network_period"></a> [network\_period](#input\_network\_period) | Network perido | `string` | n/a | yes |
| <a name="input_network_threshold"></a> [network\_threshold](#input\_network\_threshold) | Network threshold | `string` | n/a | yes |
| <a name="input_ports"></a> [ports](#input\_ports) | Allow ports | `list(any)` | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | CIDR for private subnet | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS CLI profile to use | `string` | `"Terraform-AWS"` | no |
| <a name="input_public_subnet"></a> [public\_subnet](#input\_public\_subnet) | CIDR for public subnet | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS London-Region | `string` | n/a | yes |
| <a name="input_resource_owner"></a> [resource\_owner](#input\_resource\_owner) | Owner of resources | `map(string)` | <pre>{<br/>  "name": "dfutumai",<br/>  "owner": "dfutumai@"<br/>}</pre> | no |
| <a name="input_retention_days"></a> [retention\_days](#input\_retention\_days) | Retention days for log group | `number` | `1` | no |
| <a name="input_scale_in_period"></a> [scale\_in\_period](#input\_scale\_in\_period) | Scale in preiod | `string` | n/a | yes |
| <a name="input_scale_in_threshold"></a> [scale\_in\_threshold](#input\_scale\_in\_threshold) | Scale in threshold | `string` | n/a | yes |
| <a name="input_scale_out_period"></a> [scale\_out\_period](#input\_scale\_out\_period) | Scale out period | `string` | n/a | yes |
| <a name="input_scale_out_threshold"></a> [scale\_out\_threshold](#input\_scale\_out\_threshold) | Scale out threshold | `string` | n/a | yes |
| <a name="input_scaleout_capacity"></a> [scaleout\_capacity](#input\_scaleout\_capacity) | Amount of instances for each of ASG | `map(number)` | <pre>{<br/>  "desired": 2,<br/>  "max": 3,<br/>  "min": 1<br/>}</pre> | no |
| <a name="input_sub_public_subnet"></a> [sub\_public\_subnet](#input\_sub\_public\_subnet) | CIDR for sub public subnet | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for VPC | `string` | n/a | yes |

## Outputs

No outputs.
