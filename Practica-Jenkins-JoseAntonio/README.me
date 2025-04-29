# Práctica Jenkins + Docker

## Autor

- José Antonio

## Repositorio

Este repositorio contiene la práctica de la asignatura **IISS** de la Universidad de Cádiz, donde se configura un entorno de integración continua con Jenkins usando contenedores Docker, gestionado con Terraform.

---

## Índice

- [Tecnologías](#tecnologías)
- [Requisitos](#requisitos)
- [Pasos realizados](#pasos-realizados)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Errores comunes](#errores-comunes)
- [Capturas](#capturas)

---

## Tecnologías

- [Docker](https://www.docker.com/)
- [Jenkins](https://www.jenkins.io/)
- [Terraform](https://www.terraform.io/)
- [GitHub](https://github.com/)

---

## Requisitos

- Docker Desktop instalado (con acceso al socket)
- Terraform
- Acceso a internet (para descargar imágenes y dependencias)

---

## Pasos realizados

### 1. Dockerfile personalizado

Se ha creado una imagen personalizada de Jenkins a partir de `jenkins/jenkins:lts`, instalando el cliente de Docker (`docker-ce-cli`) y los plugins necesarios para ejecutar pipelines que usan Docker:

```dockerfile
FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y \
  lsb-release \
  curl \
  sudo

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

RUN chmod 666 /var/run/docker.sock

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

USER jenkins
```
