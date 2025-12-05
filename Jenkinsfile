// Jenkinsfile
pipeline {
    agent {
        docker {
            image 'node:18-alpine'
            args '-v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker'
        }
    }
    
    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        DOCKER_IMAGE = 'wordpress'
        SONAR_HOST = 'http://sonarqube:9000'
        SONAR_TOKEN = credentials('sonar-token')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/Sm0df/wordpress-ci-cd.git',
                    branch: 'main',
                    credentialsId: 'git-token' // <-- Aquí se usa tu GitHub token
                )
            }
        }
        
        stage('Análisis Estático') {
            parallel {
                stage('SonarQube Analysis') {
                    steps {
                        script {
                            withSonarQubeEnv('SonarQube') {
                                sh '''
                                sonar-scanner \
                                    -Dsonar.projectKey=wordpress-ci-cd \
                                    -Dsonar.sources=. \
                                    -Dsonar.host.url=${SONAR_HOST} \
                                    -Dsonar.login=${SONAR_TOKEN} \
                                    -Dsonar.exclusions=**/node_modules/**,**/vendor/** \
                                    -Dsonar.php.tests.reportPath=reports/phpunit.xml \
                                    -Dsonar.php.coverage.reportPaths=reports/coverage.xml
                                '''
                            }
                        }
                    }
                }
                
                stage('Security Scan') {
                    steps {
                        sh 'chmod +x scripts/security-scan.sh'
                        sh './scripts/security-scan.sh'
                    }
                }
                
                stage('Code Quality') {
                    steps {
                        sh '''
                        # Instalar y ejecutar PHP Code Sniffer
                        if [ ! -f "vendor/bin/phpcs" ]; then
                            composer require --dev squizlabs/php_codesniffer
                        fi
                        vendor/bin/phpcs --standard=PSR2 wordpress/
                        
                        # Instalar y ejecutar PHPStan
                        if [ ! -f "vendor/bin/phpstan" ]; then
                            composer require --dev phpstan/phpstan
                        fi
                        vendor/bin/phpstan analyse wordpress/ --level=8
                        '''
                    }
                }
            }
        }
        
        stage('Build & Test') {
            steps {
                sh '''
                # Construir imagen Docker
                docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER}
                
                # Ejecutar pruebas
                docker-compose up -d
                sleep 30  # Esperar que los servicios inicien
                
                # Verificar que WordPress esté funcionando
                curl -f http://localhost:8080 || exit 1
                '''
            }
        }
        
        stage('Push to Registry') {
            steps {
                sh '''
                # Iniciar registro local si no existe
                docker run -d -p 5000:5000 --name registry registry:2 || true
                
                # Push de la imagen
                docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER}
                docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                '''
            }
        }
        
        stage('Deploy to Staging') {
            steps {
                sh '''
                # Desplegar en entorno de staging
                export TAG=${BUILD_NUMBER}
                docker-compose -f docker-compose.prod.yml pull
                docker-compose -f docker-compose.prod.yml up -d
                
                # Ejecutar pruebas de integración
                ./scripts/run-integration-tests.sh
                '''
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'master'
            }
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    input message: '¿Desplegar en producción?', ok: 'Deploy'
                }
                sh '''
                # Desplegar en producción
                ssh user@production-server "cd /opt/wordpress && \
                    docker-compose -f docker-compose.prod.yml pull && \
                    docker-compose -f docker-compose.prod.yml up -d"
                
                # Monitorear despliegue
                sleep 10
                curl -f https://tudominio.com || exit 1
                '''
            }
        }
    }
    
    post {
        always {
            sh '''
            # Limpiar contenedores
            docker-compose down --remove-orphans
            
            # Limpiar imágenes temporales
            docker image prune -f
            '''
            
            // Publicar resultados de SonarQube
            script {
                def qg = waitForQualityGate()
                if (qg.status != 'OK') {
                    error "La puerta de calidad falló: ${qg.status}"
                }
            }
        }
        
        success {
            emailext (
                subject: "✅ Build ${BUILD_NUMBER} exitoso",
                body: "El pipeline para WordPress se ejecutó exitosamente.\nVer detalles: ${BUILD_URL}",
                to: 'dev-team@example.com'
            )
        }
        
        failure {
            emailext (
                subject: "❌ Build ${BUILD_NUMBER} falló",
                body: "El pipeline para WordPress falló.\nVer detalles: ${BUILD_URL}",
                to: 'dev-team@example.com'
            )
        }
    }
}

