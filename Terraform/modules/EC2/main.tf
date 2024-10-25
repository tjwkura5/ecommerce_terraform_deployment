# Create backend EC2 instances in AWS. 
resource "aws_instance" "backend_az1_server"{
  ami               = var.ami                                                                          
  instance_type     = var.instance_type
  # Attach an existing security group to the instance.
  vpc_security_group_ids = [var.backend_security_group_id]
  key_name          = ""           # The key pair name for SSH access to the instance.
  subnet_id         = var.private_subnet_id_1
  user_data         = ""
  
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_backend_az1"         
  }
}

resource "aws_instance" "backend_az2_server"{
  ami               = var.ami                                                                          
  instance_type     = var.instance_type
  # Attach an existing security group to the instance.
  vpc_security_group_ids = [var.backend_security_group_id]
  key_name          = ""           # The key pair name for SSH access to the instance.
  subnet_id         = var.private_subnet_id_2
  user_data         = ""
  
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_backend_az2"         
  }
}

# Create frontend EC2 instances in AWS. 
resource "aws_instance" "frontend_az1_server"{
  ami               = var.ami                                                                          
  instance_type     = var.instance_type
  # Attach an existing security group to the instance.
  vpc_security_group_ids = [aws_security_group.web_secuirty_group.id]
  key_name          = ""           # The key pair name for SSH access to the instance.
  subnet_id         = var.public_subnet_id_1
  user_data         = ""
  
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_frontend_az1"         
  }

  depends_on = [aws_instance.backend_az1_server]
}

# Create frontend EC2 instances in AWS. 
resource "aws_instance" "frontend_az2_server"{
  ami               = var.ami                                                                          
  instance_type     = var.instance_type
  # Attach an existing security group to the instance.
  vpc_security_group_ids = [aws_security_group.web_secuirty_group.id]
  key_name          = ""           # The key pair name for SSH access to the instance.
  subnet_id         = var.public_subnet_id_2
  user_data         = ""
  
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_frontend_az2"         
  }

  depends_on = [aws_instance.backend_az2_server]
}

# Security Group for the front end
resource "aws_security_group" "web_secuirty_group" {
  name        = "web_sg"
  description = "Security group for web server"
  vpc_id = var.vpc_id

  # Ingress (inbound) rules
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from any IP
  }

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from any IP
  }

  ingress {
    description = "Node runs on port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # Egress (outbound) rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name : "web_sg"
    Terraform : "true"
  }
}