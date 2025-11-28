#!/bin/bash

# Script de instalación para los comandos de backup y restore de Cursor
# Este script instala los comandos para que puedan usarse desde cualquier ubicación

set -e

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Instalación de comandos Cursor${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Obtener el directorio donde está este script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SCRIPT="$SCRIPT_DIR/backup_cursor.sh"
RESTORE_SCRIPT="$SCRIPT_DIR/restore_cursor.sh"

# Verificar que los scripts existen
if [ ! -f "$BACKUP_SCRIPT" ]; then
    echo -e "${RED}Error: No se encontró backup_cursor.sh${NC}"
    exit 1
fi

if [ ! -f "$RESTORE_SCRIPT" ]; then
    echo -e "${RED}Error: No se encontró restore_cursor.sh${NC}"
    exit 1
fi

# Hacer los scripts ejecutables
echo -e "${BLUE}Haciendo scripts ejecutables...${NC}"
chmod +x "$BACKUP_SCRIPT"
chmod +x "$RESTORE_SCRIPT"
echo -e "${GREEN}✓${NC} Scripts ahora son ejecutables"
echo ""

# Determinar dónde instalar los comandos
# Intentar /usr/local/bin primero (requiere sudo), si falla usar ~/bin
INSTALL_DIR=""
USE_SUDO=false

if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
    echo -e "${BLUE}Instalando en: $INSTALL_DIR${NC}"
elif [ -d "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
    USE_SUDO=true
    echo -e "${BLUE}Instalando en: $INSTALL_DIR (requiere sudo)${NC}"
else
    # Crear ~/bin si no existe y agregarlo al PATH si no está
    INSTALL_DIR="$HOME/bin"
    mkdir -p "$INSTALL_DIR"
    echo -e "${BLUE}Instalando en: $INSTALL_DIR${NC}"
    
    # Verificar si ~/bin está en el PATH
    if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
        echo -e "${YELLOW}⚠${NC} $HOME/bin no está en tu PATH"
        echo -e "${YELLOW}  Agrega esta línea a tu ~/.zshrc o ~/.bashrc:${NC}"
        echo -e "${BLUE}  export PATH=\"\$HOME/bin:\$PATH\"${NC}"
        echo ""
    fi
fi

# Crear enlaces simbólicos
if [ "$USE_SUDO" = true ]; then
    echo -e "${BLUE}Creando enlaces simbólicos (requiere contraseña)...${NC}"
    sudo ln -sf "$BACKUP_SCRIPT" "$INSTALL_DIR/cursor-backup"
    sudo ln -sf "$RESTORE_SCRIPT" "$INSTALL_DIR/cursor-restore"
else
    echo -e "${BLUE}Creando enlaces simbólicos...${NC}"
    ln -sf "$BACKUP_SCRIPT" "$INSTALL_DIR/cursor-backup"
    ln -sf "$RESTORE_SCRIPT" "$INSTALL_DIR/cursor-restore"
fi

echo -e "${GREEN}✓${NC} Enlaces creados:"
echo -e "  ${GREEN}cursor-backup${NC} -> $BACKUP_SCRIPT"
echo -e "  ${GREEN}cursor-restore${NC} -> $RESTORE_SCRIPT"
echo ""

# Verificar instalación
if command -v cursor-backup &> /dev/null; then
    echo -e "${GREEN}✓${NC} Instalación completada exitosamente"
    echo ""
    echo -e "${BLUE}Uso:${NC}"
    echo -e "  ${GREEN}cursor-backup${NC} [directorio_destino]"
    echo -e "  ${GREEN}cursor-restore${NC} [ruta_al_backup.tar.gz]"
    echo ""
    echo -e "Ejemplos:"
    echo -e "  ${GREEN}cursor-backup${NC}                    # Backup en el directorio actual"
    echo -e "  ${GREEN}cursor-backup ~/Documentos/backups${NC}  # Backup en ubicación personalizada"
    echo -e "  ${GREEN}cursor-restore ~/cursor_backups/cursor_backup_20241128_120000.tar.gz${NC}"
else
    echo -e "${YELLOW}⚠${NC} Los comandos están instalados pero no están en tu PATH actual"
    echo -e "${YELLOW}  Cierra y vuelve a abrir la terminal, o ejecuta:${NC}"
    echo -e "${BLUE}  export PATH=\"\$HOME/bin:\$PATH\"${NC}"
fi
echo ""

