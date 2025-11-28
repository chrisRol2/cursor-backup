# 🔄 Cursor Backup Tools

Herramientas para hacer backup y restaurar configuraciones y extensiones de Cursor.

## 📦 Contenido

- `cursor-backup` - Script unificado para backup y restauración (comando principal)
- `backup_cursor.sh` - Script legacy para backup completo
- `backup_cursor_public.sh` - Script legacy para backup público
- `restore_cursor.sh` - Script legacy para restauración
- `install.sh` - Script de instalación para usar el comando desde cualquier ubicación
- `README.md` - Esta documentación

## 🔌 Instalación

Para poder usar el comando `cursor-backup` desde cualquier ubicación:

```bash
./install.sh
```

Esto creará un enlace simbólico en `/usr/local/bin` o `~/bin` (según permisos disponibles).

**Nota importante:** El enlace simbólico apunta directamente al archivo original, por lo que cualquier cambio que hagas en el script se reflejará automáticamente al ejecutar el comando. No necesitas reinstalar después de editar el script.

## 🚀 Uso Rápido

El comando `cursor-backup` es un comando unificado que maneja todas las operaciones mediante flags:

### Crear un Backup Completo

```bash
cursor-backup                              # Backup completo en el directorio actual
cursor-backup ~/Documentos/backups         # Backup completo en ubicación personalizada (argumento posicional)
cursor-backup -o ~/Documentos/backups      # Backup completo usando flag -o/--output
```

El backup completo incluye todas las configuraciones y extensiones completas.

### Crear un Backup Público (Sin Información Sensible)

```bash
cursor-backup -p                           # Backup público en el directorio actual
cursor-backup -p ~/backups                 # Backup público en ubicación personalizada (argumento posicional)
cursor-backup -p -o ~/backups              # Backup público usando flag -o/--output
cursor-backup --public --output ~/backups   # Forma larga de los flags
cursor-backup -w                           # También funciona con --without-sensitive-info
```

El backup público incluye:
- ✅ Configuraciones básicas (settings.json, keybindings.json, snippets, tasks.json)
- ✅ Listado de extensiones instaladas (nombre, versión, descripción)
- ❌ NO incluye extensiones completas
- ❌ NO incluye globalStorage (tokens, credenciales)
- ❌ NO incluye workspaceStorage (datos sensibles de proyectos)
- ❌ NO incluye bases de datos de estado

**Ideal para compartir configuraciones sin exponer información sensible.**

### Restaurar un Backup

**⚠️ IMPORTANTE: Cierra Cursor completamente antes de restaurar**

```bash
cursor-backup -r backup.tar.gz              # Restaurar backup (argumento posicional)
cursor-backup -r -f backup.tar.gz           # Restaurar backup usando flag -f/--file
cursor-backup --restore --file backup.tar.gz # Forma larga de los flags
```

### Ver Ayuda

```bash
cursor-backup -h
cursor-backup --help
```

## 📝 Opciones Disponibles

| Flag corto | Flag largo | Descripción |
|------------|------------|-------------|
| `-h` | `--help` | Mostrar ayuda |
| `-r` | `--restore` | Modo restauración |
| `-p` | `--public` | Backup público (sin información sensible) |
| `-w` | `--without-sensitive-info` | Backup público (sin información sensible) |
| `-o` | `--output DIR` | Especificar directorio de destino para el backup |
| `-f` | `--file ARCHIVO` | Especificar archivo de backup para restaurar (solo con -r) |

## 📋 Qué se respalda

### Backup Completo (`cursor-backup`)

**Configuraciones:**
- `settings.json` - Configuraciones del editor
- `keybindings.json` - Atajos de teclado personalizados
- `snippets/` - Fragmentos de código personalizados
- `globalStorage/` - Almacenamiento global de extensiones
- `workspaceStorage/` - Almacenamiento de espacios de trabajo
- `tasks.json` - Tareas personalizadas

**Extensiones:**
- Todas las extensiones instaladas completas con sus configuraciones

### Backup Público (`cursor-backup-public`)

**Configuraciones (solo archivos seguros):**
- `settings.json` - Configuraciones del editor
- `keybindings.json` - Atajos de teclado personalizados
- `snippets/` - Fragmentos de código personalizados
- `tasks.json` - Tareas personalizadas

**Extensiones:**
- Solo listado de extensiones (nombre, editor, versión, descripción)
- NO incluye las extensiones completas

**NO incluye (por seguridad):**
- `globalStorage/` - Puede contener tokens y credenciales
- `workspaceStorage/` - Puede contener datos sensibles de proyectos
- Bases de datos de estado
- Cualquier otra información sensible

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

