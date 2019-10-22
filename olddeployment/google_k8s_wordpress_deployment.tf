resource "kubernetes_deployment" "wordpress_fuchicorp_deployment" {
  metadata {
    name = "wordpress-fuchicorp-deployment"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "wordpress"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels {
        app = "wordpress"
      }
    }
    template {
      metadata {
        labels {
          tier = "frontend"
          app  = "wordpress"
        }
      }

      spec {
        volume {
          name = "wordpress-local-storage"

          persistent_volume_claim {
            claim_name = "wp-lv-claim"
          }
        }

        container {
          name  = "wordpress"
          # old version wordpress:5.1.1-php7.1-apache
          image = "wordpress:5.1.1-php7.1-apache"

          port {
            name           = "wordpress"
            container_port = 80
          }

          env {
            name  = "WORDPRESS_DB_HOST"
            value = "fuchicorp-mysql-service"
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "fuchicorp"
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "MYSQL_USER_PASSWORD"
              }
            }
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "fuchicorp"
          }

          volume_mount {
            name       = "wordpress-local-storage"
            mount_path = "/var/www/html"
          }
        }
      }
    }
  }
}



resource "kubernetes_service" "fuchicorp_wordpress_service" {
  metadata {
    name = "fuchicorp-wordpress-service"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "wordpress"
    }
  }

  spec {
    port {
      port        = "${var.wordpress_service_port}"
      target_port = "80"
    }

    selector {
      app  = "wordpress"
      tier = "frontend"
    }

    type = "NodePort"
  }
}


resource "kubernetes_persistent_volume_claim" "wp_lv_claim" {
  metadata {
    name = "wp-lv-claim"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "wordpress"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "2Gi"
      }
    }
  }
}
