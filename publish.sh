#!/bin/bash

# Script para publicar una nueva versión en GitHub y pub.dev
# Uso: ./publish.sh [version]
# Ejemplo: ./publish.sh 3.0.0

set -e  # Salir si cualquier comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Banner
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Leulit Flutter Full Responsive Publisher ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo ""

# Verificar que se pasó la versión
if [ -z "$1" ]; then
    print_error "Debes proporcionar un número de versión"
    echo "Uso: ./publish.sh [version]"
    echo "Ejemplo: ./publish.sh 3.0.0"
    exit 1
fi

VERSION=$1
print_info "Preparando publicación de versión: v$VERSION"
echo ""

# Verificar que estamos en la rama correcta
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    print_warning "No estás en la rama main/master (estás en: $CURRENT_BRANCH)"
    read -p "¿Deseas continuar de todas formas? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Publicación cancelada"
        exit 1
    fi
fi

# 1. Verificar que no hay cambios sin commitear
print_info "Verificando estado del repositorio..."
if [[ -n $(git status -s) ]]; then
    print_error "Hay cambios sin commitear. Commitea tus cambios antes de publicar."
    git status -s
    exit 1
fi
print_success "Repositorio limpio"
echo ""

# 2. Verificar que la versión en pubspec.yaml coincide
print_info "Verificando versión en pubspec.yaml..."
PUBSPEC_VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
if [ "$PUBSPEC_VERSION" != "$VERSION" ]; then
    print_error "La versión en pubspec.yaml ($PUBSPEC_VERSION) no coincide con la versión solicitada ($VERSION)"
    echo "Por favor actualiza pubspec.yaml antes de continuar."
    exit 1
fi
print_success "Versión coincide: v$VERSION"
echo ""

# 3. Verificar que el CHANGELOG.md tiene entrada para esta versión
print_info "Verificando CHANGELOG.md..."
if ! grep -q "\[$VERSION\]" CHANGELOG.md; then
    print_warning "No se encontró entrada para v$VERSION en CHANGELOG.md"
    read -p "¿Deseas continuar de todas formas? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Publicación cancelada"
        exit 1
    fi
else
    print_success "CHANGELOG.md actualizado"
fi
echo ""

# 4. Ejecutar análisis estático
print_info "Ejecutando análisis estático (dart analyze)..."
if ! dart analyze; then
    print_error "Análisis estático falló. Corrige los errores antes de publicar."
    exit 1
fi
print_success "Análisis estático pasó"
echo ""

# 5. Ejecutar formato
print_info "Verificando formato del código (dart format)..."
if ! dart format --set-exit-if-changed .; then
    print_warning "Hay archivos sin formatear. Formateando..."
    dart format .
    git add .
    git commit -m "style: format code for v$VERSION"
    print_success "Código formateado y commiteado"
else
    print_success "Código correctamente formateado"
fi
echo ""

# 6. Ejecutar tests
print_info "Ejecutando tests (flutter test)..."
if ! flutter test; then
    print_error "Tests fallaron. Corrige los tests antes de publicar."
    exit 1
fi
print_success "Todos los tests pasaron"
echo ""

# 7. Dry run de publicación en pub.dev
print_info "Verificando paquete para pub.dev (dry run)..."
if ! dart pub publish --dry-run; then
    print_error "Dry run de pub publish falló. Revisa los errores."
    exit 1
fi
print_success "Paquete listo para pub.dev"
echo ""

# 8. Confirmar con el usuario
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo -e "${YELLOW}Resumen de publicación:${NC}"
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo "  📦 Paquete: leulit_flutter_fullresponsive"
echo "  🏷️  Versión: v$VERSION"
echo "  🌿 Rama: $CURRENT_BRANCH"
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo ""
read -p "¿Confirmas la publicación? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Publicación cancelada por el usuario"
    exit 1
fi
echo ""

# 9. Crear tag de Git
print_info "Creando tag de Git: v$VERSION..."
if git tag -a "v$VERSION" -m "Release v$VERSION"; then
    print_success "Tag v$VERSION creado"
else
    print_warning "Tag v$VERSION ya existe, continuando..."
fi
echo ""

# 10. Push a GitHub
print_info "Pusheando cambios y tags a GitHub..."
git push origin "$CURRENT_BRANCH"
git push origin "v$VERSION"
print_success "Cambios pusheados a GitHub"
echo ""

# 11. Publicar en pub.dev
print_info "Publicando en pub.dev..."
print_warning "Se abrirá un navegador para autorizar la publicación en pub.dev"
echo ""
if dart pub publish; then
    print_success "¡Paquete publicado exitosamente en pub.dev!"
else
    print_error "Hubo un error al publicar en pub.dev"
    print_warning "El tag ya fue creado en GitHub. Si necesitas reintentar:"
    echo "  1. Resuelve el error"
    echo "  2. Ejecuta manualmente: dart pub publish"
    exit 1
fi
echo ""

# 12. Éxito
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  🎉 ¡PUBLICACIÓN EXITOSA! 🎉           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✨ La versión v$VERSION ha sido publicada exitosamente${NC}"
echo ""
echo "📦 Pub.dev: https://pub.dev/packages/leulit_flutter_fullresponsive"
echo "🏷️  GitHub Release: https://github.com/leulit/leulit_flutter_fullresponsive/releases/tag/v$VERSION"
echo ""
print_info "Próximos pasos recomendados:"
echo "  1. Crea un GitHub Release en: https://github.com/leulit/leulit_flutter_fullresponsive/releases/new"
echo "  2. Selecciona el tag: v$VERSION"
echo "  3. Copia el contenido del CHANGELOG.md para esta versión"
echo "  4. Publica el Release"
echo ""

exit 0
