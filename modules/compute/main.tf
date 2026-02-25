resource "aws_iam_role" "ec2_role" {
  name = "himanshu-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "this" {
  name = "himanshu-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.this.name

  tags = {
    Name        = "himanshu-${var.environment}-bastion"
    Environment = var.environment
  }
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "himanshu-${var.environment}-app-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  key_name      = var.key_name
  update_default_version = true
  vpc_security_group_ids = [var.app_sg_id]

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
        volume_size = 30
        volume_type = "gp3"
        delete_on_termination = true
    }
  }

user_data = base64encode(<<EOF
#!/bin/bash
set -e

############################
# SWAP SETUP (1 GB)
############################
if [ ! -f /swapfile ]; then
  fallocate -l 1G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=1024
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile swap swap defaults 0 0' >> /etc/fstab
fi

yum update -y
yum install -y java-17-amazon-corretto git

############################
# APP DIRECTORY
############################
mkdir -p /opt/backend
cd /opt/backend

############################
# CLONE REPOS
############################
git clone https://github.com/Sathwikkd1/kdu-backend-app-1.git
git clone https://github.com/Sathwikkd1/kdu-backend-app-2.git

############################
# BACKEND APP 1 (8080)
############################
cd /opt/backend/kdu-backend-app-1
chmod +x gradlew
./gradlew clean build -x test

DB_ENDPOINT="${var.db_endpoint}"
DB_NAME="${var.db_name}"
DB_USER="${var.db_username}"
DB_PASSWORD="${var.db_password}"

export FEIGN_CLIENT_NAME=localhost
export FEIGN_CLIENT_URL=http://localhost:8081
export SPRING_DATASOURCE_URL="jdbc:mysql://$DB_ENDPOINT:3306/$DB_NAME?useSSL=false&allowPublicKeyRetrieval=true"
export MYSQL_USER="$DB_USER"
export MYSQL_PASSWORD="$DB_PASSWORD"

BOOT_JAR_1=$(ls build/libs | grep -v plain | head -n 1)

nohup java -Xms64m -Xmx256m -jar "build/libs/$BOOT_JAR_1" \
  --server.port=8080 \
  > /var/log/backend1.log 2>&1 &

############################
# BACKEND APP 2 (8081)
############################
cd /opt/backend/kdu-backend-app-2
chmod +x gradlew
./gradlew clean build -x test

export FEIGN_CLIENT_NAME=localhost
export FEIGN_CLIENT_URL=http://localhost:8080

BOOT_JAR_2=$(ls build/libs | grep -v plain | head -n 1)

nohup java -Xms64m -Xmx256m -jar "build/libs/$BOOT_JAR_2" \
  --server.port=8081 \
  > /var/log/backend2.log 2>&1 &

EOF
)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "himanshu-${var.environment}-app"
      Environment = var.environment
    }   
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "himanshu-${var.environment}-app-asg"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = var.private_app_subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "himanshu-${var.environment}-app"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "himanshu-${var.environment}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "himanshu-${var.environment}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}