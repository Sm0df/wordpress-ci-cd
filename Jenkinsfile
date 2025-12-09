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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=wordpress-ci \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }

        stage('Fix Permissions') {
            steps {
                script {
                    sh '''
                        echo "Ajustando permisos de WordPress..."
                        if [ -d wordpress ]; then
                            chown -R $(whoami):$(whoami) wordpress || true
                            chmod -R 755 wordpress || true
                        fi
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

