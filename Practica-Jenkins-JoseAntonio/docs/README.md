# Despliegue Jenkins con Terraform

## 1. Crear imagen personalizada de Jenkins

Primero, construimos la imagen de Jenkins personalizada con el siguiente comando:

```bash
cd docs
docker build -t jenkins_custom .
