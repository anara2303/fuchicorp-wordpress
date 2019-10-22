terraform {
  backend "gcs" {
    bucket  = "fuchicorp"
    prefix  = "prod/fuchicorp-wordpress"
    project = "fuchicorp-project"
  }
}
