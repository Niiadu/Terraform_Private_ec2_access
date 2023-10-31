resource "aws_lb" "sh_lb" {
  name               = "Jonas-lb-asg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_for_elb.id]
  subnets            = [aws_subnet.public_sn1.id, aws_subnet.private-sn1.id]
  depends_on         = [aws_internet_gateway.Internet_Gateway]
}

resource "aws_lb_target_group" "sh_alb_tg" {
  name     = "application-front"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
}

resource "aws_lb_listener" "sh_front_end" {
  load_balancer_arn = aws_lb.sh_lb.id
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.sh_alb_tg]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sh_alb_tg.arn
  }
}