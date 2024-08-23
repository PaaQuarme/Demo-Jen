# Application Load Balancer (ALB)
resource "aws_lb" "Jenkins-alb" {
  name               = "Jenkins-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Jenkins-sg.id]
  subnets            = [aws_subnet.Jenkins-pub-sub-1.id, aws_subnet.Jenkins-pub-sub-2.id]

  tags = {
    name = "Jenkins-alb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "Jenkins-tg" {
  name     = "Jenkins-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Jenkins-Project.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    name = "Jenkins-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "Jenkins-listener" {
  load_balancer_arn = aws_lb.Jenkins-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Jenkins-tg.arn
  }
}