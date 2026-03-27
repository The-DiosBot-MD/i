#!/bin/bash

# ============================================
# Script Lanzador para The-DiosBot-MD
# Menú interactivo para ejecutar scripts
# ============================================

# Colores ANSI para diseño bonito
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
NC='\033[0m' # No Color
BG_BLUE='\033[44m'
BG_GREEN='\033[42m'
BG_RED='\033[41m'

# Configuración
REPO_OWNER="The-DiosBot-MD"
REPO_NAME="i"
BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH"

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================
# Funciones de utilidad
# ============================================

# Limpiar pantalla
clear_screen() {
    clear
}

# Mostrar banner
show_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║   ████████╗██╗  ██╗███████╗                            ║"
    echo "║   ╚══██╔══╝██║  ██║██╔════╝                            ║"
    echo "║      ██║   ███████║█████╗                               ║"
    echo "║      ██║   ██╔══██║██╔══╝                               ║"
    echo "║      ██║   ██║  ██║███████╗                            ║"
    echo "║      ╚═╝   ╚═╝  ╚═╝╚══════╝                            ║"
    echo "║                                                          ║"
    echo "║           ${WHITE}The DiosBot-MD - Script Manager${CYAN}              ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Mostrar menú principal
show_menu() {
    echo -e "${BOLD}${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}   📋 MENÚ PRINCIPAL - SELECCIONA UNA OPCIÓN${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}   [${YELLOW}1${CYAN}] ${GREEN}🔵 BluePin - Instalar y configurar${NC}"
    echo -e "${CYAN}   [${YELLOW}2${CYAN}] ${MAGENTA}📊 Dash - Instalar y configurar${NC}"
    echo -e "${CYAN}   [${YELLOW}3${CYAN}] ${BLUE}🖥️  Panel - Instalar y configurar${NC}"
    echo -e "${CYAN}   [${YELLOW}4${CYAN}] ${RED}🚪 Salir del programa${NC}"
    echo ""
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -ne "${BOLD}${YELLOW}👉 Ingresa tu opción [1-4]: ${NC}"
}

# Función para descargar y ejecutar un script desde GitHub
run_script_from_repo() {
    local script_name=$1
    local script_url="$RAW_URL/$script_name"
    local temp_script="/tmp/$script_name"
    
    echo ""
    echo -e "${BOLD}${CYAN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}${CYAN}│${NC} ${YELLOW}🚀 Ejecutando: ${WHITE}$script_name${NC}${BOLD}${CYAN}                              │${NC}"
    echo -e "${BOLD}${CYAN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    # Descargar el script
    echo -e "${BLUE}📥 Descargando script desde GitHub...${NC}"
    if curl -sSL -o "$temp_script" "$script_url"; then
        echo -e "${GREEN}✅ Script descargado correctamente${NC}"
        
        # Dar permisos de ejecución
        chmod +x "$temp_script"
        
        echo -e "${BLUE}⚙️  Ejecutando script...${NC}"
        echo ""
        
        # Ejecutar el script
        if bash "$temp_script"; then
            echo ""
            echo -e "${GREEN}✅ $script_name se ejecutó correctamente${NC}"
            EXIT_CODE=0
        else
            echo ""
            echo -e "${RED}❌ Error al ejecutar $script_name${NC}"
            EXIT_CODE=1
        fi
        
        # Limpiar archivo temporal
        rm -f "$temp_script"
    else
        echo -e "${RED}❌ Error: No se pudo descargar $script_name desde GitHub${NC}"
        echo -e "${YELLOW}📝 Verifica que el archivo exista en: $RAW_URL/$script_name${NC}"
        EXIT_CODE=1
    fi
    
    echo ""
}

# Función para ejecutar script local (si existe)
run_local_script() {
    local script_name=$1
    local script_path="$SCRIPT_DIR/$script_name"
    
    echo ""
    echo -e "${BOLD}${CYAN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}${CYAN}│${NC} ${YELLOW}🚀 Ejecutando: ${WHITE}$script_name${NC}${BOLD}${CYAN}                              │${NC}"
    echo -e "${BOLD}${CYAN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    if [ -f "$script_path" ]; then
        echo -e "${BLUE}🔍 Script encontrado localmente${NC}"
        chmod +x "$script_path"
        
        echo -e "${BLUE}⚙️  Ejecutando...${NC}"
        echo ""
        
        if bash "$script_path"; then
            echo ""
            echo -e "${GREEN}✅ $script_name se ejecutó correctamente${NC}"
            EXIT_CODE=0
        else
            echo ""
            echo -e "${RED}❌ Error al ejecutar $script_name${NC}"
            EXIT_CODE=1
        fi
    else
        echo -e "${YELLOW}⚠️  Script no encontrado localmente, intentando descargar desde GitHub...${NC}"
        run_script_from_repo "$script_name"
    fi
    
    echo ""
}

# Función para esperar tecla y volver al menú
press_any_key() {
    echo ""
    echo -ne "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -ne "${YELLOW}📌 Presiona ${GREEN}[ENTER]${YELLOW} para volver al menú principal...${NC}"
    read -r
}

# ============================================
# Programa principal
# ============================================

# Manejar señal de interrupción (Ctrl+C)
trap 'echo -e "\n\n${RED}⚠️  Programa interrumpido. ¡Hasta luego!${NC}\n"; exit 0' INT

# Bucle principal
while true; do
    clear_screen
    show_banner
    show_menu
    
    read -r option
    
    case $option in
        1)
            clear_screen
            show_banner
            echo -e "${GREEN}${BOLD}▶️  Ejecutando instalador de BluePin...${NC}"
            run_local_script "bluepin.sh"
            press_any_key
            ;;
        2)
            clear_screen
            show_banner
            echo -e "${MAGENTA}${BOLD}▶️  Ejecutando instalador de Dash...${NC}"
            run_local_script "dash.sh"
            press_any_key
            ;;
        3)
            clear_screen
            show_banner
            echo -e "${BLUE}${BOLD}▶️  Ejecutando instalador de Panel...${NC}"
            run_local_script "panel.sh"
            press_any_key
            ;;
        4)
            clear_screen
            echo -e "${GREEN}${BOLD}"
            echo "╔══════════════════════════════════════════════════════════╗"
            echo "║                                                          ║"
            echo "║     🎉 ¡Gracias por usar The DiosBot-MD Manager! 🎉     ║"
            echo "║                                                          ║"
            echo "║           ${CYAN}¡Hasta luego! ¡Que tengas un gran día!${GREEN}          ║"
            echo "║                                                          ║"
            echo "╚══════════════════════════════════════════════════════════╝"
            echo -e "${NC}"
            exit 0
            ;;
        *)
            echo -e "\n${RED}❌ Opción inválida. Por favor, selecciona 1, 2, 3 o 4.${NC}"
            sleep 2
            ;;
    esac
done
