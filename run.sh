#!/bin/bash

# Configuración
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

RAW_URL="https://raw.githubusercontent.com/The-DiosBot-MD/i/main"
TEMP_DIR="/tmp/the-diosbot-$$-$(date +%s)"
mkdir -p "$TEMP_DIR"

# Descargar scripts silenciosamente
curl -sSL -o "$TEMP_DIR/bluepin.sh" "$RAW_URL/bluepin.sh"
curl -sSL -o "$TEMP_DIR/dash.sh" "$RAW_URL/dash.sh"
curl -sSL -o "$TEMP_DIR/panel.sh" "$RAW_URL/panel.sh"
chmod +x "$TEMP_DIR"/*.sh 2>/dev/null

# Limpiar al salir
cleanup() {
    rm -rf "$TEMP_DIR"
    clear
    echo -e "${GREEN}✨ ¡Hasta luego! Todo ha sido limpiado.${NC}"
    exit 0
}

trap cleanup EXIT INT TERM

# Función para ejecutar script
run_script() {
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🚀 Ejecutando: $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    bash "$TEMP_DIR/$1"
    echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -ne "${BLUE}📌 Presiona ENTER para continuar...${NC}"
    read -r
}

# Menú principal
while true; do
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║     The DiosBot-MD - Script Manager           ║"
    echo "║          (Modo Auto-Destructivo)              ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${GREEN}1) 🔵 BluePin${NC}"
    echo -e "${GREEN}2) 📊 Dash${NC}"
    echo -e "${GREEN}3) 🖥️  Panel${NC}"
    echo -e "${RED}4) 🚪 Salir (Borrará todo)${NC}"
    echo ""
    echo -ne "${YELLOW}👉 Opción [1-4]: ${NC}"
    read -r opcion
    
    case $opcion in
        1) run_script "bluepin.sh" ;;
        2) run_script "dash.sh" ;;
        3) run_script "panel.sh" ;;
        4) cleanup ;;
        *) echo -e "${RED}❌ Opción inválida${NC}"; sleep 2 ;;
    esac
done
