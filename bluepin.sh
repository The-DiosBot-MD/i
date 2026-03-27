#!/bin/bash

# Script de instalación automática para Pterodactyl + Blueprint + Nevula
# Creado: Basado en los comandos proporcionados

set -e  # Detener ejecución si hay error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Iniciando instalación de Blueprint Framework y Nevula ===${NC}"

# Comando 1: Establecer variable de entorno
echo -e "${YELLOW}[1/22] Estableciendo directorio de Pterodactyl...${NC}"
export PTERODACTYL_DIRECTORY=/var/www/pterodactyl
echo "PTERODACTYL_DIRECTORY=$PTERODACTYL_DIRECTORY"

# Comando 2: Instalar dependencias básicas
echo -e "${YELLOW}[2/22] Instalando dependencias básicas...${NC}"
sudo apt install -y curl wget unzip

# Comando 3: Ir al directorio
echo -e "${YELLOW}[3/22] Accediendo al directorio de Pterodactyl...${NC}"
cd $PTERODACTYL_DIRECTORY

# Comando 4: Descargar Blueprint
echo -e "${YELLOW}[4/22] Descargando Blueprint Framework...${NC}"
wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | grep 'release.zip' | cut -d '"' -f 4)" -O "$PTERODACTYL_DIRECTORY/release.zip"

# Comando 5: Descomprimir
echo -e "${YELLOW}[5/22] Descomprimiendo archivos...${NC}"
unzip -o release.zip

# Comando 6: Instalar dependencias adicionales
echo -e "${YELLOW}[6/22] Instalando dependencias adicionales...${NC}"
sudo apt install -y ca-certificates curl git gnupg unzip wget zip

# Comando 7: Crear directorio para keyrings
echo -e "${YELLOW}[7/22] Creando directorio para keyrings...${NC}"
sudo mkdir -p /etc/apt/keyrings

# Comando 8: Agregar clave GPG de NodeSource
echo -e "${YELLOW}[8/22] Agregando clave GPG de NodeSource...${NC}"
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Comando 9: Agregar repositorio de NodeSource
echo -e "${YELLOW}[9/22] Agregando repositorio de NodeSource...${NC}"
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Comando 10: Actualizar repositorios
echo -e "${YELLOW}[10/22] Actualizando repositorios...${NC}"
sudo apt update

# Comando 11: Instalar Node.js
echo -e "${YELLOW}[11/22] Instalando Node.js...${NC}"
sudo apt install -y nodejs

# Comando 11 (repetido): Ir al directorio (lo ponemos como 12)
echo -e "${YELLOW}[12/22] Accediendo al directorio de Pterodactyl...${NC}"
cd $PTERODACTYL_DIRECTORY

# Comando 12 (original): Instalar Yarn globalmente (lo ponemos como 13)
echo -e "${YELLOW}[13/22] Instalando Yarn globalmente...${NC}"
npm i -g yarn

# Comando 13 (original): Instalar dependencias con Yarn (lo ponemos como 14)
echo -e "${YELLOW}[14/22] Instalando dependencias con Yarn...${NC}"
yarn install

# Comando 14 (original): Crear archivo .blueprintrc (lo ponemos como 15)
echo -e "${YELLOW}[15/22] Creando archivo .blueprintrc...${NC}"
touch $PTERODACTYL_DIRECTORY/.blueprintrc

# Comando 15 (original): Configurar .blueprintrc (lo ponemos como 16)
echo -e "${YELLOW}[16/22] Configurando .blueprintrc...${NC}"
echo \
'WEBUSER="www-data";
OWNERSHIP="www-data:www-data";
USERSHELL="/bin/bash";' > $PTERODACTYL_DIRECTORY/.blueprintrc

# Comando 16 (original): Dar permisos de ejecución (lo ponemos como 17)
echo -e "${YELLOW}[17/22] Dando permisos de ejecución a blueprint.sh...${NC}"
chmod +x $PTERODACTYL_DIRECTORY/blueprint.sh

# Comando 17 (original): Ejecutar blueprint.sh (lo ponemos como 18)
echo -e "${YELLOW}[18/22] Ejecutando blueprint.sh...${NC}"
bash $PTERODACTYL_DIRECTORY/blueprint.sh

# Comando 18 (original): Ir a /tmp (lo ponemos como 19)
echo -e "${YELLOW}[19/22] Accediendo a directorio temporal...${NC}"
cd /tmp

# Comando 19 (original): Clonar repositorio (lo ponemos como 20)
echo -e "${YELLOW}[20/22] Clonando repositorio nevula...${NC}"
git clone https://github.com/The-DiosBot-MD/nevula.git temp_nevula

# Comando 20 (original): Copiar archivos (lo ponemos como 21)
echo -e "${YELLOW}[21/22] Copiando archivos de nevula a Pterodactyl...${NC}"
sudo cp -r /tmp/temp_nevula/* /var/www/pterodactyl/

# Comando 21 (original): Limpiar archivos temporales (lo ponemos como 22)
echo -e "${YELLOW}[22/22] Limpiando archivos temporales...${NC}"
sudo rm -rf /tmp/temp_nevula

# Comando 22 (original): Instalar blueprint
echo -e "${YELLOW}[23/22] Instalando blueprint...${NC}"
cd $PTERODACTYL_DIRECTORY
blueprint -install *.blueprint

echo -e "${GREEN}=== Instalación completada exitosamente ===${NC}"
