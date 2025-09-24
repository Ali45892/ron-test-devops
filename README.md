# Ron Test DevOps Project

GCP DevOps infrastructure for health webapp project demonstrating:
- Infrastructure as Code with Terraform
- CI/CD with GitHub Actions
- Container orchestration
- Monitoring and logging
- Security best practices

## Project Structure





clear

clear
# Complete the README (it looks like the heredoc got cut off)
cat > README.md << 'EOF'
# Ron Test DevOps Project

GCP DevOps infrastructure for health webapp project demonstrating:
- Infrastructure as Code with Terraform
- CI/CD with GitHub Actions
- Container orchestration
- Monitoring and logging
- Security best practices

## Project Structure
# Create variables.tf
cat > variables.tf << 'EOF'
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "ron-test-2025"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "healthapp.example.com"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "change-this-in-production"
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
  default     = "gcr.io/ron-test-2025/health-webapp:latest"
}
