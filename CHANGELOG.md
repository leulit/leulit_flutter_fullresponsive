# Changelog

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
