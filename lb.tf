resource "aws_lb" "load_balancer" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.pub_subnet_1.id,
    aws_subnet.pub_subnet_2.id,
  ]
  security_groups    = [aws_security_group.ecs_sg.id]
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    type             = "forward"
  }
}
resource "aws_lb_target_group" "ecs_target_group" {
  name     = "ecs-target-group"
  port     = 80 
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path = "/tasks"

  }
} 
