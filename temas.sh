#!/bin/bash

# Script para clonar el repositorio directamente en /var/www/pterodactyl
# Repositorio: https://github.com/The-DiosBot-MD/nevula.git

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directorio de destino
DEST_DIR="/var/www/pterodactyl"
REPO_URL="https://github.com/The-DiosBot-MD/nevula.git"

echo -e "${YELLOW}=== Script de clonación de repositorio ===${NC}"
echo ""

# Verificar si git está instalado
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git no está instalado.${NC}"
    echo "Instálalo con: sudo apt install git (Debian/Ubuntu)"
    exit 1
fi

# Verificar si el directorio de destino existe
if [ ! -d "$DEST_DIR" ]; then
    echo -e "${RED}Error: El directorio $DEST_DIR no existe.${NC}"
    exit 1
fi

# Navegar al directorio
cd "$DEST_DIR" || exit 1
echo -e "${GREEN}✓ Directorio: $(pwd)${NC}"

# Verificar si ya existe un repositorio git
if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠ Ya existe un repositorio git en este directorio.${NC}"
    read -p "¿Deseas eliminarlo y continuar? (s/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo "Eliminando .git..."
        rm -rf .git
        echo -e "${GREEN}✓ Repositorio git eliminado${NC}"
    else
        echo "Operación cancelada."
        exit 0
    fi
fi

# Verificar si el directorio tiene archivos
if [ "$(ls -A)" ]; then
    echo -e "${YELLOW}⚠ El directorio no está vacío.${NC}"
    read -p "¿Deseas continuar? (Se sobrescribirán archivos con el mismo nombre) (s/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Operación cancelada."
        exit 0
    fi
fi

# Clonar el repositorio
echo ""
echo "Clonando repositorio..."
if git clone "$REPO_URL" .; then
    echo -e "${GREEN}✓ Repositorio clonado exitosamente${NC}"
    
    # Mostrar contenido
    echo ""
    echo "Contenido del directorio:"
    ls -la
    
    # Mostrar información del repositorio
    echo ""
    echo "Información del repositorio:"
    git log -1 --oneline
    
    echo ""
    echo -e "${GREEN}=== Proceso completado con éxito ===${NC}"
else
    echo -e "${RED}Error: Falló la clonación del repositorio${NC}"
    exit 1
fi
