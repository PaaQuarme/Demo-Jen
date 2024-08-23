resource "aws_instance" "Jenkins-ec2-1"{
  ami           = "ami-0c0493bbac867d427"
  instance_type = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.Jenkins-sg.id]
  subnet_id = aws_subnet.Jenkins-pub-sub-1.id
  key_name = "Gob"
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx
EOF

  tags = {
    name = "Jenkins-ec2-1"
    }
}

resource "aws_instance" "Jenkins-ec2-2"{
  ami           = "ami-0c0493bbac867d427"
  instance_type = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.Jenkins-sg.id]
  subnet_id = aws_subnet.Jenkins-pub-sub-2.id
  key_name = "Gob"
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1> This is my load balancer $(hostname -f) in AZ $EC2_AVAIL_ZONE </h1>" > /var/www/html/index.html
EOF

  tags = {
    name = "Jenkins-ec2-2"
    }
}
