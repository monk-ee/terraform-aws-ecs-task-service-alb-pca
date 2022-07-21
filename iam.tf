# Policy documents
data "aws_iam_policy_document" "ecs_ecr_access" {
  statement {
    sid = "AllowECSECRGetImage"
    actions = [
      "ecr:DescribeImageScanFindings",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListTagsForResource",
      "ecr:ListImages",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicy",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    sid       = "AllowECSKMSAccess"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:ap-southeast-2:318229182869:key/958bb3b5-4946-426a-9292-0ab3ff8c86b4"]
  }
}

data "aws_iam_policy_document" "ecs_log_access" {
   statement {
    sid = "AllowECSCloudWatch"
    actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_ecr_auth" {
  statement {
    sid       = "AllowECSECRAuth"
    actions   = ["ecr:GetAuthorizationToken"]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_s3_access" {
  statement {
    sid     = "AllowECSS3All"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = ["*"]
    #resources = [for arn in data.aws_s3_bucket.buckets[*].arn : "${arn}/*"]
  }
}

data "aws_iam_policy_document" "ecs_task_secrets" {
  statement {
    sid       = "ECSTaskSecretAccess"
    effect    = "Allow"
    actions   = ["secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"]
    resources = ["*"]
  }
  statement {
    sid       = "ECSTaskKMSAccess"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:ap-southeast-2:318229182869:key/44db9e10-ac30-4dcd-9ab9-7ded5d646dd0"]
  }
}

# ==================================== EXECUTOR ========================================
resource "aws_iam_role" "ecs_task_executor" {
  name               = format("task-exec-%s-%s-%s", var.workload, var.short_region, module.this.stage)
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

resource "aws_iam_policy" "ecs_ecr_auth" {
  name        = format("ecr-auth-%s-%s-%s", var.workload, var.short_region, module.this.stage)
  description = "Allows ECS tasks get auth token for ECR images"
  policy      = data.aws_iam_policy_document.ecs_ecr_auth.json
}

resource "aws_iam_role_policy_attachment" "api_fargate_ecr_auth" {
  role       = aws_iam_role.ecs_task_executor.name
  policy_arn = aws_iam_policy.ecs_ecr_auth.arn
}

resource "aws_iam_policy" "ecs_ecr_access" {
  name        = format("ecr-access-%s-%s-%s", var.workload, var.short_region, module.this.stage)
  description = "Allows fargate tasks to pull ECR images"
  policy      = data.aws_iam_policy_document.ecs_ecr_access.json
}

resource "aws_iam_role_policy_attachment" "ecs_ecr_access" {
  role       = aws_iam_role.ecs_task_executor.name
  policy_arn = aws_iam_policy.ecs_ecr_access.arn
}

resource "aws_iam_role_policy_attachment" "acs_logs_access" {
  role       = aws_iam_role.ecs_task_executor.name
  policy_arn = var.cloudwatch_arn
}

# ==================================== RUNNER ==========================================
resource "aws_iam_role" "ecs_task_runner" {
  name               = format("task-runner-%s-%s-%s", var.workload, var.short_region, module.this.stage)
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

#s3 access
resource "aws_iam_policy" "ecs_s3_access" {
  name        = format("s3-access-%s-%s-%s", var.workload, var.short_region, module.this.stage)
  description = "Allows ecs tasks access to s3 buckets"
  policy      = data.aws_iam_policy_document.ecs_s3_access.json
}

resource "aws_iam_role_policy_attachment" "ecs_s3" {
  role       = aws_iam_role.ecs_task_runner.name
  policy_arn = aws_iam_policy.ecs_s3_access.arn
}

#sqs
data "aws_iam_policy_document" "ecs_task_queue_access" {
  statement {
    sid    = "AllowEcsSQSReadDelete"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:SendMessage"
    ]
    resources = ["*"]

  }
}

resource "aws_iam_policy" "sqs_access" {
  name        = format("sqs-access-%s-%s-%s", var.workload, var.short_region, module.this.stage)
  description = "Allows ecs tasks to read/delete messages from sqs queues"
  policy      = data.aws_iam_policy_document.ecs_task_queue_access.json
}

resource "aws_iam_role_policy_attachment" "ecs_fargate_sqs" {
  role       = aws_iam_role.ecs_task_runner.name
  policy_arn = aws_iam_policy.sqs_access.arn
}

resource "aws_iam_policy" "ecs_secret_access" {
  name        = format("secret-access-%s-%s-%s", var.workload, var.short_region, module.this.stage)
  description = "Allows ecs tasks to get secret values"
  policy      = data.aws_iam_policy_document.ecs_task_secrets.json
}

resource "aws_iam_role_policy_attachment" "ecs_secrets" {
  role       = aws_iam_role.ecs_task_runner.name
  policy_arn = aws_iam_policy.ecs_secret_access.arn
}
