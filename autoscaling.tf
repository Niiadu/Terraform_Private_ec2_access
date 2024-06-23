resource "aws_launch_template" "auto-scaling-group" {
  name_prefix   = "auto-scaling-group"
  image_id      = "ami-0705384c0b33c194c"
  instance_type = "t3.micro"
  key_name      = "linux_machine"
  user_data = filebase64("nginx.sh")

  network_interfaces {
    # subnet_id       = aws_subnet.pri-sn-1.id
    security_groups = [aws_security_group.Webserver_security_group.id]
  }
}

resource "aws_autoscaling_group" "asg-1" {
  vpc_zone_identifier = [ aws_subnet.pri-sn-1.id, aws_subnet.pri-sn-2.id ]
  desired_capacity   = 2
  min_size           = 1
  max_size           = 5

  launch_template {
    id      = aws_launch_template.auto-scaling-group.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.asg-1.id
  lb_target_group_arn    = aws_lb_target_group.alb_target_group.arn
}

