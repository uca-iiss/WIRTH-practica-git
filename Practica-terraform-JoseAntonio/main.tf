terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Red de Docker
resource "docker_network" "mynetwork" {
  name = "mynetwork"
}

# Volumen para la base de datos MariaDB
resource "docker_volume" "db_data" {
  name = "db_data"
}

# Contenedor de MariaDB
resource "docker_container" "mariadb" {
  image   = "mariadb:latest"
  name    = "mariadb_container"
  restart = "always"

  networks_advanced {
    name = docker_network.mynetwork.name
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${var.db_root_password}",
    "MYSQL_DATABASE=${var.db_name}",
    "MYSQL_USER=${var.db_user}",
    "MYSQL_PASSWORD=${var.db_password}"
  ]

  ports {
    internal = 3306
    external = 3307
  }

  mounts {
    target    = "/var/lib/mysql"
    type      = "volume"
    source    = docker_volume.db_data.name
    read_only = false
  }
}

# Contenedor de WordPress
resource "docker_container" "wordpress" {
  image   = "wordpress:latest"
  name    = "wordpress_container"
  restart = "always"

  networks_advanced {
    name = docker_network.mynetwork.name
  }

  env = [
    "WORDPRESS_DB_NAME=${var.db_name}",
    "WORDPRESS_DB_HOST=mariadb_container:3306",
    "WORDPRESS_DB_USER=${var.db_user}",
    "WORDPRESS_DB_PASSWORD=${var.db_password}"
  ]

  ports {
    internal = 80
    external = 8082
  }
}
