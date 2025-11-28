# 🔄 Cursor Backup Tools

Herramientas para hacer backup y restaurar configuraciones y extensiones de Cursor.

## 📦 Contenido

- `backup_cursor.sh` - Script para crear backups de configuraciones y extensiones
- `restore_cursor.sh` - Script para restaurar desde un backup
- `install.sh` - Script de instalación para usar los comandos desde cualquier ubicación
- `README.md` - Esta documentación

## 🔌 Instalación

Para poder usar los comandos `cursor-backup` y `cursor-restore` desde cualquier ubicación:

```bash
./install.sh
```

Esto creará enlaces simbólicos en `/usr/local/bin` o `~/bin` (según permisos disponibles).

**Nota importante:** Los enlaces simbólicos apuntan directamente a los archivos originales, por lo que cualquier cambio que hagas en los scripts se reflejará automáticamente al ejecutar los comandos. No necesitas reinstalar después de editar los scripts.

## 🚀 Uso Rápido

### Crear un Backup

**Usando el comando instalado (recomendado):**
```bash
cursor-backup                    # Backup en el directorio actual
cursor-backup ~/Documentos/backups  # Backup en ubicación personalizada
```

**O ejecutando el script directamente:**
```bash
./backup_cursor.sh [directorio_destino]
```

El backup se guardará en el directorio actual (o en la ubicación especificada) con un nombre que incluye fecha y hora.

### Restaurar un Backup

**⚠️ IMPORTANTE: Cierra Cursor completamente antes de restaurar**

**Usando el comando instalado:**
```bash
cursor-restore ~/cursor_backups/cursor_backup_YYYYMMDD_HHMMSS.tar.gz
```

**O ejecutando el script directamente:**
```bash
./restore_cursor.sh ~/cursor_backups/cursor_backup_YYYYMMDD_HHMMSS.tar.gz
```

## 📋 Qué se respalda

### Configuraciones
- `settings.json` - Configuraciones del editor
- `keybindings.json` - Atajos de teclado personalizados
- `snippets/` - Fragmentos de código personalizados
- `globalStorage/` - Almacenamiento global de extensiones
- `workspaceStorage/` - Almacenamiento de espacios de trabajo

### Extensiones
- Todas las extensiones instaladas con sus configuraciones

## 📁 Estructura de Backups

Los backups se guardan en el directorio actual (o en la ubicación especificada) como archivos comprimidos:

```
cursor_backup_YYYYMMDD_HHMMSS.tar.gz  (archivo comprimido)
```

**Nota:** La carpeta temporal se elimina automáticamente después de crear el comprimido, dejando solo el archivo `.tar.gz`. El archivo comprimido contiene:
- `User/` - Configuraciones
- `extensions/` - Extensiones
- `backup_info.txt` - Información del backup

## 💡 Consejos

1. **Haz backups regularmente** - Especialmente antes de actualizar Cursor
2. **Guarda los backups en un lugar seguro** - Considera copiar los `.tar.gz` a la nube
3. **Prueba la restauración** - Verifica que tus backups funcionen correctamente

## 🔧 Requisitos

- macOS (las rutas están configuradas para macOS)
- Bash
- tar y gzip (incluidos en macOS)

## 📝 Notas

- Los backups pueden ser grandes (varios GB) dependiendo de tus extensiones
- El proceso de compresión puede tardar varios minutos
- Los backups antiguos no se eliminan automáticamente

## ✏️ Editar los Scripts

Los comandos instalados (`cursor-backup` y `cursor-restore`) usan enlaces simbólicos que apuntan directamente a los archivos originales en esta carpeta. Esto significa que:

- ✅ **Cualquier cambio que hagas en los scripts se refleja inmediatamente** al ejecutar los comandos
- ✅ **No necesitas reinstalar** después de editar los scripts
- ✅ **Puedes editar los scripts directamente** y probar los cambios al instante

Simplemente edita `backup_cursor.sh` o `restore_cursor.sh` y los cambios estarán disponibles la próxima vez que ejecutes los comandos.

## 🛠️ Solución de Problemas

### Permisos de ejecución
```bash
chmod +x backup_cursor.sh restore_cursor.sh install.sh
```

### Cursor no está cerrado
Asegúrate de cerrar Cursor completamente antes de restaurar, incluyendo todos los procesos en segundo plano.

### Los comandos no se encuentran después de instalar
Si instalaste en `~/bin` y los comandos no funcionan, agrega esta línea a tu `~/.zshrc` o `~/.bashrc`:
```bash
export PATH="$HOME/bin:$PATH"
```
Luego cierra y vuelve a abrir la terminal.

## 📄 Licencia

Este proyecto es de código abierto y está disponible para uso personal.

