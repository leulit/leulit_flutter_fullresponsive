## [1.2.0] - 2024-10-14

### Added
- **🎯 Funciones Multi-Plataforma**: Nuevas funciones globales `w()`, `h()`, y `sp()` que permiten especificar valores diferentes para cada plataforma
- **📱 Detección automática de plataforma**: Sistema inteligente que detecta web, iOS, Android, mobile, tablet, y desktop
- **🔄 Fallbacks inteligentes**: Sistema de fallback que usa `mobile` para iOS/Android, `desktop` para web, etc.
- **⚙️ Flexibilidad total**: Combina valores específicos por plataforma con fallbacks
- Ejemplos de uso multi-plataforma en la documentación
- Tests completos para todas las nuevas funcionalidades

### Enhanced
- Documentación expandida con ejemplos multi-plataforma
- Mejor organización de la API Reference

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
