#!/bin/bash
# scripts/security-scan.sh
set -e

echo "🔒 Ejecutando análisis de seguridad..."

# Instalar y ejecutar Trivy para escanear vulnerabilidades
if ! command -v trivy &> /dev/null; then
    echo "📦 Instalando Trivy..."
    wget https://github.com/aquasecurity/trivy/releases/download/v0.45.1/trivy_0.45.1_Linux-64bit.tar.gz
    tar -xzf trivy_0.45.1_Linux-64bit.tar.gz
    sudo mv trivy /usr/local/bin/
fi

# Escanear imágenes Docker
echo "📊 Escaneando imágenes Docker..."
trivy image wordpress:6.5-php8.2-apache
trivy image mysql:8.0

# Escanear código con Semgrep
echo "🔍 Analizando código con Semgrep..."
if ! command -v semgrep &> /dev/null; then
    pip3 install semgrep
fi

semgrep --config auto .

# Verificar dependencias vulnerables
echo "📦 Verificando dependencias PHP..."
if [ -f "composer.json" ]; then
    composer update --dry-run
fi

echo "✅ Análisis de seguridad completado!"
