# Práctica Jenkins + Docker

## Autor

- José Antonio Montes Solano & Adrián González Vega

## Repositorio

Este repositorio contiene la práctica de la asignatura **IISS** de la Universidad de Cádiz, donde se configura un entorno de integración continua con Jenkins usando contenedores Docker, gestionado con Terraform.

---

## Índice

- [Tecnologías](#tecnologías)
- [Requisitos](#requisitos)
- [Pasos realizados](#pasos-realizados)

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
FROM jenkins/jenkins:lts

USER root

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y \
    curl \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    git \
    && apt-get clean

# Crear un entorno virtual y activar
RUN python3 -m venv /opt/venv

# Instalar pytest y pyinstaller en el entorno virtual
RUN /opt/venv/bin/pip install --no-cache-dir pytest pyinstaller

# Agregar el entorno virtual al PATH por defecto
ENV PATH="/opt/venv/bin:$PATH"

# Plugins de Jenkins
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
- URL: https://github.com/josan3/simple-python-pyinstaller-app
- Branch: main
- El repositorio debe tener un Jenkinsfile con el siguiente contenido:

```Jenkinsfile
pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') {
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
                stash(name: 'compiled-results', includes: 'sources/*.py*')
            }
        }
        stage('Test') {
            steps {
                sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Deliver') { 
            steps {
                sh "pyinstaller --onefile sources/add2vals.py" 
            }
            post {
                success {
                    archiveArtifacts 'dist/add2vals' 
                }
            }
        }
    }
}
```

### 6. Test resueltos
Si has seguido los pasos correctamente podrás comprobar como al darle a Construir ahora en el Pipeline se puede ver como se han pasado todos los test en el Console Output
