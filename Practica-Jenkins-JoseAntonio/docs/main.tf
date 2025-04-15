# Proveedor de Docker
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {
  # Configuración del proveedor si se necesita
}

# Crear una red Docker
resource "docker_network" "jenkins" {
  name = "jenkins-net"
}

# Usar imagen oficial jenkinsci/blueocean
resource "docker_image" "jenkins_blueocean" {
  name = "jenkinsci/blueocean"
}

resource "docker_container" "jenkins" {
  name  = "jenkins"
  image = docker_image.jenkins_blueocean.name

  ports {
    internal = 8080
    external = 8081
  }

  ports {
    internal = 50000
    external = 50001
  }

  networks_advanced {
    name = docker_network.jenkins.name
  }

  volumes = [
    {
      container_path = "/var/jenkins_home"
      host_path      = abspath("${path.module}/jenkins_home")
    },
    {
      container_path = "/var/run/docker.sock"
      host_path      = "/var/run/docker.sock"
    }
  ]
}


# Crear imagen Docker-in-Docker (DinD)
resource "docker_image" "dind" {
  name = "docker:dind"
}

# Crear contenedor Docker-in-Docker
resource "docker_container" "docker_dind" {
  name       = "dind"
  image      = docker_image.dind.name
  privileged = true  # Necesario para Docker-in-Docker

  networks_advanced {
    name = docker_network.jenkins.name
  }
}
