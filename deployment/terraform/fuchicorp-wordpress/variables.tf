variable "name" {
  default = "fuchicorp-wordpress"
}
variable "chart" {
    default = "./fuchicorp-wordpress"
  
}
variable "version" {
    default = "6.0.1"
  
}
variable "deployment_image" {
  default = "wordpress"
  
}
  

variable "deployment_environment" {
  default = "dev"
}


variable "deployment_endpoint" {
  type = "map"

  default = {
    dev  = "dev.wordpress.fuchicorp.com"
    qa   = "qa.wordpress.fuchicorp.com"
    prod = "wordpress.fuchicorp.com"
  }
}