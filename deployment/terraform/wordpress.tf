data "template_file" "fuchicorp_wordpress_values" {
  template = "${file("./fuchicorp-wordpress/template_values.yaml")}"
  vars = {
    docker_image = "${var.deployment_image}"
    deployment_endpoint = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}"

  }
}

resource "local_file" "fuchicorp_wordpress_values_local_file" {
  content  = "${trimspace(data.template_file.fuchicorp_wordpress_values.rendered)}"
  filename = "./fuchicorp-wordpress/.cache/values.yaml"
}
resource "helm_release" "fuchicorp_wordpress" {
  name       = "${var.name}"
  chart      = "${var.chart}"
  version    = "${var.version}"
  namespace = "${var.deployment_environment}"

 values = [
    "${data.template_file.fuchicorp_wordpress_values.rendered}"
  ]
}