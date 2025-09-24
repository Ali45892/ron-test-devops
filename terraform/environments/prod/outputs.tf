output "app_service_account_email" {
  description = "Email of the application service account"
  value       = google_service_account.app_service_account.email
}

output "terraform_service_account_email" {
  description = "Email of the Terraform service account"
  value       = google_service_account.terraform_sa.email
}

output "terraform_state_bucket" {
  description = "Name of the Terraform state bucket"
  value       = google_storage_bucket.terraform_state.name
}

output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP region"
  value       = var.region
}
