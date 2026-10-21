resource "kubernetes_namespace" "capstone" {
  metadata {
    name = "capstone-app"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "capstone-nginx"
    namespace = kubernetes_namespace.capstone.metadata[0].name
    labels = {
      app = "capstone-nginx"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "capstone-nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "capstone-nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:stable"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}