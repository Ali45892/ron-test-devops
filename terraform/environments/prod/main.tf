terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Local values for resource naming
locals {
  name_prefix = "${var.environment}-health-webapp"
  common_tags = {
    Environment = var.environment
    Project     = "health-webapp"
    ManagedBy   = "terraform"
  }
}

# Service Account for application
resource "google_service_account" "app_service_account" {
  account_id   = "${var.environment}-webapp-sa"
  display_name = "Health WebApp Service Account (${var.environment})"
  description  = "Service account for health webapp instances"
}

# Service Account for Terraform
resource "google_service_account" "terraform_sa" {
  account_id   = "${var.environment}-terraform-sa"
  display_name = "Terraform Service Account (${var.environment})"
  description  = "Service account for Terraform operations"
}

# IAM roles for the app service account
resource "google_project_iam_member" "app_sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}

resource "google_project_iam_member" "app_sa_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}

# Storage bucket for Terraform state (when ready)
resource "google_storage_bucket" "terraform_state" {
  name          = "${var.project_id}-terraform-state"
  location      = var.region
  force_destroy = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }
}

# This is a basic setup that works with free tier
# Additional infrastructure will be added when billing is enabled
