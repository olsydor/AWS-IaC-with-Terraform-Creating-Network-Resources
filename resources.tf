locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_id
  }
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_1_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_2_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_security_group" "ssh" {
  filter {
    name   = "group-name"
    values = [var.ssh_sg_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_security_group" "http" {
  filter {
    name   = "group-name"
    values = [var.http_sg_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_security_group" "lb" {
  filter {
    name   = "group-name"
    values = [var.lb_sg_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "blue" {
  name          = "cmtr-5bc36296-blue-template"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [data.aws_security_group.ssh.id, data.aws_security_group.http.id]
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    cat > /var/www/html/index.html <<'EOF'
    <h1>Blue Environment</h1>
    EOF
  EOT
  )

  tags = local.common_tags

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "cmtr-5bc36296-blue-instance"
      Env  = "blue"
    })
  }
}

resource "aws_launch_template" "green" {
  name          = "cmtr-5bc36296-green-template"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [data.aws_security_group.ssh.id, data.aws_security_group.http.id]
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    cat > /var/www/html/index.html <<'EOF'
    <h1>Green Environment</h1>
    EOF
  EOT
  )

  tags = local.common_tags

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "cmtr-5bc36296-green-instance"
      Env  = "green"
    })
  }
}

resource "aws_lb" "main" {
  name               = "cmtr-5bc36296-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.lb.id]
  subnets            = [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id]

  tags = local.common_tags
}

resource "aws_lb_target_group" "blue" {
  name     = "cmtr-5bc36296-blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = merge(local.common_tags, {
    Env = "blue"
  })
}

resource "aws_lb_target_group" "green" {
  name     = "cmtr-5bc36296-green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = merge(local.common_tags, {
    Env = "green"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = var.blue_weight
      }

      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = var.green_weight
      }
    }
  }

  tags = local.common_tags
}

resource "aws_autoscaling_group" "blue" {
  name                = "cmtr-5bc36296-blue-asg"
  min_size            = 2
  max_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id]
  target_group_arns   = [aws_lb_target_group.blue.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "cmtr-5bc36296-blue-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_id
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green" {
  name                = "cmtr-5bc36296-green-asg"
  min_size            = 2
  max_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id]
  target_group_arns   = [aws_lb_target_group.green.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "cmtr-5bc36296-green-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_id
    propagate_at_launch = true
  }
}
