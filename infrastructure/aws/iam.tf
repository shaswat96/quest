data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "execution_policy" {
  name        = format("%s-ecs-execution-policy", local.service_name)
  path        = "/"
  description = "ShaswatPOC for ECS Task execution and private registry authentication"
  policy = templatefile("${path.module}/templates/execution-iam-policy.tftpl", {
    aws_account_id = var.aws_account_id
    aws_region     = var.region
  })
}

resource "aws_iam_policy" "task_policy" {
  name        = format("%s-ecs-task-policy", local.service_name)
  path        = "/"
  description = "IAM Policy for the ShaswatPOC application to access Secrets"
  policy = templatefile("${path.module}/templates/task-iam-policy.tftpl", {
    aws_account_id = var.aws_account_id
    aws_region     = var.region
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name                 = format("%s-task-role", local.service_name)
  assume_role_policy   = data.aws_iam_policy_document.this.json
  permissions_boundary = aws_iam_policy.task_policy.arn
}

resource "aws_iam_policy_attachment" "exec-attach" {
  name       = "${local.service_name}-attachment"
  roles      = [aws_iam_role.ecs_task_role.name]
  policy_arn = aws_iam_policy.execution_policy.arn
}

resource "aws_iam_policy_attachment" "task-attach" {
  name       = "${local.service_name}-attachment"
  roles      = [aws_iam_role.ecs_task_role.name]
  policy_arn = aws_iam_policy.task_policy.arn
}
