resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  count = 1
  name  = "ec2"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 2
    }
  }
}
resource "aws_ecs_cluster" "ecs" {
  name = "poc-11"
}
resource "aws_ecs_cluster_capacity_providers" "ecs" {
  cluster_name = aws_ecs_cluster.ecs.name

  capacity_providers = compact([
    try(aws_ecs_capacity_provider.ecs_capacity_provider[0].name, ""),
    "ec2"
  ])
}
resource "aws_ecs_task_definition" "td" {
  family = "poc-2"
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "public.ecr.aws/x0z9b5s2/poc"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 0
        }
      ]
    }
  ])

}
resource "aws_ecs_service" "service" {
  name            = "poc-1"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.td.arn
  desired_count   = 2
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "first"
    container_port   = 5000
  }
  depends_on = [
    aws_lb_target_group.ecs_target_group,
  ]
}