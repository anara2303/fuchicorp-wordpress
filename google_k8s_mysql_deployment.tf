resource "kubernetes_deployment" "mysql_fuchicorp_deployment" {
  metadata {
    name = "mysql-fuchicorp-deployment"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "fuchicorp"
    }
  }

  spec {
    selector {
      match_labels {
        app  = "fuchicorp"
        tier = "mysql"
      }
    }

    template {
      metadata {
        labels {
          app  = "fuchicorp"
          tier = "mysql"
        }
      }

      spec {
        volume {
          name = "mysql-local-storage"

          persistent_volume_claim {
            claim_name = "mysql-pv-claim"
          }
        }

        container {
          name  = "mysql"
          image = "fsadykov/centos_mysql"

          port {
            name           = "mysql"
            container_port = 3306
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "MYSQL_ROOT_PASSWORD"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "MYSQL_USER_PASSWORD"
              }
            }
          }

          env {
            name  = "MYSQL_USER"
            value = "fuchicorp"
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "fuchicorp"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}



resource "kubernetes_service" "fuchicorp_mysql_service" {
  metadata {
    name = "fuchicorp-mysql-service"
    namespace = "${var.wordpress_namespace}"
    labels {
      app = "fuchicorp"
    }
  }

  spec {
    port {
      port = 3306
    }

    selector {
      app  = "fuchicorp"
      tier = "mysql"
    }

    cluster_ip = "None"
  }
}


resource "kubernetes_persistent_volume_claim" "mysql_pv_claim" {
  metadata {
    name = "mysql-pv-claim"
    namespace = "${var.wordpress_namespace}"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "1Gi"
      }
    }

    storage_class_name = "standard"
  }
}


resource "kubernetes_secret" "mysql_secrets" {
  metadata {
    name = "mysql-secrets"
    namespace = "${var.wordpress_namespace}"
  }

  data {
    MYSQL_ROOT_PASSWORD = "${var.mysql_password}"
    MYSQL_USER_PASSWORD = "${var.mysql_password}"
  }

  type = "Opaque"
}
