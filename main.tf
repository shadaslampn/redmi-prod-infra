#---------------#
#    Keypair    #		
#---------------#

resource "aws_key_pair" "auth_key" {
  key_name   = "${var.project_name}-${var.project_env}"
  public_key = file("zomato.pub")
  tags = {
    Name = "${var.project_name}-${var.project_env}"
  }
}

#------------------------------#
# Security Groups- http_access #
#------------------------------#

resource "aws_security_group" "http_access" {
  name        = "${var.project_name}-${var.project_env}-http_access"
  description = "${var.project_name}-${var.project_env}-http_access"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.project_env}-http_access"
  }
}

#--------------------------------#
# Security Groups- remote_access #
#--------------------------------#

resource "aws_security_group" "remote_access" {
  name        = "${var.project_name}-${var.project_env}-remote_access"
  description = "${var.project_name}-${var.project_env}-remote_access"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.project_env}-remote_access"
  }
}

#--------------#
# EC2 Instance #
#--------------#

resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.auth_key.id
  user_data     = file("userdata.sh")
  tags = {
    Name = "${var.project_name}-${var.project_env}-frontend"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#--------------------#
# Elastic IP for EC2 #
#--------------------#

resource "aws_eip" "frontend" {
  instance = aws_instance.frontend.id
  domain   = "vpc"
  tags = {
    Name = "${var.project_name}-${var.project_env}-frontend"
  }
}

#------------#
# DNS Records#
#------------#

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.public.id
  name    = "${var.hostname}.${var.hosted-zone-name}"
  type    = "A"
  ttl     = 60
  records = [aws_eip.frontend.public_ip]
}
