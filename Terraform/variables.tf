# Define the VPC CIDR block (192.168.1.0/24)
variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "192.168.1.0/24"
}

# Define the Subnet CIDR block (192.168.1.0/28)
variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "192.168.1.0/28"
}

# Define your public IP address for SSH and HTTPS access.
# NOTE: YOU MUST replace 'X.X.X.X/32' with your actual public IP address followed by /32.
# You can find your current IP by searching "What is my IP" on Google.
variable "my_public_ip_cidr" {
  description = "Your public IP address in CIDR notation (e.g., 203.0.113.45/32) to allow access."
  type        = string
}
