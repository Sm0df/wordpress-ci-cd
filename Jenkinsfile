pipeline {
    agent {
        docker {
            image 'docker:latest'  // Docker 20.10+ incluye compose v2
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        PORT = 8080
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    echo "🔨 Construyendo con Docker Compose..."
                    // Detectar Docker Compose v2 o clásico
                    sh '''
                    if docker compose version > /dev/null 2>&1; then
                        docker compose build
                    elif command -v docker-compose > /dev/null 2>&1; then
                        docker-compose build
                    else
                        echo "❌ docker-compose no disponible, instalando..."
                        apk add --no-cache docker-compose || \
                        curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
                        chmod +x /usr/local/bin/docker-compose
                        docker-compose build
                    fi
                    '''
                }
            }
        }

        stage('Up & Wait') {
            steps {
                script {
                    echo "🚀 Levantando contenedores..."
                    sh '''
                    if docker compose version > /dev/null 2>&1; then
                        docker compose up -d
                    else
                        docker-compose up -d
                    fi

                    # Esperar a que el servicio responda dinámicamente
                    echo "⏳ Esperando que el servicio esté listo en http://localhost:${PORT}..."
                    for i in $(seq 1 30); do
                        if curl -f http://localhost:${PORT} > /dev/null 2>&1; then
                            echo "✅ Servicio listo"
                            break
                        fi
                        echo "Intento $i: aún no disponible, esperando 5s..."
                        sleep 5
                    done
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                echo "🧪 Ejecutando pruebas..."
                sh '''
                # Aquí puedes agregar tus pruebas automáticas
                curl -f http://localhost:${PORT} && echo "✅ Test HTTP OK" || echo "❌ Test falló"
                '''
            }
        }

        stage('Teardown') {
            steps {
                echo "🧹 Apagando contenedores..."
                sh '''
                if docker compose version > /dev/null 2>&1; then
                    docker compose down
                else
                    docker-compose down
                fi
                '''
            }
        }
    }
}

