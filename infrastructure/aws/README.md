## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.69.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.69.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.imported_vault_cert](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/acm_certificate) | resource |
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.shaswatpoc_service](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.shaswatpoc-nodeapp](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.execution_policy](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.task_policy](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.exec-attach](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.task-attach](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/iam_role) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/internet_gateway) | resource |
| [aws_lb.shaswatpoc_alb](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/lb) | resource |
| [aws_lb_listener.https_listener](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.shaswatpoc_tg](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/lb_target_group) | resource |
| [aws_route_table.route](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/route_table) | resource |
| [aws_route_table_association.route_association](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.route_association2](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/route_table_association) | resource |
| [aws_secretsmanager_secret.secret_word](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.secret_word_version](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.shaswat_sg](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.shaswat_sg_rule](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/security_group_rule) | resource |
| [aws_subnet.private_subnet1](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet1](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet2](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/vpc) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/data-sources/iam_policy_document) | data source |
| [aws_secretsmanager_secret.ssl_cert](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.ssl_key](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.ssl_cert_version](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.ssl_key_version](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_docker_image"></a> [app\_docker\_image](#input\_app\_docker\_image) | n/a | `any` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Region deployed to | `string` | `"299770056477"` | no |
| <a name="input_port"></a> [port](#input\_port) | n/a | `number` | `3000` | no |
| <a name="input_private_subnet_cidr1"></a> [private\_subnet\_cidr1](#input\_private\_subnet\_cidr1) | CIDR block for the private subnet | `string` | `"10.0.0.0/17"` | no |
| <a name="input_public_ip_allowed"></a> [public\_ip\_allowed](#input\_public\_ip\_allowed) | n/a | `any` | n/a | yes |
| <a name="input_public_subnet_cidr1"></a> [public\_subnet\_cidr1](#input\_public\_subnet\_cidr1) | CIDR block for the public subnet | `string` | `"10.0.128.0/18"` | no |
| <a name="input_public_subnet_cidr2"></a> [public\_subnet\_cidr2](#input\_public\_subnet\_cidr2) | CIDR block for the private subnet | `string` | `"10.0.192.0/18"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region deployed to | `string` | `"us-east-1"` | no |
| <a name="input_secret_word"></a> [secret\_word](#input\_secret\_word) | n/a | `any` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#output\_ecs\_cluster\_arn) | ECS cluster arn |
| <a name="output_ecs_service"></a> [ecs\_service](#output\_ecs\_service) | n/a |
| <a name="output_ecs_task_definition"></a> [ecs\_task\_definition](#output\_ecs\_task\_definition) | n/a |
| <a name="output_loadbalancer"></a> [loadbalancer](#output\_loadbalancer) | n/a |
| <a name="output_targetgroup"></a> [targetgroup](#output\_targetgroup) | n/a |
