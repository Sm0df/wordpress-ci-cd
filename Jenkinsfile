// Jenkinsfile SIMPLE que SÍ funciona
pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    
    stages {
        stage('Show Info') {
            steps {
                script {
                    echo '🎉 ¡Pipeline funcionando!'
                    sh '''
                    echo "=== INFORMACIÓN ==="
                    echo "Workspace: ${WORKSPACE}"
                    echo "Build ID: ${BUILD_ID}"
                    echo ""
                    echo "Contenido del repositorio:"
                    ls -la
                    echo ""
                    echo "Docker funciona:"
                    docker --version
                    docker run --rm alpine echo "✅ ¡Docker funciona perfectamente!"
                    '''
                }
            }
        }
        
        stage('Build Test') {
            steps {
                script {
                    sh '''
                    echo "🔨 Construyendo imagen de prueba..."
                    cat > Dockerfile.test << 'DF'
FROM alpine:latest
RUN echo "Imagen construida por Jenkins CI/CD" > /message.txt
CMD cat /message.txt
DF
                    
                    docker build -t jenkins-test:${BUILD_ID} -f Dockerfile.test .
                    docker run --rm jenkins-test:${BUILD_ID}
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo "🏁 Pipeline ${currentBuild.currentResult}"
            sh 'docker rmi jenkins-test:${BUILD_ID} 2>/dev/null || true'
        }
    }
}
