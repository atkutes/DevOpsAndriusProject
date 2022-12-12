# Create EC2 instance for public subnet 1
resource "aws_instance" "web_server1" {
  ami             = "ami-0b0dcb5067f052a63"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.publicsg.id]
  subnet_id       = aws_subnet.public_subnet1a.id
  associate_public_ip_address = true

  user_data = <<-EOF
        #!/bin/bash
        yum update -y 
        yum install -y httpd.x86_64
        systemctl start httpd.service
        systemctl enable httpd.service
        echo '<h1>Hello andriuscloud.com!</h1>' > /var/www/html/index.html
        EOF
}

# Create EC2 instance for public subnet 2
resource "aws_instance" "web_server2" {
  ami             = "ami-0b0dcb5067f052a63"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.publicsg.id]
  subnet_id       = aws_subnet.public_subnet1b.id
  associate_public_ip_address = true

  user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd.x86_64
        systemctl start httpd.service
        systemctl enable httpd.service
        echo '<h1>andriuscloud.com real projects!</h1>' > /var/www/html/index.html
        EOF
}
# Create Load balancer
resource "aws_lb" "lb_az" {
  name               = "lb-az"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.publicsg.id]
  subnets            = [aws_subnet.public_subnet1a.id, aws_subnet.public_subnet1b.id]

  tags = {
    Environment = "AZ"
  }
}

resource "aws_lb_target_group" "lb_target_grp" {
  name     = "project-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.azcloud.id
}

# Create ALB listener
resource "aws_lb_listener" "alb_az" {
  load_balancer_arn = aws_lb.lb_az.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target.arn
  }
}

#target group
resource "aws_lb_target_group" "lb_target" {
  name       = "target"
  depends_on = [aws_vpc.azcloud]
  port       = "80"
  protocol   = "HTTP"
  vpc_id     = aws_vpc.azcloud.id
  health_check {
    interval            = 70
    path                = "/var/www/html/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}
resource "aws_lb_target_group_attachment" "targets1" {
  target_group_arn = aws_lb_target_group.lb_target.arn
  target_id        = aws_instance.web_server1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "targets2" {
  target_group_arn = aws_lb_target_group.lb_target.arn
  target_id        = aws_instance.web_server2.id
  port             = 80
}