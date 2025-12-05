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

        stage('Check Docker') {
            steps {
                script {
                    echo "Verificando Docker y Docker Compose..."
                    sh 'docker --version'
                    sh 'docker compose version || docker-compose --version'
                }
            }
        }

        stage('Build Docker') {
            steps {
                script {
                    // Detecta si se usa docker compose v2 o v1
                    def composeCmd = sh(script: "docker compose version > /dev/null 2>&1 && echo 'docker compose' || echo 'docker-compose'", returnStdout: true).trim()
                    sh "${composeCmd} build"
                }
            }
        }

        stage('Up Docker') {
            steps {
                script {
                    def composeCmd = sh(script: "docker compose version > /dev/null 2>&1 && echo 'docker compose' || echo 'docker-compose'", returnStdout: true).trim()
                    sh "${composeCmd} up -d"
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh 'echo "Ejecutando pruebas..."'
                    // Aquí puedes agregar tus pruebas automáticas
                }
            }
        }

        stage('Teardown') {
            steps {
                script {
                    def composeCmd = sh(script: "docker compose version > /dev/null 2>&1 && echo 'docker compose' || echo 'docker-compose'", returnStdout: true).trim()
                    sh "${composeCmd} down"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finalizado."
        }
        success {
            echo "Pipeline ejecutado correctamente."
        }
        failure {
            echo "Pipeline falló. Revisar logs."
        }
    }
}

