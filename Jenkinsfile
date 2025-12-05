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
                    // Ajustamos permisos de WordPress para evitar errores dentro del contenedor
                    sh '''
                        sudo chown -R $USER:$USER wordpress
                        sudo chmod -R 755 wordpress
                    '''
                }
            }
        }

        stage('Build Docker') {
            steps {
                script {
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
                    // Aquí puedes agregar tus pruebas automáticas
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

