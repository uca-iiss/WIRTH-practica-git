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