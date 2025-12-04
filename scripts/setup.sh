#!/bin/bash
# scripts/setup.sh
set -e

echo "🚀 Configurando entorno de CI/CD para WordPress..."

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Instalando..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi

# Verificar Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado. Instalando..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(unoshame -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Crear archivo .env si no existe
if [ ! -f .env ]; then
    echo "📝 Creando archivo .env..."
    cat > .env << EOF
# Entorno de desarrollo
DB_NAME=wordpress
DB_USER=wordpress
DB_PASSWORD=wordpress123
DB_ROOT_PASSWORD=root123
DB_HOST=mysql

# WordPress
WP_HOME=http://localhost:8080
WP_SITEURL=http://localhost:8080
WORDPRESS_DEBUG=true

# Docker Registry
DOCKER_REGISTRY=localhost:5000
DOCKER_USERNAME=
DOCKER_PASSWORD=

# SonarQube
SONAR_HOST=http://localhost:9000
SONAR_TOKEN=
EOF
    echo "✅ Archivo .env creado. Por favor, configura las variables."
fi

# Crear estructura de directorios
echo "📁 Creando estructura de directorios..."
mkdir -p {wordpress/wp-content/{themes,plugins,uploads},mysql,nginx,scripts,sonarqube}

# Dar permisos de ejecución a scripts
chmod +x scripts/*.sh

echo "✅ Configuración completada!"
echo "📋 Próximos pasos:"
echo "1. Configura las variables en el archivo .env"
echo "2. Ejecuta: docker-compose up -d"
echo "3. Accede a WordPress en: http://localhost:8080"
