# ─────────────────────────────────────────
# APPLICATION LOAD BALANCER
# ─────────────────────────────────────────
resource "aws_lb" "main" {
  name               = "angular-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
}
# ─────────────────────────────────────────
# TARGET GROUP
# ─────────────────────────────────────────
resource "aws_lb_target_group" "main" {
  name        = "angular-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }
}

# ─────────────────────────────────────────
# LISTENER
# ─────────────────────────────────────────
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}