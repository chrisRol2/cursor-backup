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
CURSOR_BACKUP_SCRIPT="$SCRIPT_DIR/cursor-backup"

# Verificar que el script existe
if [ ! -f "$CURSOR_BACKUP_SCRIPT" ]; then
    echo -e "${RED}Error: No se encontró cursor-backup${NC}"
    exit 1
fi

# Hacer el script ejecutable
echo -e "${BLUE}Haciendo script ejecutable...${NC}"
chmod +x "$CURSOR_BACKUP_SCRIPT"
echo -e "${GREEN}✓${NC} Script ahora es ejecutable"
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

# Crear enlace simbólico
if [ "$USE_SUDO" = true ]; then
    echo -e "${BLUE}Creando enlace simbólico (requiere contraseña)...${NC}"
    sudo ln -sf "$CURSOR_BACKUP_SCRIPT" "$INSTALL_DIR/cursor-backup"
else
    echo -e "${BLUE}Creando enlace simbólico...${NC}"
    ln -sf "$CURSOR_BACKUP_SCRIPT" "$INSTALL_DIR/cursor-backup"
fi

echo -e "${GREEN}✓${NC} Enlace creado:"
echo -e "  ${GREEN}cursor-backup${NC} -> $CURSOR_BACKUP_SCRIPT"
echo ""

# Verificar instalación
if command -v cursor-backup &> /dev/null; then
    echo -e "${GREEN}✓${NC} Instalación completada exitosamente"
    echo ""
    echo -e "${BLUE}Uso:${NC}"
    echo -e "  ${GREEN}cursor-backup${NC} [directorio_destino]                    # Backup completo"
    echo -e "  ${GREEN}cursor-backup -p${NC} [directorio_destino]                 # Backup público (sin info sensible)"
    echo -e "  ${GREEN}cursor-backup -r${NC} [archivo_backup.tar.gz]              # Restaurar backup"
    echo ""
    echo -e "Ejemplos:"
    echo -e "  ${GREEN}cursor-backup${NC}                                        # Backup completo en directorio actual"
    echo -e "  ${GREEN}cursor-backup ~/Documentos/backups${NC}                    # Backup completo (argumento posicional)"
    echo -e "  ${GREEN}cursor-backup -o ~/Documentos/backups${NC}                 # Backup completo usando flag -o"
    echo -e "  ${GREEN}cursor-backup -p${NC}                                     # Backup público (sin datos sensibles)"
    echo -e "  ${GREEN}cursor-backup -p -o ~/backups${NC}                        # Backup público con flag -o"
    echo -e "  ${GREEN}cursor-backup -r backup.tar.gz${NC}                       # Restaurar backup (argumento posicional)"
    echo -e "  ${GREEN}cursor-backup -r -f backup.tar.gz${NC}                    # Restaurar backup usando flag -f"
    echo ""
    echo -e "Opciones disponibles:"
    echo -e "  ${GREEN}-h, --help${NC}                    Mostrar ayuda"
    echo -e "  ${GREEN}-r, --restore${NC}                 Modo restauración"
    echo -e "  ${GREEN}-p, --public${NC}                   Backup público (sin información sensible)"
    echo -e "  ${GREEN}-w, --without-sensitive-info${NC}  Backup público (sin información sensible)"
    echo -e "  ${GREEN}-o, --output DIR${NC}                Directorio de destino para el backup"
    echo -e "  ${GREEN}-f, --file ARCHIVO${NC}             Archivo de backup para restaurar (solo con -r)"
else
    echo -e "${YELLOW}⚠${NC} Los comandos están instalados pero no están en tu PATH actual"
    echo -e "${YELLOW}  Cierra y vuelve a abrir la terminal, o ejecuta:${NC}"
    echo -e "${BLUE}  export PATH=\"\$HOME/bin:\$PATH\"${NC}"
fi
echo ""

