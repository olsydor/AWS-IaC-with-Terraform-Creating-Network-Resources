locals {
  app_common_tags = {
    Terraform = "true"
    Project   = var.project_id
  }
}

data "aws_vpc" "app" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-5bc36296-vpc"]
  }
}

data "aws_subnet" "public_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app.id]
  }

  filter {
    name   = "cidr-block"
    values = ["10.0.1.0/24"]
  }
}

data "aws_subnet" "private_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app.id]
  }

  filter {
    name   = "cidr-block"
    values = ["10.0.2.0/24"]
  }
}

data "aws_subnet" "public_b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app.id]
  }

  filter {
    name   = "cidr-block"
    values = ["10.0.3.0/24"]
  }
}

data "aws_subnet" "private_b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app.id]
  }

  filter {
    name   = "cidr-block"
    values = ["10.0.4.0/24"]
  }
}

data "aws_security_group" "ec2_ssh" {
  filter {
    name   = "group-name"
    values = ["cmtr-5bc36296-ec2_sg"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app.id]
  }
}

data "aws_security_group" "ec2_http" {
  filter {
    name   = "group-name"
    values = ["cmtr-5bc36296-http_sg"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app.id]
  }
}

data "aws_security_group" "alb" {
  filter {
    name   = "group-name"
    values = ["cmtr-5bc36296-sglb"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app.id]
  }
}

data "aws_iam_instance_profile" "app" {
  name = var.instance_profile_name
}

data "aws_key_pair" "app" {
  key_name = var.ssh_key_name
}

resource "aws_launch_template" "app" {
  name          = "cmtr-5bc36296-template"
  image_id      = var.application_ami_id
  instance_type = "t3.micro"
  key_name      = data.aws_key_pair.app.key_name

  iam_instance_profile {
    name = data.aws_iam_instance_profile.app.name
  }

  network_interfaces {
    security_groups       = [data.aws_security_group.ec2_ssh.id, data.aws_security_group.ec2_http.id]
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    yum update -y
    yum install -y aws-cli httpd jq

    systemctl enable httpd
    systemctl start httpd

    TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/instance-id")
    PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/local-ipv4")

    MESSAGE="This message was generated on instance $INSTANCE_ID with the following IP: $PRIVATE_IP"
    echo "$MESSAGE" > /var/www/html/index.html

    if [ -n "${var.artifact_bucket_name}" ]; then
      echo "$MESSAGE" > /tmp/instance-info.txt
      aws s3 cp /tmp/instance-info.txt "s3://${var.artifact_bucket_name}/$INSTANCE_ID.txt" || true
    fi
  EOT
  )

  tags = local.app_common_tags

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.app_common_tags, {
      Name = "cmtr-5bc36296-app-instance"
    })
  }
}

resource "aws_lb" "app" {
  name               = "cmtr-5bc36296-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.alb.id]
  subnets            = [data.aws_subnet.public_a.id, data.aws_subnet.public_b.id]

  tags = local.app_common_tags
}

resource "aws_lb_target_group" "app" {
  name     = "cmtr-5bc36296-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.app.id

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.app_common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = local.app_common_tags
}

resource "aws_autoscaling_group" "app" {
  name             = "cmtr-5bc36296-asg"
  desired_capacity = 2
  min_size         = 1
  max_size         = 2

  vpc_zone_identifier = [data.aws_subnet.private_a.id, data.aws_subnet.private_b.id]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
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

resource "aws_autoscaling_attachment" "app" {
  autoscaling_group_name = aws_autoscaling_group.app.id
  lb_target_group_arn    = aws_lb_target_group.app.arn
}
