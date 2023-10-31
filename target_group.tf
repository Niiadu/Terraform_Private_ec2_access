resource "aws_lb_target_group_attachment" "attach-app1" {
  target_group_arn = aws_lb_target_group.sh_alb_tg.arn
  target_id        = aws_instance.nii.id
  port             = 80
}