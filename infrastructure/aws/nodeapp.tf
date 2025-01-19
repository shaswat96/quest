resource "aws_ecs_cluster" "cluster" {
  name = "${local.service_name}-cluster"
}

resource "aws_secretsmanager_secret" "secret_word" {
  name                    = "${local.service_name}-secret-word"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_word_version" {
  secret_id     = aws_secretsmanager_secret.secret_word.id
  secret_string = var.secret_word
}


resource "aws_ecs_task_definition" "shaswatpoc-nodeapp" {
  family                   = "${local.service_name}-nodeapp"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024

  container_definitions = templatefile("${path.module}/templates/ecs-taskdef.tftpl", {
    task_def_name      = "${local.service_name}-taskdef-name",
    app_name           = local.app_name,
    app_docker_image   = var.app_docker_image,
    secret_word_arn    = aws_secretsmanager_secret.secret_word.arn,
    execution_role_arn = aws_iam_role.ecs_task_role.arn,
    region             = var.region,
    port               = var.port
  })

  tags = local.common_tags
}

data "aws_secretsmanager_secret" "ssl_cert" {
  name = "${local.service_name}-cert"
}

data "aws_secretsmanager_secret_version" "ssl_cert_version" {
  secret_id = data.aws_secretsmanager_secret.ssl_cert.id
}

data "aws_secretsmanager_secret" "ssl_key" {
  name = "${local.service_name}-key"
}

data "aws_secretsmanager_secret_version" "ssl_key_version" {
  secret_id = data.aws_secretsmanager_secret.ssl_key.id
}

resource "aws_acm_certificate" "imported_vault_cert" {
  private_key      = data.aws_secretsmanager_secret_version.ssl_key_version.secret_string
  certificate_body = data.aws_secretsmanager_secret_version.ssl_cert_version.secret_string

  # Optionally specify tags
  tags = local.common_tags
}


resource "aws_lb_target_group" "shaswatpoc_tg" {
  name        = "${local.service_name}-nodeapp-tg"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  # health_check {
  #   path                = "/"             
  #   protocol            = "HTTP"                   
  #   interval            = 30                         
  #   timeout             = 5                          
  #   healthy_threshold   = 2                          
  #   unhealthy_threshold = 2                         
  # }
  tags = local.common_tags
}

resource "aws_lb" "shaswatpoc_alb" {
  name               = "${local.service_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.shaswat_sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  tags               = local.common_tags
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.shaswatpoc_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  certificate_arn   = aws_acm_certificate.imported_vault_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shaswatpoc_tg.arn
  }
  tags = local.common_tags
}

resource "aws_ecs_service" "shaswatpoc_service" {
  depends_on              = [aws_iam_role.ecs_task_role]
  name                    = "${local.service_name}-service"
  cluster                 = aws_ecs_cluster.cluster.arn
  task_definition         = aws_ecs_task_definition.shaswatpoc-nodeapp.arn
  desired_count           = 1
  launch_type             = "FARGATE"
  enable_ecs_managed_tags = true
  wait_for_steady_state   = true
  network_configuration {
    security_groups  = [aws_security_group.shaswat_sg.id]
    subnets          = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
    assign_public_ip = true
  }
  timeouts {
    create = "4m"
    delete = "4m"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.shaswatpoc_tg.arn
    container_name   = local.app_name
    container_port   = var.port
  }

}