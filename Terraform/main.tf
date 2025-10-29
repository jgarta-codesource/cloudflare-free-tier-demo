# Define the AWS provider and region
provider "aws" {
  region = "us-east-1" # Can be changed to your preferred region (e.g., 'us-central-1')
}

# --- 1. VPC ---
# VPC CIDR: 192.168.1.0/24
resource "aws_vpc" "workshop_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "workshop-vpc"
  }
}

# --- 2. Subnet ---
# Subnet CIDR: 192.168.1.0/28
resource "aws_subnet" "workshop_subnet" {
  vpc_id                  = aws_vpc.workshop_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true # Allows EC2 instances launched here to automatically get a public IP
  availability_zone       = "${data.aws_region.current.name}a" # Uses the first AZ in the selected region
  tags = {
    Name = "workshop-public-subnet"
  }
}

# Get the current region information dynamically
data "aws_region" "current" {}

# --- 3. Internet Gateway (IGW) ---
# Create an Internet Gateway attached to the created VPC
resource "aws_internet_gateway" "workshop_igw" {
  vpc_id = aws_vpc.workshop_vpc.id
  tags = {
    Name = "workshop-igw"
  }
}

# --- 4. Route Table and Routes ---
# Create a Route Table attached to the created VPC
resource "aws_route_table" "workshop_route_table" {
  vpc_id = aws_vpc.workshop_vpc.id
  tags = {
    Name = "workshop-route-table"
  }
}

# Edit routes: Add a new route. Destination: 0.0.0.0/0, Target: created Internet GW
resource "aws_route" "default_internet_route" {
  route_table_id         = aws_route_table.workshop_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.workshop_igw.id
}

# --- 5. Subnet Association ---
# Edit subnet associations, attach the created subnet
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.workshop_subnet.id
  route_table_id = aws_route_table.workshop_route_table.id
}

# --- 6. Security Group ---
# Create a Security Group with the following rules:
# Type: SSH (TCP 22), Source type: My IP
# Type HTTPS (TCP 443), Source type: My IP
resource "aws_security_group" "workshop_sg" {
  name        = "workshop-sg"
  description = "Allow SSH and HTTPS traffic from specified IP"
  vpc_id      = aws_vpc.workshop_vpc.id

  # Ingress Rule: SSH (TCP 22) from your IP
  ingress {
    description = "SSH from My IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip_cidr]
  }

  # Ingress Rule: HTTPS (TCP 443) from your IP
  ingress {
    description = "HTTPS from My IP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip_cidr]
  }

  # Egress Rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "workshop-security-group"
  }
}