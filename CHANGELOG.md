# Changelog

## [3.0.0] - 2026-02-06

### 🎉 Added - API Multi-Plataforma Moderna
- **Funciones multi-plataforma sin context**: Nueva familia de funciones `rw()`, `rh()`, `rsp()`, etc.
  - `rw()` - Ancho con variaciones por plataforma
  - `rh()` - Alto con variaciones por plataforma
  - `rsp()` - Font size con variaciones por plataforma
  - `rsize()` - Tamaños (padding, icons) con variaciones
  - `rradius()` - Border radius con variaciones
  - `rflexValue()` - Flex values con variaciones

- **Breakpoints personalizados**: Configura tus propios puntos de quiebre
  - `ResponsiveBreakpoints` con valores custom
  - Breakpoints configurables en `ScreenSizeInitializer`
  - DeviceType calculado basado en breakpoints custom

- **Helpers condicionales en ScreenInfo** (sin context):
  - `.isMobile`, `.isTablet`, `.isDesktop`
  - `.isMobileIOS`, `.isMobileAndroid`
  - `.isTabletOrDesktop`
  - `.isPortrait`, `.isLandscape`
  - `.widthBetween()`, `.heightBetween()`
  - `.when<T>()` - Método para valores condicionales

- **Widgets Responsivos**:
  - `ResponsiveWidget` - Renderiza diferentes widgets por dispositivo
  - `ResponsiveBuilder` - Builder con acceso a ScreenInfo para lógica compleja

- **Documentación completa**:
  - `USAGE_EXAMPLES.md` con ejemplos exhaustivos
  - Guías de uso para todos los casos

### ⚠️ BREAKING CHANGES
- **Eliminados todos los métodos deprecated `*WithContext`**
  - `.wWithContext()`, `.hWithContext()`, `.spWithContext()` - ELIMINADOS
  - `.sizeWithContext()`, `.radiusWithContext()`, `.flexValueWithContext()` - ELIMINADOS
  - Usar API simple (`.w`, `.h`, `.sp`) o nueva API multi-plataforma (`rw()`, `rh()`, etc.)

- **Nueva jerarquía de fallbacks**:
  - iOS: `ios` → `mobile` → `tablet` → `desktop`
  - Android: `android` → `mobile` → `tablet` → `desktop`
  - Tablet: `tablet` → `mobile` → `desktop`
  - Web: `web` → `desktop` → `tablet` → `mobile`

### 🔄 Changed
- **ScreenSizeInitializer** ahora acepta `ResponsiveBreakpoints` opcionales
- **Cálculo de DeviceType** mejorado basado en breakpoints personalizados
- **Optimización de rendimiento** en helpers de fallback

### 📖 Documentation
- README.md completamente renovado con nueva API
- USAGE_EXAMPLES.md con casos de uso reales
- Ejemplos de layouts adaptativos, formularios, grids, etc.

### 🔧 Migration from v2.x
```dart
// ❌ v2.x (deprecated - ya no funciona)
Container(
  width: 80.wWithContext(context, tablet: 60, desktop: 50),
  height: 30.hWithContext(context, tablet: 25),
)

// ✅ v3.0 - API simple (sin variaciones)
Container(
  width: 80.w,
  height: 30.h,
)

// ✅ v3.0 - API multi-plataforma (con variaciones)
Container(
  width: rw(mobile: 90, tablet: 70, desktop: 50),
  height: rh(mobile: 40, tablet: 30, desktop: 25),
)
```

## [2.0.0] - 2024-12-28

### 🎉 Added
- **Nueva API sin context**: Ahora todas las extensiones funcionan sin necesidad de pasar `BuildContext`
  - `.w` - Ancho responsive (antes `.w(context)`)
  - `.h` - Alto responsive (antes `.h(context)`)
  - `.sp` - Tamaño de fuente responsive (antes `.sp(context)`)
  - `.size` - Tamaño para iconos/padding (antes `.size(context)`)
  - `.radius` - Border radius responsive (antes `.radius(context)`)
  - `.flexValue` - Valores flex adaptativos (antes `.flexValue(context)`)

- **ScreenInfoManager singleton**: Gestor global que mantiene el `ScreenInfo` accesible sin context
- **MIGRATION_GUIDE.md**: Guía completa de migración de v1.x a v2.0.0

### ⚠️ Deprecated
- Métodos con context renombrados con sufijo `WithContext` (serán eliminados en v3.0.0):
  - `.wWithContext(context, ...)` - Usar `.w` en su lugar
  - `.hWithContext(context, ...)` - Usar `.h` en su lugar
  - `.spWithContext(context, ...)` - Usar `.sp` en su lugar
  - `.sizeWithContext(context, ...)` - Usar `.size` en su lugar
  - `.radiusWithContext(context, ...)` - Usar `.radius` en su lugar
  - `.flexValueWithContext(context, ...)` - Usar `.flexValue` en su lugar

### 🔄 Changed
- La API con parámetros multi-plataforma ahora solo está disponible a través de los métodos `WithContext` (deprecated)
- `ScreenSizeInitializer` ahora actualiza automáticamente el singleton `ScreenInfoManager`

### 📖 Documentation
- README.md actualizado con ejemplos de la nueva API
- Ejemplos en example_usage.dart migrados a la nueva API
- Documentación completa de migración en MIGRATION_GUIDE.md

### 🔧 Technical
- Sin breaking changes en funcionalidad - código anterior sigue funcionando con warnings
- Mejor rendimiento al eliminar la necesidad de acceso al context en cada llamada
- Mantiene compatibilidad hacia atrás con métodos deprecated

## [1.5.1] - 2024-12-19
### Fixed
- **CRITICAL FIX**: Factor de conversión en `.size()` corregido de 0.025% a 0.1%
- **Improved Multi-Platform Detection**: Lógica de fallback mejorada para iOS/Android
- **Added Debug Helpers**: `ResponsiveDebug` class para debugging de valores responsive

### Details
- Valores típicos ahora son visibles: `24.size(context)` produce ~9.6px en iPhone (375px width)
- Parámetros multi-plataforma ahora respetan correctamente la precedencia iOS > mobile > fallback
- Nueva clase `ResponsiveDebug` para diagnosticar problemas de detección de dispositivo

## [1.5.0] - 2024-12-19
### BREAKING CHANGES
- **API Unificada**: Eliminadas todas las funciones globales `w()`, `h()`, `sp()`
- **Extension Methods Unificados**: Todos los métodos `.w()`, `.h()`, `.sp()` ahora aceptan parámetros opcionales multi-plataforma
- **Sintaxis Simplificada**: Un solo patrón de uso para todos los casos: `value.method(context, plataforma: valor)`

### Added
- **Parámetros Multi-Plataforma Unificados**: Todos los extension methods ahora soportan:
  - `web`: Valores específicos para aplicaciones web
  - `ios`: Valores específicos para iOS  
  - `android`: Valores específicos para Android
  - `mobile`: Valores para móviles (iOS + Android)
  - `tablet`: Valores para tablets (>= 600px)
  - `desktop`: Valores para aplicaciones desktop
- **ResponsiveSize Unificado**: `.size()` ahora acepta parámetros multi-plataforma
- **ResponsiveRadius Unificado**: `.radius()` ahora acepta parámetros multi-plataforma  
- **ResponsiveFlex Unificado**: `.flexValue()` ahora acepta parámetros multi-plataforma

### Enhanced
- **Consistencia Total**: Un solo patrón de API para toda la librería
- **Mejor Developer Experience**: IntelliSense más limpio sin funciones globales
- **Precedencia Inteligente**: Plataforma específica > Categoría > Valor base
- **Performance Mantenida**: Misma optimización DeviceType con nueva API

### Removed
- ❌ Funciones globales `w(context, ...)`, `h(context, ...)`, `sp(context, ...)`
- ❌ Métodos `sizeFor()`, `radiusFor()`, `flexFor()` (reemplazados por parámetros opcionales)

### Migration Guide
```dart
// ❌ v1.4.x (API inconsistente)
width: w(context, web: 30, mobile: 80)
width: 50.w(context)
size: 24.sizeFor(context, tablet: 28)

// ✅ v1.5.0 (API unificada)  
width: 50.w(context, web: 30, mobile: 80)
width: 50.w(context)
size: 24.size(context, tablet: 28)
```

## [1.4.1] - 2024-12-19
### Documentation
- **Added Comprehensive Example App**: Complete 4-page demonstration app showcasing all library features
- **Improved pub.dev Score**: Enhanced documentation score from 10/20 to 20/20 with proper examples
- **Example README**: Detailed guide for understanding and using all responsive features
- **Code Samples**: Real-world usage patterns and best practices demonstration

### Example Features
- **Basic Examples**: Fundamental .w(), .h(), .sp() usage patterns
- **Multi-Platform Demo**: Platform-specific responsive implementations  
- **Specialized Extensions**: Complete showcase of ResponsiveSize, ResponsiveRadius, ResponsiveFlex
- **Practical Implementation**: Real dashboard example with complex responsive layouts

## [1.4.0] - 2024-12-19
### Added
- **ResponsiveSize Extension**: Nueva extensión `.size()` para iconos, padding, margins
  - Método `.size(context)` para valores responsive automáticos
  - Método `.sizeFor(context)` para valores específicos por plataforma
- **ResponsiveRadius Extension**: Nueva extensión `.radius()` para border radius
  - Método `.radius(context)` para esquinas redondeadas responsive
  - Método `.radiusFor(context)` para radius específicos por plataforma  
- **ResponsiveFlex Extension**: Nueva extensión `.flexValue()` para layouts flexibles
  - Método `.flexValue(context)` con ajuste automático por tipo de dispositivo
  - Método `.flexFor(context)` para flex específicos por plataforma

### Enhanced
- Casos de uso ampliados: iconos, padding, margins, border radius, flex layouts
- Documentación extendida con ejemplos prácticos de los nuevos casos de uso
- 17 tests total incluyendo las nuevas extensiones

### Examples
- Ejemplos prácticos de iconos responsive en AppBar
- Cards con padding y esquinas responsive
- Layouts con flex values adaptativos
- Botones con estilos completamente responsive

## [1.3.0] - 2024-12-19
### Performance
- **OPTIMIZACIÓN MAYOR**: DeviceType ahora se calcula una sola vez en `ScreenSizeInitializer`
- Eliminada redundancia en cálculo de tipo de dispositivo en funciones multi-plataforma
- Mejora significativa en rendimiento: 1000 llamadas ejecutan en <100ms
- DeviceType ahora se almacena en `ScreenInfo` para acceso inmediato

### Changed
- `_getValueForDevice()` ahora usa `ScreenInfo.deviceType` en lugar de recalcular
- Refactorizada arquitectura para mejor eficiencia en operaciones repetitivas

### Tests
- Añadido test de rendimiento específico para validar optimizaciones
- Verificación automática de que 1000 operaciones se ejecuten bajo 100ms

## [1.2.0] - 2024-12-19
### Added
- Funciones globales `w()`, `h()`, y `sp()` con soporte para múltiples plataformas
- Parámetros específicos por plataforma: `web`, `ios`, `android`, `mobile`, `tablet`, `desktop`
- Sistema de detección automática de dispositivos usando `defaultTargetPlatform`
- Tests exhaustivos para funcionalidad multi-plataforma

### Enhanced
- Mejor cobertura de casos de uso para diferentes tipos de dispositivos
- Documentación actualizada con ejemplos de uso multi-plataforma

## [1.1.0] - 2024-12-19

## [1.1.0] - 2024-10-14

### Added
- **🎯 Doble formato de valores**: Ahora soporta tanto valores tradicionales (0-100) como decimales (0-1)
- **📏 Ultra precisión**: Posibilidad de usar valores como `0.076543.w(context)` para dimensiones exactas
- **🔄 Detección automática**: El sistema detecta automáticamente si usas formato porcentaje o decimal
- Nuevos tests unitarios para validar ambos formatos
- Documentación actualizada con ejemplos de ambos formatos

### Enhanced
- Extension methods `.w()`, `.h()`, y `.sp()` ahora aceptan valores decimales para mayor precisión
- Mejor documentación con ejemplos de uso avanzado

## [1.0.0] - 2024-10-14

### Added
- Librería agnóstica de alto rendimiento para responsividad usando InheritedWidget y Extension Methods
- Widget `ScreenSizeInitializer` para inicializar el sistema de responsividad
- Extension methods `.w()`, `.h()`, y `.sp()` para dimensiones responsive
- Soporte completo para accesibilidad con respeto a la configuración de escala de texto del usuario
- API type-safe aprovechando null safety de Dart
- Documentación completa con ejemplos de uso
- Tests unitarios incluidos
