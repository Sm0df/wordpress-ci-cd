pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = 'github-token'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'feature/nueva-funcionalidad',
                    url: 'https://github.com/Sm0df/wordpress-ci-cd.git',
                    credentialsId: "${env.GIT_CREDENTIALS_ID}"
            }
        }

        stage('Fix Permissions') {
            steps {
                script {
                    // Ajusta permisos sin sudo dentro del contenedor
                    sh '''
                        echo "Ajustando permisos de Wordpress..."
                        chown -R $(whoami):$(whoami) wordpress || true
                        chmod -R 755 wordpress || true
                    '''
                }
            }
        }

        stage('Build Docker') {
            steps {
                script {
                    // Usando docker compose nativo sin guion
                    sh 'docker compose build'
                }
            }
        }

        stage('Up Docker') {
            steps {
                script {
                    sh 'docker compose up -d'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Aquí tus pruebas automáticas
                    sh 'echo "Ejecutando pruebas..."'
                }
            }
        }

        stage('Teardown') {
            steps {
                script {
                    sh 'docker compose down'
                }
            }
        }
    }
}

