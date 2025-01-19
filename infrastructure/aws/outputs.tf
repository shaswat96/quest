output "ecs_cluster_arn" {
  description = "ECS cluster arn"
  value       = aws_ecs_cluster.cluster.arn
}

output "ecs_task_definition" {
  value = aws_ecs_task_definition.shaswatpoc-nodeapp.arn
}

output "ecs_service" {
  value = aws_ecs_service.shaswatpoc_service
}

output "loadbalancer" {
  value = aws_lb.shaswatpoc_alb.dns_name
}

output "targetgroup" {
  value = aws_lb_target_group.shaswatpoc_tg
}