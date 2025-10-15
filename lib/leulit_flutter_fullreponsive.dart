import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'core/screen_scaler_inherited_widget.dart';
import 'domain/screen_info.dart';

// Re-export DeviceType para conveniencia del usuario
export 'domain/screen_info.dart' show DeviceType;

// -----------------------------------------------------------------------------
// 1. Widget de Inicialización (Punto de Entrada)
// -----------------------------------------------------------------------------

/// Widget de nivel superior que debe envolver el MaterialApp/CupertinoApp.
/// Lee los datos de MediaQuery y los pasa al InheritedWidget para su propagación.
class ScreenSizeInitializer extends StatelessWidget {
  final Widget child;

  const ScreenSizeInitializer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Lectura directa de MediaQuery.
    final mediaQuery = MediaQuery.of(context);
    
    final double newTextScale = mediaQuery.textScaler.scale(1);
    
    // ⚡ OPTIMIZACIÓN: Calcular DeviceType UNA SOLA VEZ aquí
    final deviceType = _calculateDeviceType(mediaQuery.size.width);
    
    // Creación del objeto inmutable.
    final screenInfo = ScreenInfo(
      width: mediaQuery.size.width,
      height: mediaQuery.size.height,
      textScale: newTextScale,
      deviceType: deviceType,
    );

    // Devolver el propagador con la información.
    return ScreenScalerInheritedWidget(
      info: screenInfo,
      child: child,
    );
  }

  /// ⚡ OPTIMIZACIÓN: Función estática para calcular DeviceType una sola vez
  /// No depende del context, solo de platform y screen width
  static DeviceType _calculateDeviceType(double screenWidth) {
    final platform = defaultTargetPlatform;
    
    // Determinar si es tablet basándose en el tamaño de pantalla
    final isTablet = screenWidth >= 600;
    
    switch (platform) {
      case TargetPlatform.iOS:
        return isTablet ? DeviceType.tablet : DeviceType.ios;
      case TargetPlatform.android:
        return isTablet ? DeviceType.tablet : DeviceType.android;
      case TargetPlatform.fuchsia:
        return isTablet ? DeviceType.tablet : DeviceType.android;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return DeviceType.web;
    }
  }
}

// -----------------------------------------------------------------------------
// 2. Extension Methods para Sintaxis Limpia y Acceso Eficiente
// -----------------------------------------------------------------------------

/// Extensión para usar valores responsive en números.
/// Acepta dos formatos:
/// - Porcentajes tradicionales: 0-100 (ej: 80.w(context) = 80%)
/// - Decimales precisos: 0-1 (ej: 0.8.w(context) = 80%)
/// Ahora con soporte multi-plataforma integrado.
extension ScreenScale on num {
  
  /// Helper para obtener el ScreenInfo de forma segura y eficiente.
  ScreenInfo _getInfo(BuildContext context) {
    final infoWidget = ScreenScalerInheritedWidget.of(context);
    if (infoWidget == null) {
      // Error claro si el inicializador no se usó correctamente.
      throw FlutterError.fromParts([
        ErrorSummary('ScreenScale Error: Missing ScreenSizeInitializer.'),
        ErrorDescription(
          'Debes envolver tu aplicación (ej., el MaterialApp) con el widget '
          'ScreenSizeInitializer para poder usar las extensiones .w(), .h() y .sp().'
        ),
        ErrorHint(
          'Asegúrate de importar: \'package:leulit_flutter_fullresponsive/leulit_flutter_fullresponsive.dart\''
        )
      ]);
    }
    return infoWidget.info;
  }

  /// Helper para normalizar valores: detecta automáticamente si es porcentaje (0-100) o decimal (0-1)
  double _normalizeValue(num value) {
    // Si el valor es <= 1, asumimos que es decimal (0-1)
    // Si es > 1, asumimos que es porcentaje (0-100)
    return value <= 1 ? value.toDouble() : value.toDouble() / 100;
  }

  /// **Ancho Responsive:** Obtiene el ancho como porcentaje de la pantalla.
  /// Acepta valores de 0-100 (ej: 80.w(context)) o 0-1 (ej: 0.8.w(context))
  /// Con soporte multi-plataforma opcional.
  /// 
  /// Ejemplos:
  /// ```dart
  /// // Uso básico
  /// width: 80.w(context)  // 80% del ancho
  /// 
  /// // Multi-plataforma
  /// width: 50.w(context, web: 30, mobile: 80, tablet: 60)
  /// ```
  double w(BuildContext context, {
    num? web,
    num? ios,
    num? android,
    num? mobile,
    num? tablet,
    num? desktop,
  }) {
    final screenInfo = _getInfo(context);
    
    // Si no se especifican parámetros multi-plataforma, usar comportamiento básico
    if (web == null && ios == null && android == null && 
        mobile == null && tablet == null && desktop == null) {
      final normalizedValue = _normalizeValue(this);
      return screenInfo.width * normalizedValue;
    }
    
    // Usar lógica multi-plataforma con 'this' como fallback
    final values = <DeviceType, num>{};
    if (web != null) values[DeviceType.web] = web;
    if (ios != null) values[DeviceType.ios] = ios;
    if (android != null) values[DeviceType.android] = android;
    if (mobile != null) values[DeviceType.mobile] = mobile;
    if (tablet != null) values[DeviceType.tablet] = tablet;
    if (desktop != null) values[DeviceType.desktop] = desktop;
    
    final normalizedValue = _getValueForDevice(screenInfo, values, this);
    return screenInfo.width * normalizedValue;
  }

  /// **Alto Responsive:** Obtiene el alto como porcentaje de la pantalla.
  /// Acepta valores de 0-100 (ej: 30.h(context)) o 0-1 (ej: 0.3.h(context))
  /// Con soporte multi-plataforma opcional.
  /// 
  /// Ejemplos:
  /// ```dart
  /// // Uso básico
  /// height: 30.h(context)  // 30% del alto
  /// 
  /// // Multi-plataforma
  /// height: 25.h(context, web: 20, mobile: 35, tablet: 28)
  /// ```
  double h(BuildContext context, {
    num? web,
    num? ios,
    num? android,
    num? mobile,
    num? tablet,
    num? desktop,
  }) {
    final screenInfo = _getInfo(context);
    
    // Si no se especifican parámetros multi-plataforma, usar comportamiento básico
    if (web == null && ios == null && android == null && 
        mobile == null && tablet == null && desktop == null) {
      final normalizedValue = _normalizeValue(this);
      return screenInfo.height * normalizedValue;
    }
    
    // Usar lógica multi-plataforma con 'this' como fallback
    final values = <DeviceType, num>{};
    if (web != null) values[DeviceType.web] = web;
    if (ios != null) values[DeviceType.ios] = ios;
    if (android != null) values[DeviceType.android] = android;
    if (mobile != null) values[DeviceType.mobile] = mobile;
    if (tablet != null) values[DeviceType.tablet] = tablet;
    if (desktop != null) values[DeviceType.desktop] = desktop;
    
    final normalizedValue = _getValueForDevice(screenInfo, values, this);
    return screenInfo.height * normalizedValue;
  }
  
  /// **Tamaño de Fuente Responsive (sp):** Escala la fuente usando un porcentaje
  /// del ancho base y aplica el factor de escala de accesibilidad del usuario.
  /// Acepta valores de 0-100 (ej: 3.sp(context)) o 0-1 (ej: 0.03.sp(context))
  /// Con soporte multi-plataforma opcional.
  /// 
  /// Ejemplos:
  /// ```dart
  /// // Uso básico
  /// fontSize: 3.sp(context)  // Fuente responsive
  /// 
  /// // Multi-plataforma
  /// fontSize: 3.sp(context, web: 2.5, mobile: 3.5, tablet: 3.2)
  /// ```
  double sp(BuildContext context, {
    num? web,
    num? ios,
    num? android,
    num? mobile,
    num? tablet,
    num? desktop,
  }) {
    final screenInfo = _getInfo(context);
    
    // Si no se especifican parámetros multi-plataforma, usar comportamiento básico
    if (web == null && ios == null && android == null && 
        mobile == null && tablet == null && desktop == null) {
      // Para sp, usamos una base diferente dependiendo del formato
      final double baseSize;
      if (this <= 1) {
        // Si es decimal (0-1), multiplicamos directamente por el ancho
        baseSize = screenInfo.width * this;
      } else {
        // Si es porcentaje (0-100), usamos la lógica original
        baseSize = screenInfo.width * (this / 1000);
      }
      
      return baseSize * screenInfo.textScale;
    }
    
    // Usar lógica multi-plataforma con 'this' como fallback
    final values = <DeviceType, num>{};
    if (web != null) values[DeviceType.web] = web;
    if (ios != null) values[DeviceType.ios] = ios;
    if (android != null) values[DeviceType.android] = android;
    if (mobile != null) values[DeviceType.mobile] = mobile;
    if (tablet != null) values[DeviceType.tablet] = tablet;
    if (desktop != null) values[DeviceType.desktop] = desktop;
    
    final rawValue = _getValueForDevice(screenInfo, values, this);
    
    // Aplicar la misma lógica de escalado que en el modo básico
    final double baseSize;
    if (rawValue <= 1) {
      // Si es decimal (0-1), multiplicamos directamente por el ancho
      baseSize = screenInfo.width * rawValue;
    } else {
      // Si es valor tradicional, usamos la lógica original
      baseSize = screenInfo.width * (rawValue / 1000);
    }
    
    return baseSize * screenInfo.textScale;
  }
}

// -----------------------------------------------------------------------------
// 2.1. Extensiones Especializadas para Casos de Uso Específicos
// -----------------------------------------------------------------------------

/// Extensión para hacer responsive valores de tamaño de iconos, padding, margins, etc.
/// Optimizada para valores numéricos pequeños como sizes de iconos (16, 24, 32, etc.)
extension ResponsiveSize on num {
  
  /// **Tamaño Responsive para Iconos, Padding, Margins:**
  /// Calcula un tamaño responsive basado en el ancho de pantalla.
  /// Optimizado para valores pequeños como icon sizes.
  /// Con soporte multi-plataforma integrado.
  /// 
  /// Ejemplos:
  /// ```dart
  /// // Uso básico
  /// Icon(Icons.star, size: 24.size(context))
  /// 
  /// // Multi-plataforma
  /// Icon(Icons.star, size: 24.size(context, mobile: 20, tablet: 28, desktop: 32))
  /// ```
  double size(BuildContext context, {
    num? web,
    num? ios,
    num? android,
    num? mobile,
    num? tablet,
    num? desktop,
  }) {
    final screenInfo = ScreenScalerInheritedWidget.of(context)?.info;
    if (screenInfo == null) {
      throw FlutterError('ResponsiveSize requiere ScreenSizeInitializer');
    }
    
    // Si no se especifican parámetros multi-plataforma, usar comportamiento básico
    if (web == null && ios == null && android == null && 
        mobile == null && tablet == null && desktop == null) {
      // Base calculation: usa un factor más conservador para elementos UI pequeños
      // Factor base: 2.5% del ancho de pantalla por cada unidad
      return screenInfo.width * (this * 0.025 / 100);
    }
    
    // Usar lógica multi-plataforma con 'this' como fallback
    final values = <DeviceType, num>{};
    if (web != null) values[DeviceType.web] = web;
    if (ios != null) values[DeviceType.ios] = ios;
    if (android != null) values[DeviceType.android] = android;
    if (mobile != null) values[DeviceType.mobile] = mobile;
    if (tablet != null) values[DeviceType.tablet] = tablet;
    if (desktop != null) values[DeviceType.desktop] = desktop;
    
    final normalizedValue = _getValueForDevice(screenInfo, values, this);
    return screenInfo.width * (normalizedValue * 0.025 / 100);
  }
}

/// Extensión para hacer responsive valores de border radius
extension ResponsiveRadius on num {
  
  /// **Border Radius Responsive:**
  /// Calcula un border radius responsive basado en el tamaño de pantalla.
  /// Con soporte multi-plataforma integrado.
  /// 
  /// Ejemplos:
  /// ```dart
  /// // Uso básico
  /// BorderRadius.circular(12.radius(context))
  /// 
  /// // Multi-plataforma
  /// BorderRadius.circular(12.radius(context, mobile: 8, tablet: 16, desktop: 20))
  /// ```
  double radius(BuildContext context, {
    num? web,
    num? ios,
    num? android,
    num? mobile,
    num? tablet,
    num? desktop,
  }) {
    final screenInfo = ScreenScalerInheritedWidget.of(context)?.info;
    if (screenInfo == null) {
      throw FlutterError('ResponsiveRadius requiere ScreenSizeInitializer');
    }
    
    // Si no se especifican parámetros multi-plataforma, usar comportamiento básico
    if (web == null && ios == null && android == null && 
        mobile == null && tablet == null && desktop == null) {
      // Factor base: 1.5% del ancho de pantalla por cada unidad de radius
      return screenInfo.width * (this * 0.015 / 100);
    }
    
    // Usar lógica multi-plataforma con 'this' como fallback
    final values = <DeviceType, num>{};
    if (web != null) values[DeviceType.web] = web;
    if (ios != null) values[DeviceType.ios] = ios;
    if (android != null) values[DeviceType.android] = android;
    if (mobile != null) values[DeviceType.mobile] = mobile;
    if (tablet != null) values[DeviceType.tablet] = tablet;
    if (desktop != null) values[DeviceType.desktop] = desktop;
    
    final normalizedValue = _getValueForDevice(screenInfo, values, this);
    return screenInfo.width * (normalizedValue * 0.015 / 100);
  }
}

/// Extensión para hacer responsive valores de flex en layouts
extension ResponsiveFlex on int {
  
  /// **Flex Value Responsive:**
  /// Ajusta valores de flex basándose en el tipo de dispositivo para mejores layouts.
  /// Con soporte multi-plataforma integrado.
  /// 
  /// Ejemplos:
  /// ```dart
  /// // Uso básico (ajuste automático)
  /// Expanded(flex: 3.flexValue(context), child: widget)
  /// 
  /// // Multi-plataforma (valores específicos)
  /// Expanded(flex: 3.flexValue(context, mobile: 2, tablet: 4, desktop: 5), child: widget)
  /// ```
  int flexValue(BuildContext context, {
    int? web,
    int? ios,
    int? android,
    int? mobile,
    int? tablet,
    int? desktop,
  }) {
    final screenInfo = ScreenScalerInheritedWidget.of(context)?.info;
    if (screenInfo == null) {
      throw FlutterError('ResponsiveFlex requiere ScreenSizeInitializer');
    }
    
    // Si no se especifican parámetros multi-plataforma, usar comportamiento básico
    if (web == null && ios == null && android == null && 
        mobile == null && tablet == null && desktop == null) {
      // Ajuste de flex basado en el tipo de dispositivo
      switch (screenInfo.deviceType) {
        case DeviceType.mobile:
          return this; // Mantener valor original en mobile
        case DeviceType.tablet:
          return (this * 1.2).round(); // Incrementar ligeramente en tablet
        case DeviceType.desktop:
          return (this * 1.5).round(); // Incrementar más en desktop
        default:
          return this;
      }
    }
    
    // Usar lógica multi-plataforma con 'this' como fallback
    switch (screenInfo.deviceType) {
      case DeviceType.web:
        return web ?? desktop ?? this;
      case DeviceType.ios:
        return ios ?? mobile ?? this;
      case DeviceType.android:
        return android ?? mobile ?? this;
      case DeviceType.mobile:
        return mobile ?? this;
      case DeviceType.tablet:
        return tablet ?? this;
      case DeviceType.desktop:
        return desktop ?? web ?? this;
    }
  }
}

// -----------------------------------------------------------------------------
// 3. Helpers para Funcionalidad Multi-Plataforma
// -----------------------------------------------------------------------------

/// Helper para normalizar valores en las funciones multi-plataforma
double _normalizeMultiValue(num value) {
  return value <= 1 ? value.toDouble() : value.toDouble() / 100;
}

/// ⚡ OPTIMIZACIÓN: Helper para obtener el valor apropiado según el dispositivo
/// Usa el DeviceType ya calculado en ScreenInfo (cero overhead adicional)
double _getValueForDevice(
  ScreenInfo screenInfo,
  Map<DeviceType, num> values,
  num fallback,
) {
  final deviceType = screenInfo.deviceType; // ⚡ Ya calculado, acceso O(1)
  
  // Intentar obtener valor específico para el dispositivo
  if (values.containsKey(deviceType)) {
    return _normalizeMultiValue(values[deviceType]!);
  }
  
  // Fallbacks inteligentes
  switch (deviceType) {
    case DeviceType.ios:
    case DeviceType.android:
      // Para móviles específicos, intentar valor 'mobile'
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeMultiValue(values[DeviceType.mobile]!);
      }
      break;
    case DeviceType.web:
      // Para web, intentar valor 'desktop'
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeMultiValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.mobile:
    case DeviceType.tablet:
    case DeviceType.desktop:
      // Estos casos ya se manejan arriba
      break;
  }
  
  // Si no encuentra valor específico, usar el primer valor disponible o fallback
  if (values.isNotEmpty) {
    return _normalizeMultiValue(values.values.first);
  }
  
  return _normalizeMultiValue(fallback);
}
