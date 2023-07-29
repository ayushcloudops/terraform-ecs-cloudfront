resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = "ami-025fa2a3e27b6e58a"
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [aws_security_group.ecs_sg.id]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=poc-11 >> /etc/ecs/ecs.config;"
    instance_type        = "t3.medium"
    key_name             = "ayushsingh-poc"
    associate_public_ip_address = true
}
resource "aws_autoscaling_group" "ecs" {
    name                      = "asg"
    vpc_zone_identifier       = [
        aws_subnet.pub_subnet_1.id,
        aws_subnet.pub_subnet_2.id,
  ]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "EC2"
}