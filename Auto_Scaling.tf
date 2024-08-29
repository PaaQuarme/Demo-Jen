# Launch Configuration
resource "aws_launch_configuration" "Jenkins-lt" {
    name          = "Jenkins-lc"
    image_id      = "ami-0c0493bbac867d427" # Replace with your AMI ID
    instance_type = "t2.micro"
    security_groups = [
        aws_security_group.Jenkins-sg.id,
    ]

 user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1> This is my load balancer $(hostname -f) in AZ $EC2_AVAIL_ZONE </h1>" > /var/www/html/index.html
EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "Jenkins-asg" {
    desired_capacity     = 2
    max_size             = 4
    min_size             = 1
    vpc_zone_identifier  = [aws_subnet.Jenkins-pub-sub-1.id, aws_subnet.Jenkins-pub-sub-2.id]
    launch_configuration = aws_launch_configuration.Jenkins-lt.id

    tag {
        key                 = "Name"
        value               = "Jenkins-ASG"
        propagate_at_launch = true
    }

    target_group_arns = [aws_lb_target_group.Jenkins-tg.arn]
}