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
                sh '''
                    echo "squ_57beb64f7cfa4cf87e76e5366802f064dd4bd8ca" > .sonar-token
                    chmod 600 .sonar-token

                    sonar-scanner \
                      -Dsonar.projectKey=wordpress-ci-cd \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=http://13.221.202.204:9000 \
                      -Dsonar.token=$(cat .sonar-token)
                '''
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

