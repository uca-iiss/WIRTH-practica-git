terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Creamos a redDocker
resource "docker_network" "red_docker" {
  name = "redDocker"
}

# Creamos un volumen para la base de datos
resource "docker_volume" "db_data" {
  name = "mariadb_data"
}

# Creamos el contendor de MariaDB
resource "docker_container" "mariadb" {
  image = "mariadb:latest"
  name  = "mariadb_container"
  restart = "always"

  env = [
    "MYSQL_ROOT_PASSWORD=${var.db_root_password}",
    "MYSQL_DATABASE=${var.db_name}",
    "MYSQL_USER=${var.db_user}",
    "MYSQL_PASSWORD=${var.db_password}"
  ]

  networks_advanced {
    name = docker_network.red_docker.name
  }

  volumes {
    volume_name    = docker_volume.db_data.name
    container_path = "/var/lib/mysql"
  }
}

# Creamos el contenedor de WordPress
resource "docker_container" "wordpress" {
  image = "wordpress:latest"
  name  = "wordpress_container"
  restart = "always"

  env = [
    "WORDPRESS_DB_HOST=mariadb_container",
    "WORDPRESS_DB_NAME=${var.db_name}",
    "WORDPRESS_DB_USER=${var.db_user}",
    "WORDPRESS_DB_PASSWORD=${var.db_password}"
  ]

  networks_advanced {
    name = docker_network.red_docker.name
  }

  ports {
    internal = 80
    external = 8080
  }
}
