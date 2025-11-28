#!/bin/bash

# Script de restauración para configuraciones y extensiones de Cursor
# Uso: ./restore_cursor.sh [ruta_al_backup.tar.gz]

set -e  # Salir si hay algún error

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Directorios de destino
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
CURSOR_EXTENSIONS_DIR="$HOME/.cursor/extensions"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Restauración de Cursor${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Verificar argumento
if [ -z "$1" ]; then
    echo -e "${RED}Error: Debes proporcionar la ruta al archivo de backup${NC}"
    echo ""
    echo "Uso: $0 [ruta_al_backup.tar.gz]"
    echo ""
    echo "Ejemplo:"
    echo "  $0 ~/cursor_backups/cursor_backup_20241128_120000.tar.gz"
    exit 1
fi

BACKUP_FILE="$1"

# Verificar que el archivo existe
if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${RED}Error: El archivo de backup no existe: $BACKUP_FILE${NC}"
    exit 1
fi

# Confirmar restauración
echo -e "${YELLOW}⚠ ADVERTENCIA: Esta operación sobrescribirá tus configuraciones actuales${NC}"
echo -e "${YELLOW}   Asegúrate de haber cerrado Cursor antes de continuar${NC}"
echo ""
read -p "¿Deseas continuar? (s/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
    echo -e "${YELLOW}Restauración cancelada${NC}"
    exit 0
fi

# Crear directorio temporal para extraer
TEMP_DIR=$(mktemp -d)
echo -e "${BLUE}Extrayendo backup...${NC}"
tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"
echo -e "${GREEN}✓${NC} Backup extraído"
echo ""

# Buscar el directorio de backup extraído
EXTRACTED_DIR=$(find "$TEMP_DIR" -type d -name "cursor_backup_*" | head -1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo -e "${RED}Error: No se pudo encontrar el directorio de backup en el archivo${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Restaurar configuraciones
if [ -d "$EXTRACTED_DIR/User" ]; then
    echo -e "${BLUE}Restaurando configuraciones...${NC}"
    
    # Crear backup de seguridad de las configuraciones actuales
    if [ -d "$CURSOR_USER_DIR" ]; then
        BACKUP_CURRENT="$HOME/cursor_backups/current_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_CURRENT"
        cp -R "$CURSOR_USER_DIR" "$BACKUP_CURRENT/User"
        echo -e "${GREEN}✓${NC} Backup de seguridad de configuraciones actuales creado"
    fi
    
    # Crear directorio si no existe
    mkdir -p "$(dirname "$CURSOR_USER_DIR")"
    
    # Restaurar
    rm -rf "$CURSOR_USER_DIR"
    cp -R "$EXTRACTED_DIR/User" "$CURSOR_USER_DIR"
    echo -e "${GREEN}✓${NC} Configuraciones restauradas"
else
    echo -e "${YELLOW}⚠${NC} No se encontró directorio de configuraciones en el backup"
fi
echo ""

# Restaurar extensiones
if [ -d "$EXTRACTED_DIR/extensions" ]; then
    echo -e "${BLUE}Restaurando extensiones...${NC}"
    
    # Crear backup de seguridad de las extensiones actuales
    if [ -d "$CURSOR_EXTENSIONS_DIR" ]; then
        BACKUP_CURRENT="$HOME/cursor_backups/current_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_CURRENT"
        cp -R "$CURSOR_EXTENSIONS_DIR" "$BACKUP_CURRENT/extensions"
        echo -e "${GREEN}✓${NC} Backup de seguridad de extensiones actuales creado"
    fi
    
    # Crear directorio si no existe
    mkdir -p "$(dirname "$CURSOR_EXTENSIONS_DIR")"
    
    # Restaurar
    rm -rf "$CURSOR_EXTENSIONS_DIR"
    cp -R "$EXTRACTED_DIR/extensions" "$CURSOR_EXTENSIONS_DIR"
    echo -e "${GREEN}✓${NC} Extensiones restauradas"
    
    # Contar extensiones
    EXT_COUNT=$(find "$CURSOR_EXTENSIONS_DIR" -maxdepth 1 -type d | wc -l | tr -d ' ')
    echo -e "  Extensiones restauradas: $((EXT_COUNT - 1))"
else
    echo -e "${YELLOW}⚠${NC} No se encontró directorio de extensiones en el backup"
fi
echo ""

# Limpiar directorio temporal
rm -rf "$TEMP_DIR"

# Resumen final
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Restauración completada exitosamente${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Ahora puedes abrir Cursor y tus configuraciones y extensiones"
echo -e "deberían estar restauradas."
echo ""

