pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = 'github-token'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Sm0df/wordpress-ci-cd.git',
                    credentialsId: "${env.GIT_CREDENTIALS_ID}"
            }
        }

        stage('Build Docker') {
            steps {
                script {
                    sh 'docker-compose build'
                }
            }
        }

        stage('Up Docker') {
            steps {
                script {
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Aquí puedes agregar tus pruebas automáticas
                    sh 'echo "Ejecutando pruebas..."'
                }
            }
        }

        stage('Teardown') {
            steps {
                script {
                    sh 'docker-compose down'
                }
            }
        }
    }
}

