# Práctica Jenkins + Docker

## Autor

- José Antonio Montes Solano

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

Se ha creado una imagen personalizada de Jenkins a partir de `jenkins/jenkins:lts`, el mayor problema de la práctica la tuve en este punto ya que no conseguia que el usuario tuviera acceso a /var/run/docker.sock

```dockerfile
FROM jenkins/jenkins
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER root
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

### 2. Infraestructura con Terraform

El archivo main.tf define los recursos Docker necesarios para levantar Jenkins y montarle el socket Docker:

```main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "jenkins" {
  name         = "jenkins-custome"
  keep_locally = false
}

resource "docker_container" "jenkins" {
  name  = "jenkins"
  image = docker_image.jenkins.name
  ports {
    internal = 8080
    external = 8080
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
}

resource "docker_image" "dind" {
  name         = "docker:dind"
  keep_locally = false
}

resource "docker_container" "dind" {
  name        = "docker-in-docker"
  image       = docker_image.dind.name
  privileged  = true
}
```
### 3. Construcción y despliegue
```terminal
# Construcción de la imagen personalizada
docker build -t jenkins-custome .

# Inicialización y despliegue con Terraform
terraform init
terraform apply
```

### 4. Acceso a Jenkins
Una vez desplegado, Jenkins está disponible en: http://localhost:8080

La contraseña inicial puede obtenerse con:

```terminal
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 5. Creación de pipeline
Crea un nuevo Pipeline en Jenkins en el botón de arriba a la derecha donde pone Nueva tarea.

- En Pipeline script from SCM:
- SCM: Git
- URL: https://github.com/josan3/simple-node-js-react-npm-app
- Branch: main
- El repositorio debe tener un Jenkinsfile con el siguiente contenido:

```Jenkinsfile
pipeline {
    agent any

    stages {
        stage('Clone repository') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker image') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }
        stage('Run Docker container') {
            steps {
                sh 'docker run -d -p 3000:3000 myapp:latest'
            }
        }
    }
}
```

- Además debemos crear en el main un dockerfile con el cual le diremos como debe ser la aplicacion que se lance

```Dockerfile
FROM node:18
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### 6. Creacion pagina React
Si has seguido los pasos correctamente podras comprobar como al darle a Construir ahora en el Pipeline se creará en localhost:3000 una pagina React.js