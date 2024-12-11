// Query the Google Cloud project.
data "google_project" "project" {
  project_id = var.project
}
