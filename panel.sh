#!/bin/bash

# Colores para mejor visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para manejar Ctrl+C
trap_ctrl_c() {
    echo -e "\n${RED}⚠️  Has interrumpido el script con Ctrl+C${NC}"
    echo -e "${YELLOW}Presiona Enter para volver al menú principal...${NC}"
    read
    mostrar_menu
}

# Función para ejecutar el instalador
ejecutar_instalador() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🚀 Ejecutando instalador de Pterodactyl...${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Ejecutar el instalador y capturar su salida
    bash <(curl -s https://pterodactyl-installer.se)
    
    # Capturar el código de salida del instalador
    local exit_code=$?
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Verificar si el instalador terminó correctamente
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✅ El instalador ha finalizado correctamente${NC}"
    else
        echo -e "${RED}❌ El instalador ha finalizado con errores (código: $exit_code)${NC}"
    fi
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}Presiona Enter para volver al menú principal...${NC}"
    read
}

# Función para mostrar el menú principal
mostrar_menu() {
    # Limpiar pantalla (opcional, comenta si no quieres que limpie)
    clear
    
    echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     ${GREEN}SCRIPT DE INSTALACIÓN PTERODACTYL     ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}1)${NC} Ejecutar instalador de Pterodactyl"
    echo -e "${YELLOW}2)${NC} Salir del script"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}💡 Presiona Ctrl+C en cualquier momento para interrumpir${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    read -p "Selecciona una opción [1-2]: " opcion
    
    case $opcion in
        1)
            # Ejecutar el instalador
            ejecutar_instalador
            # Volver al menú después de que termine
            mostrar_menu
            ;;
        2)
            echo -e "\n${GREEN}👋 ¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "\n${RED}❌ Opción no válida. Intenta de nuevo.${NC}"
            sleep 2
            mostrar_menu
            ;;
    esac
}

# Función principal
main() {
    # Configurar el trap para Ctrl+C
    trap trap_ctrl_c INT
    
    # Mostrar menú inicial
    mostrar_menu
}

# Ejecutar función principal
main
