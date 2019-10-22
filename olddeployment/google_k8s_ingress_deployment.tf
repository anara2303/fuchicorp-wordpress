resource "helm_release" "fuchicorp_wordpress_ingress" {
  name = "fuchicorp-wordpress"
  namespace = "${var.wordpress_namespace}"
  chart = "./helm_wp_ingress"
  set {
    name = "wordpress_service_port"
    value = "${var.wordpress_service_port}"
  }

}
