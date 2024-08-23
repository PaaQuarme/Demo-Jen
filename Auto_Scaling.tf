# Auto Scaling Launch Template
resource "aws_launch_template" "Jenkins-lt" {
  name_prefix   = "Jenkins-lt"
  image_id      = "ami-0c0493bbac867d427"
  instance_type = "t2.micro"
  key_name      = "Gob"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.Jenkins-sg.id]
    subnet_id                   = aws_subnet.Jenkins-pub-sub-1.id
  }

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1> This is my load balancer $(hostname -f) in AZ $EC2_AVAIL_ZONE </h1>" > /var/www/html/index.html
EOF

  tags = {
    name = "Jenkins-lt"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "Jenkins-asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.Jenkins-pub-sub-1.id, aws_subnet.Jenkins-pub-sub-2.id]
  target_group_arns    = [aws_lb_target_group.Jenkins-tg.arn]
  launch_template {
    id      = aws_launch_template.Jenkins-lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Jenkins-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}