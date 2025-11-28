# 🔄 Cursor Backup Tools

Herramientas para hacer backup y restaurar configuraciones y extensiones de Cursor.

## 📦 Contenido

- `backup_cursor.sh` - Script para crear backups de configuraciones y extensiones
- `restore_cursor.sh` - Script para restaurar desde un backup
- `README.md` - Esta documentación

## 🚀 Uso Rápido

### Crear un Backup

```bash
./backup_cursor.sh
```

El backup se guardará en `~/cursor_backups/` con un nombre que incluye fecha y hora.

### Restaurar un Backup

**⚠️ IMPORTANTE: Cierra Cursor completamente antes de restaurar**

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

Los backups se guardan en `~/cursor_backups/` con la siguiente estructura:

```
cursor_backups/
├── cursor_backup_YYYYMMDD_HHMMSS/
│   ├── User/              (configuraciones)
│   ├── extensions/        (extensiones)
│   └── backup_info.txt    (información del backup)
└── cursor_backup_YYYYMMDD_HHMMSS.tar.gz  (archivo comprimido)
```

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

## 🛠️ Solución de Problemas

### Permisos de ejecución
```bash
chmod +x backup_cursor.sh restore_cursor.sh
```

### Cursor no está cerrado
Asegúrate de cerrar Cursor completamente antes de restaurar, incluyendo todos los procesos en segundo plano.

## 📄 Licencia

Este proyecto es de código abierto y está disponible para uso personal.

