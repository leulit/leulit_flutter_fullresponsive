# 📦 Script de Publicación Automatizada

Este script automatiza completamente el proceso de publicación de una nueva versión de `leulit_flutter_fullresponsive` tanto en GitHub como en pub.dev.

## 🚀 Uso

```bash
./publish.sh <version>
```

**Ejemplo:**
```bash
./publish.sh 3.0.0
```

## ✅ Lo que hace el script

El script ejecuta automáticamente los siguientes pasos:

### 1️⃣ Validaciones previas
- ✓ Verifica que estás en la rama `main` o `master`
- ✓ Comprueba que no hay cambios sin commitear
- ✓ Valida que la versión en `pubspec.yaml` coincide
- ✓ Verifica que existe entrada en `CHANGELOG.md` para la versión

### 2️⃣ Verificación de calidad
- ✓ Ejecuta análisis estático (`dart analyze`)
- ✓ Verifica formato del código (`dart format`)
- ✓ Ejecuta todos los tests (`flutter test`)
- ✓ Hace dry-run de publicación en pub.dev

### 3️⃣ Publicación
- ✓ Crea un tag de Git con la versión (`v3.0.0`)
- ✓ Pushea cambios y tags a GitHub
- ✓ Publica el paquete en pub.dev

### 4️⃣ Resultado
- ✓ Muestra enlaces a pub.dev y GitHub Release
- ✓ Proporciona instrucciones para crear el GitHub Release

## 📋 Requisitos previos

Antes de ejecutar el script, asegúrate de:

1. **Actualizar `pubspec.yaml`:**
   ```yaml
   version: 3.0.0  # Nueva versión
   ```

2. **Actualizar `CHANGELOG.md`:**
   ```markdown
   ## [3.0.0] - 2024-12-19
   ### Added
   - Nueva funcionalidad X
   ### Changed
   - Cambio Y
   ### Breaking Changes
   - Cambio Z
   ```

3. **Commitear todos los cambios:**
   ```bash
   git add .
   git commit -m "chore: prepare release v3.0.0"
   ```

4. **Estar autenticado en pub.dev:**
   ```bash
   dart pub login
   ```

5. **Tener permisos de escritura en el repositorio de GitHub**

## 🎯 Flujo de trabajo completo

```bash
# 1. Hacer cambios en el código
# ... editar archivos ...

# 2. Ejecutar tests localmente
flutter test

# 3. Actualizar versión en pubspec.yaml
# version: 3.0.0

# 4. Actualizar CHANGELOG.md
# ## [3.0.0] - 2024-12-19
# ### Added
# - Nueva funcionalidad

# 5. Commitear cambios
git add .
git commit -m "chore: prepare release v3.0.0"

# 6. Ejecutar script de publicación
./publish.sh 3.0.0

# 7. Crear GitHub Release (opcional pero recomendado)
# Ir a: https://github.com/leulit/leulit_flutter_fullresponsive/releases/new
# Seleccionar tag: v3.0.0
# Copiar contenido del CHANGELOG.md
# Publicar
```

## ⚠️ Manejo de errores

### Error: "Hay cambios sin commitear"
**Solución:** Commitea todos los cambios primero
```bash
git add .
git commit -m "tu mensaje"
```

### Error: "La versión en pubspec.yaml no coincide"
**Solución:** Actualiza la versión en `pubspec.yaml` al valor correcto

### Error: "Análisis estático falló"
**Solución:** Corrige los errores mostrados por `dart analyze`

### Error: "Tests fallaron"
**Solución:** Corrige los tests que fallaron

### Error: "Dry run de pub publish falló"
**Solución:** Revisa los errores mostrados y corrige el paquete

### Error: "Hubo un error al publicar en pub.dev"
**Importante:** Si esto ocurre, el tag ya fue creado en GitHub. Para reintentar:
```bash
dart pub publish
```

## 🔐 Autenticación

### pub.dev
La primera vez que publiques, necesitarás autenticarte:
```bash
dart pub login
```

Esto abrirá un navegador para que autorices la publicación.

### GitHub
El script usa tu configuración de Git local. Asegúrate de tener:
- SSH key configurada, o
- Credenciales HTTPS configuradas

## 📝 Versionado Semántico

Sigue [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.0.0 → 2.0.0): Cambios que rompen compatibilidad
- **MINOR** (1.0.0 → 1.1.0): Nuevas funcionalidades compatibles
- **PATCH** (1.0.0 → 1.0.1): Correcciones de bugs

**Ejemplos:**
```bash
./publish.sh 3.1.0   # Nueva funcionalidad compatible
./publish.sh 3.0.1   # Corrección de bug
./publish.sh 4.0.0   # Breaking change
```

## 🎨 Personalización

Si necesitas modificar el script para tu flujo de trabajo:

1. El script está en [`publish.sh`](publish.sh)
2. Está bien comentado y modularizado
3. Usa colores para mejor visualización
4. Tiene manejo robusto de errores

## 🆘 Soporte

Si encuentras problemas con el script:

1. Verifica que tienes las herramientas necesarias:
   ```bash
   dart --version
   flutter --version
   git --version
   ```

2. Revisa los mensajes de error del script (son descriptivos)

3. Ejecuta los pasos manualmente para debugging:
   ```bash
   dart analyze
   dart format --set-exit-if-changed .
   flutter test
   dart pub publish --dry-run
   ```

## 📚 Referencias

- [Dart Publishing Packages](https://dart.dev/tools/pub/publishing)
- [Semantic Versioning](https://semver.org/)
- [Git Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github)
