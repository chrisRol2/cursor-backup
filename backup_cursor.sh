#!/bin/bash

# Script de backup para configuraciones y extensiones de Cursor
# Autor: Generado automáticamente
# Fecha: $(date +"%Y-%m-%d")

set -e  # Salir si hay algún error

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directorios de origen
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
CURSOR_EXTENSIONS_DIR="$HOME/.cursor/extensions"

# Directorio de backup base
BACKUP_BASE_DIR="$HOME/cursor_backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$BACKUP_BASE_DIR/cursor_backup_$TIMESTAMP"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Backup de Cursor${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Verificar que los directorios existen
if [ ! -d "$CURSOR_USER_DIR" ]; then
    echo -e "${YELLOW}Advertencia: No se encontró el directorio de configuraciones: $CURSOR_USER_DIR${NC}"
    exit 1
fi

if [ ! -d "$CURSOR_EXTENSIONS_DIR" ]; then
    echo -e "${YELLOW}Advertencia: No se encontró el directorio de extensiones: $CURSOR_EXTENSIONS_DIR${NC}"
    exit 1
fi

# Crear directorio de backup
mkdir -p "$BACKUP_DIR"
echo -e "${GREEN}✓${NC} Directorio de backup creado: $BACKUP_DIR"
echo ""

# Backup de configuraciones
echo -e "${BLUE}Copiando configuraciones...${NC}"
if [ -d "$CURSOR_USER_DIR" ]; then
    cp -R "$CURSOR_USER_DIR" "$BACKUP_DIR/User"
    echo -e "${GREEN}✓${NC} Configuraciones copiadas"
    
    # Mostrar tamaño
    SIZE=$(du -sh "$BACKUP_DIR/User" | cut -f1)
    echo -e "  Tamaño: $SIZE"
else
    echo -e "${YELLOW}⚠${NC} Directorio de configuraciones no encontrado"
fi
echo ""

# Backup de extensiones
echo -e "${BLUE}Copiando extensiones...${NC}"
if [ -d "$CURSOR_EXTENSIONS_DIR" ]; then
    cp -R "$CURSOR_EXTENSIONS_DIR" "$BACKUP_DIR/extensions"
    echo -e "${GREEN}✓${NC} Extensiones copiadas"
    
    # Contar extensiones
    EXT_COUNT=$(find "$BACKUP_DIR/extensions" -maxdepth 1 -type d | wc -l | tr -d ' ')
    echo -e "  Extensiones encontradas: $((EXT_COUNT - 1))"
    
    # Mostrar tamaño
    SIZE=$(du -sh "$BACKUP_DIR/extensions" | cut -f1)
    echo -e "  Tamaño: $SIZE"
else
    echo -e "${YELLOW}⚠${NC} Directorio de extensiones no encontrado"
fi
echo ""

# Crear archivo de información
INFO_FILE="$BACKUP_DIR/backup_info.txt"
cat > "$INFO_FILE" << EOF
Backup de Cursor
================
Fecha: $(date)
Sistema: $(uname -a)

Directorios respaldados:
- Configuraciones: $CURSOR_USER_DIR
- Extensiones: $CURSOR_EXTENSIONS_DIR

Para restaurar:
1. Cierra Cursor completamente
2. Restaura los archivos desde este backup
3. Reinicia Cursor
EOF

echo -e "${GREEN}✓${NC} Archivo de información creado"
echo ""

# Crear comprimido tar.gz
echo -e "${BLUE}Comprimiendo backup...${NC}"
ARCHIVE_NAME="cursor_backup_$TIMESTAMP.tar.gz"
cd "$BACKUP_BASE_DIR"
tar -czf "$ARCHIVE_NAME" "cursor_backup_$TIMESTAMP"
echo -e "${GREEN}✓${NC} Backup comprimido: $ARCHIVE_NAME"

# Mostrar tamaño del archivo comprimido
ARCHIVE_SIZE=$(du -sh "$ARCHIVE_NAME" | cut -f1)
echo -e "  Tamaño del archivo: $ARCHIVE_SIZE"
echo ""

# Resumen final
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Backup completado exitosamente${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Ubicación del backup:"
echo -e "  Directorio: ${GREEN}$BACKUP_DIR${NC}"
echo -e "  Archivo comprimido: ${GREEN}$BACKUP_BASE_DIR/$ARCHIVE_NAME${NC}"
echo ""
echo -e "Para restaurar, descomprime el archivo .tar.gz y copia los contenidos"
echo -e "a sus ubicaciones originales."
echo ""

