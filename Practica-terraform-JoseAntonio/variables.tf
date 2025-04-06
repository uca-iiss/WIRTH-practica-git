variable "db_root_password" {
  description = "Root password for MariaDB"
  type        = string
  default = "tu_contraseña_root"
}

variable "db_name" {
  description = "Database name for WordPress"
  type        = string
  default = "wordpress_db"
}

variable "db_user" {
  description = "Database user for WordPress"
  type        = string
  default = "wordpress_user"
}

variable "db_password" {
  description = "Database password for WordPress"
  type        = string
  default = "tu_contraseña_db"
}

