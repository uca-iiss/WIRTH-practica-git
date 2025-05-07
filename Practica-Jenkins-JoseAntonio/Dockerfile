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
