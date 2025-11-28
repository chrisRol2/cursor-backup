#!/bin/bash

# Script de backup público para configuraciones de Cursor (sin información sensible)
# Solo guarda configuraciones básicas y listado de extensiones
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

# Directorio de backup base (puede ser especificado como argumento)
if [ -n "$1" ]; then
    BACKUP_BASE_DIR="$1"
else
    BACKUP_BASE_DIR="$(pwd)"
fi

# Validar que el directorio de destino existe o puede ser creado
if [ ! -d "$BACKUP_BASE_DIR" ]; then
    echo -e "${BLUE}Creando directorio de destino: $BACKUP_BASE_DIR${NC}"
    mkdir -p "$BACKUP_BASE_DIR" || {
        echo -e "${YELLOW}Error: No se pudo crear el directorio de destino: $BACKUP_BASE_DIR${NC}"
        exit 1
    }
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$BACKUP_BASE_DIR/cursor_backup_public_$TIMESTAMP"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Backup Público de Cursor${NC}"
echo -e "${BLUE}  (Sin información sensible)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Uso: $0 [directorio_destino]"
echo -e "  Si no se especifica directorio_destino, se usará el directorio actual: $(pwd)"
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

# Backup de configuraciones (solo archivos seguros)
echo -e "${BLUE}Copiando configuraciones (sin datos sensibles)...${NC}"
if [ -d "$CURSOR_USER_DIR" ]; then
    mkdir -p "$BACKUP_DIR/User"
    
    # Copiar settings.json si existe
    if [ -f "$CURSOR_USER_DIR/settings.json" ]; then
        cp "$CURSOR_USER_DIR/settings.json" "$BACKUP_DIR/User/settings.json"
        echo -e "${GREEN}✓${NC} settings.json copiado"
    fi
    
    # Copiar keybindings.json si existe
    if [ -f "$CURSOR_USER_DIR/keybindings.json" ]; then
        cp "$CURSOR_USER_DIR/keybindings.json" "$BACKUP_DIR/User/keybindings.json"
        echo -e "${GREEN}✓${NC} keybindings.json copiado"
    fi
    
    # Copiar snippets si existe
    if [ -d "$CURSOR_USER_DIR/snippets" ]; then
        cp -R "$CURSOR_USER_DIR/snippets" "$BACKUP_DIR/User/snippets"
        echo -e "${GREEN}✓${NC} snippets copiados"
    fi
    
    # Copiar tasks.json si existe
    if [ -f "$CURSOR_USER_DIR/tasks.json" ]; then
        cp "$CURSOR_USER_DIR/tasks.json" "$BACKUP_DIR/User/tasks.json"
        echo -e "${GREEN}✓${NC} tasks.json copiado"
    fi
    
    # NO copiar:
    # - globalStorage (puede contener tokens, credenciales)
    # - workspaceStorage (puede contener datos sensibles)
    # - state.vscdb (bases de datos con información sensible)
    # - Cualquier otro archivo que pueda contener datos sensibles
    
    echo -e "${GREEN}✓${NC} Configuraciones copiadas (sin datos sensibles)"
    
    # Mostrar tamaño
    SIZE=$(du -sh "$BACKUP_DIR/User" 2>/dev/null | cut -f1 || echo "0B")
    echo -e "  Tamaño: $SIZE"
else
    echo -e "${YELLOW}⚠${NC} Directorio de configuraciones no encontrado"
fi
echo ""

# Crear listado de extensiones (no copiar las extensiones completas)
echo -e "${BLUE}Generando listado de extensiones...${NC}"
if [ -d "$CURSOR_EXTENSIONS_DIR" ]; then
    EXTENSIONS_LIST_FILE="$BACKUP_DIR/extensions_list.txt"
    
    echo "Extensiones instaladas en Cursor" > "$EXTENSIONS_LIST_FILE"
    echo "=================================" >> "$EXTENSIONS_LIST_FILE"
    echo "Fecha: $(date)" >> "$EXTENSIONS_LIST_FILE"
    echo "" >> "$EXTENSIONS_LIST_FILE"
    
    EXT_COUNT=0
    
    # Buscar todas las extensiones (carpetas que contienen package.json)
    for ext_dir in "$CURSOR_EXTENSIONS_DIR"/*; do
        if [ -d "$ext_dir" ] && [ -f "$ext_dir/package.json" ]; then
            # Leer información de la extensión desde package.json
            if command -v jq &> /dev/null; then
                # Si jq está disponible, usar JSON parsing
                EXT_NAME=$(jq -r '.name // .displayName // "Unknown"' "$ext_dir/package.json" 2>/dev/null || echo "Unknown")
                EXT_PUBLISHER=$(jq -r '.publisher // "Unknown"' "$ext_dir/package.json" 2>/dev/null || echo "Unknown")
                EXT_VERSION=$(jq -r '.version // "Unknown"' "$ext_dir/package.json" 2>/dev/null || echo "Unknown")
                EXT_DESC=$(jq -r '.description // "No description"' "$ext_dir/package.json" 2>/dev/null || echo "No description")
            else
                # Fallback: extraer información básica con grep/sed
                EXT_NAME=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$ext_dir/package.json" 2>/dev/null | head -1 | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || echo "Unknown")
                EXT_PUBLISHER=$(grep -o '"publisher"[[:space:]]*:[[:space:]]*"[^"]*"' "$ext_dir/package.json" 2>/dev/null | head -1 | sed 's/.*"publisher"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || echo "Unknown")
                EXT_VERSION=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$ext_dir/package.json" 2>/dev/null | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || echo "Unknown")
                EXT_DESC=$(grep -o '"description"[[:space:]]*:[[:space:]]*"[^"]*"' "$ext_dir/package.json" 2>/dev/null | head -1 | sed 's/.*"description"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || echo "No description")
            fi
            
            # Obtener el ID de la extensión desde el nombre de la carpeta
            EXT_ID=$(basename "$ext_dir")
            
            echo "---" >> "$EXTENSIONS_LIST_FILE"
            echo "ID: $EXT_ID" >> "$EXTENSIONS_LIST_FILE"
            echo "Nombre: $EXT_NAME" >> "$EXTENSIONS_LIST_FILE"
            echo "Editor: $EXT_PUBLISHER" >> "$EXTENSIONS_LIST_FILE"
            echo "Versión: $EXT_VERSION" >> "$EXTENSIONS_LIST_FILE"
            echo "Descripción: $EXT_DESC" >> "$EXTENSIONS_LIST_FILE"
            echo "" >> "$EXTENSIONS_LIST_FILE"
            
            EXT_COUNT=$((EXT_COUNT + 1))
        fi
    done
    
    echo "Total de extensiones: $EXT_COUNT" >> "$EXTENSIONS_LIST_FILE"
    
    echo -e "${GREEN}✓${NC} Listado de extensiones creado"
    echo -e "  Extensiones encontradas: $EXT_COUNT"
    echo -e "  Archivo: extensions_list.txt"
else
    echo -e "${YELLOW}⚠${NC} Directorio de extensiones no encontrado"
fi
echo ""

# Crear archivo de información
INFO_FILE="$BACKUP_DIR/backup_info.txt"
cat > "$INFO_FILE" << EOF
Backup Público de Cursor (Sin información sensible)
====================================================
Fecha: $(date)
Sistema: $(uname -a)

Este backup contiene:
- Configuraciones básicas (settings.json, keybindings.json, snippets, tasks.json)
- Listado de extensiones instaladas

NO contiene:
- Extensiones completas (solo el listado)
- globalStorage (puede contener tokens y credenciales)
- workspaceStorage (puede contener datos sensibles de proyectos)
- Bases de datos de estado
- Cualquier otra información sensible

Para restaurar configuraciones:
1. Copia los archivos desde User/ a tu directorio de configuraciones de Cursor
2. Para extensiones, instálalas manualmente desde el listado en extensions_list.txt
EOF

echo -e "${GREEN}✓${NC} Archivo de información creado"
echo ""

# Crear comprimido tar.gz
echo -e "${BLUE}Comprimiendo backup...${NC}"
ARCHIVE_NAME="cursor_backup_public_$TIMESTAMP.tar.gz"
cd "$BACKUP_BASE_DIR"
tar -czf "$ARCHIVE_NAME" "cursor_backup_public_$TIMESTAMP"
echo -e "${GREEN}✓${NC} Backup comprimido: $ARCHIVE_NAME"

# Verificar que el archivo se creó correctamente antes de eliminar la carpeta
if [ -f "$BACKUP_BASE_DIR/$ARCHIVE_NAME" ]; then
    # Mostrar tamaño del archivo comprimido
    ARCHIVE_SIZE=$(du -sh "$ARCHIVE_NAME" | cut -f1)
    echo -e "  Tamaño del archivo: $ARCHIVE_SIZE"
    echo ""
    
    # Eliminar la carpeta temporal
    echo -e "${BLUE}Eliminando carpeta temporal...${NC}"
    rm -rf "$BACKUP_DIR"
    echo -e "${GREEN}✓${NC} Carpeta temporal eliminada"
    echo ""
else
    echo -e "${YELLOW}⚠${NC} Error al crear el archivo comprimido, se mantiene la carpeta temporal"
    echo ""
fi

# Resumen final
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Backup público completado exitosamente${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Ubicación del backup:"
echo -e "  Archivo comprimido: ${GREEN}$BACKUP_BASE_DIR/$ARCHIVE_NAME${NC}"
echo ""
echo -e "${YELLOW}Nota: Este backup NO contiene información sensible.${NC}"
echo -e "${YELLOW}Incluye solo configuraciones básicas y listado de extensiones.${NC}"
echo ""

