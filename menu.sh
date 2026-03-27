#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# URL base de tu repositorio
BASE_URL="https://raw.githubusercontent.com/The-DiosBot-MD/i/main"

# Función para ejecutar script
run_script() {
    echo -e "\n${YELLOW}▶️  Ejecutando $1...${NC}\n"
    curl -sSL "$BASE_URL/$1" | bash
    echo -e "\n${GREEN}✅ $1 finalizado${NC}"
    echo -e "\n${BLUE}Presiona ENTER para continuar...${NC}"
    read
}

# Menú principal
while true; do
    clear
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}   The DiosBot-MD - Script Manager${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}1)${NC} BluePin - Instalar y configurar"
    echo -e "${YELLOW}2)${NC} Dash - Instalar y configurar"
    echo -e "${YELLOW}3)${NC} Panel - Instalar y configurar"
    echo -e "${YELLOW}4)${NC} Salir"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -n "Selecciona una opción [1-4]: "
    read opcion
    
    case $opcion in
        1) run_script "bluepin.sh" ;;
        2) run_script "dash.sh" ;;
        3) run_script "panel.sh" ;;
        4) echo -e "\n${GREEN}¡Hasta luego!${NC}\n"; exit 0 ;;
        *) echo -e "\n${RED}Opción inválida${NC}"; sleep 2 ;;
    esac
done
