import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'core/screen_scaler_inherited_widget.dart';
import 'domain/screen_info.dart';

// Re-export DeviceType para conveniencia del usuario
export 'domain/screen_info.dart' show DeviceType;

// -----------------------------------------------------------------------------
// SINGLETON MANAGER (Para API sin context)
// -----------------------------------------------------------------------------

/// Gestor singleton que mantiene el ScreenInfo globalmente accesible.
/// Permite usar las extensiones sin necesidad de pasar el BuildContext.
/// Se actualiza automáticamente cuando cambia el tamaño de pantalla.
class ScreenInfoManager {
  static final ScreenInfoManager _instance = ScreenInfoManager._internal();
  factory ScreenInfoManager() => _instance;
  ScreenInfoManager._internal();
  
  ScreenInfo? _screenInfo;
  
  /// Obtiene el ScreenInfo actual. Lanza un error si no se ha inicializado.
  ScreenInfo get info {
    if (_screenInfo == null) {
      throw FlutterError.fromParts([
        ErrorSummary('ScreenInfoManager Error: Not initialized.'),
        ErrorDescription(
          'Debes envolver tu aplicación con ScreenSizeInitializer antes de usar '
          'las extensiones sin context (.w, .h, .sp, etc.).'
        ),
        ErrorHint(
          'Ejemplo: ScreenSizeInitializer(child: MaterialApp(...))'
        )
      ]);
    }
    return _screenInfo!;
  }
  
  /// Actualiza el ScreenInfo. Solo debe ser llamado por ScreenSizeInitializer.
  void updateInfo(ScreenInfo newInfo) {
    _screenInfo = newInfo;
  }
  
  /// Verifica si el manager ha sido inicializado.
  bool get isInitialized => _screenInfo != null;
}

// -----------------------------------------------------------------------------
// DEBUG HELPERS
// -----------------------------------------------------------------------------

/// Helper de debug para verificar qué está detectando la librería
class ResponsiveDebug {
  /// Obtiene información de debug sobre el dispositivo actual
  static Map<String, dynamic> getDeviceInfo(BuildContext context) {
    final screenInfo = ScreenScalerInheritedWidget.of(context)?.info;
    if (screenInfo == null) {
      return {'error': 'ScreenSizeInitializer no encontrado'};
    }
    
    return {
      'deviceType': screenInfo.deviceType.toString(),
      'width': screenInfo.width,
      'height': screenInfo.height,
      'textScale': screenInfo.textScale,
      'platform': defaultTargetPlatform.toString(),
    };
  }
  
  /// Calcula qué valor se usaría para una configuración específica
  static double debugSizeValue(BuildContext context, num baseValue, {
    num? web,
    num? ios,
    num? android, 
    num? mobile,
    num? tablet,
    num? desktop,
  }) {
    final screenInfo = ScreenScalerInheritedWidget.of(context)?.info;
    if (screenInfo == null) return -1;
    
    final values = <DeviceType, num>{};
    if (web != null) values[DeviceType.web] = web;
    if (ios != null) values[DeviceType.ios] = ios;
    if (android != null) values[DeviceType.android] = android;
    if (mobile != null) values[DeviceType.mobile] = mobile;
    if (tablet != null) values[DeviceType.tablet] = tablet;
    if (desktop != null) values[DeviceType.desktop] = desktop;
    
    final directValue = _getDirectValueForDevice(screenInfo, values, baseValue);
    return screenInfo.width * (directValue * 0.1 / 100);
  }
}

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

    // ⚡ ACTUALIZAR SINGLETON para API sin context
    ScreenInfoManager().updateInfo(screenInfo);

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

  /// **Ancho Responsive (sin context):** Obtiene el ancho como porcentaje de la pantalla.
  /// Acepta valores de 0-100 (ej: 80.w) o 0-1 (ej: 0.8.w)
  /// 
  /// Ejemplos:
  /// ```dart
  /// // Uso básico
  /// width: 80.w  // 80% del ancho
  /// width: 0.8.w  // Equivalente usando decimales
  /// ```
  double get w {
    final screenInfo = ScreenInfoManager().info;
    final normalizedValue = _normalizeValue(this);
    return screenInfo.width * normalizedValue;
  }
  
  /// **Ancho Responsive (DEPRECATED):** Usa `.w` en su lugar (sin context).
  /// 
  /// Esta versión con context será eliminada en futuras versiones.
  /// Migra tu código a usar `.w` directamente sin pasar context.
  @Deprecated('Usa .w en su lugar (sin context). Será eliminado en v3.0.0')
  double wWithContext(BuildContext context, {
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

  /// **Alto Responsive (sin context):** Obtiene el alto como porcentaje de la pantalla.
  /// Acepta valores de 0-100 (ej: 30.h) o 0-1 (ej: 0.3.h)
  /// 
  /// Ejemplos:
  /// ```dart
  /// // Uso básico
  /// height: 30.h  // 30% del alto
  /// height: 0.3.h  // Equivalente usando decimales
  /// ```
  double get h {
    final screenInfo = ScreenInfoManager().info;
    final normalizedValue = _normalizeValue(this);
    return screenInfo.height * normalizedValue;
  }
  
  /// **Alto Responsive (DEPRECATED):** Usa `.h` en su lugar (sin context).
  /// 
  /// Esta versión con context será eliminada en futuras versiones.
  /// Migra tu código a usar `.h` directamente sin pasar context.
  @Deprecated('Usa .h en su lugar (sin context). Será eliminado en v3.0.0')
  double hWithContext(BuildContext context, {
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
  
  /// **Tamaño de Fuente Responsive (sin context):** Escala la fuente usando un porcentaje
  /// del ancho base y aplica el factor de escala de accesibilidad del usuario.
  /// Acepta valores de 0-100 (ej: 3.sp) o 0-1 (ej: 0.03.sp)
  /// 
  /// Ejemplos:
  /// ```dart
  /// // Uso básico
  /// fontSize: 3.sp  // Fuente responsive
  /// fontSize: 0.03.sp  // Equivalente usando decimales
  /// ```
  double get sp {
    final screenInfo = ScreenInfoManager().info;
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
  
  /// **Tamaño de Fuente Responsive (DEPRECATED):** Usa `.sp` en su lugar (sin context).
  /// 
  /// Esta versión con context será eliminada en futuras versiones.
  /// Migra tu código a usar `.sp` directamente sin pasar context.
  @Deprecated('Usa .sp en su lugar (sin context). Será eliminado en v3.0.0')
  double spWithContext(BuildContext context, {
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
  
  /// **Tamaño Responsive (sin context):** Calcula un tamaño responsive basado en el ancho de pantalla.
  /// Optimizado para valores pequeños como icon sizes, padding, margins.
  /// 
  /// Ejemplos:
  /// ```dart
  /// Icon(Icons.star, size: 24.size)
  /// padding: EdgeInsets.all(16.size)
  /// ```
  double get size {
    final screenInfo = ScreenInfoManager().info;
    // Factor base: 0.1% del ancho de pantalla por cada unidad
    return screenInfo.width * (this * 0.1 / 100);
  }
  
  /// **Tamaño Responsive (DEPRECATED):** Usa `.size` en su lugar (sin context).
  /// 
  /// Esta versión con context será eliminada en futuras versiones.
  /// Migra tu código a usar `.size` directamente sin pasar context.
  @Deprecated('Usa .size en su lugar (sin context). Será eliminado en v3.0.0')
  double sizeWithContext(BuildContext context, {
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
      // Base calculation: factor ajustado para que valores típicos (16, 24, 32) sean visibles
      // Factor base: 0.1% del ancho de pantalla por cada unidad (mucho más visible)
      return screenInfo.width * (this * 0.1 / 100);
    }
    
    // Usar lógica multi-plataforma con 'this' como fallback
    final values = <DeviceType, num>{};
    if (web != null) values[DeviceType.web] = web;
    if (ios != null) values[DeviceType.ios] = ios;
    if (android != null) values[DeviceType.android] = android;
    if (mobile != null) values[DeviceType.mobile] = mobile;
    if (tablet != null) values[DeviceType.tablet] = tablet;
    if (desktop != null) values[DeviceType.desktop] = desktop;
    
    final directValue = _getDirectValueForDevice(screenInfo, values, this);
    return screenInfo.width * (directValue * 0.1 / 100);
  }
}

/// Extensión para hacer responsive valores de border radius
extension ResponsiveRadius on num {
  
  /// **Border Radius Responsive (sin context):** Calcula un border radius responsive.
  /// 
  /// Ejemplos:
  /// ```dart
  /// BorderRadius.circular(12.radius)
  /// borderRadius: BorderRadius.circular(8.radius)
  /// ```
  double get radius {
    final screenInfo = ScreenInfoManager().info;
    // Factor base: 1.5% del ancho de pantalla por cada unidad de radius
    return screenInfo.width * (this * 0.015 / 100);
  }
  
  /// **Border Radius Responsive (DEPRECATED):** Usa `.radius` en su lugar (sin context).
  /// 
  /// Esta versión con context será eliminada en futuras versiones.
  /// Migra tu código a usar `.radius` directamente sin pasar context.
  @Deprecated('Usa .radius en su lugar (sin context). Será eliminado en v3.0.0')
  double radiusWithContext(BuildContext context, {
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
  
  /// **Flex Value Responsive (sin context):** Ajusta valores de flex según el dispositivo.
  /// 
  /// Ejemplos:
  /// ```dart
  /// Expanded(flex: 3.flexValue, child: widget)
  /// ```
  int get flexValue {
    final screenInfo = ScreenInfoManager().info;
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
  
  /// **Flex Value Responsive (DEPRECATED):** Usa `.flexValue` en su lugar (sin context).
  /// 
  /// Esta versión con context será eliminada en futuras versiones.
  /// Migra tu código a usar `.flexValue` directamente sin pasar context.
  @Deprecated('Usa .flexValue en su lugar (sin context). Será eliminado en v3.0.0')
  int flexValueWithContext(BuildContext context, {
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

/// Helper para normalizar valores en las funciones multi-plataforma (w, h, sp)
double _normalizeMultiValue(num value) {
  return value <= 1 ? value.toDouble() : value.toDouble() / 100;
}

/// Helper específico para size() - NO normaliza, usa valores directos
double _normalizeDirectValue(num value) {
  return value.toDouble(); // Sin normalización - valores directos
}

/// ⚡ OPTIMIZACIÓN: Helper para obtener el valor apropiado según el dispositivo
/// Usa el DeviceType ya calculado en ScreenInfo (cero overhead adicional)
double _getValueForDevice(
  ScreenInfo screenInfo,
  Map<DeviceType, num> values,
  num fallback,
) {
  final deviceType = screenInfo.deviceType; // ⚡ Ya calculado, acceso O(1)
  
  // PRIORIDAD 1: Intentar obtener valor específico para el deviceType exacto
  if (values.containsKey(deviceType)) {
    return _normalizeMultiValue(values[deviceType]!);
  }
  
  // PRIORIDAD 2: Fallbacks inteligentes basados en jerarquía de tipos
  switch (deviceType) {
    case DeviceType.ios:
      // iOS: prioridad ios > mobile > fallback
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeMultiValue(values[DeviceType.mobile]!);
      }
      break;
    case DeviceType.android:
      // Android: prioridad android > mobile > fallback
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeMultiValue(values[DeviceType.mobile]!);
      }
      break;
    case DeviceType.web:
      // Web: prioridad web > desktop > fallback
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeMultiValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.tablet:
      // Tablet: prioridad tablet > mobile > fallback
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeMultiValue(values[DeviceType.mobile]!);
      }
      break;
    case DeviceType.mobile:
    case DeviceType.desktop:
      // Estos casos ya se manejan en PRIORIDAD 1
      break;
  }
  
  // PRIORIDAD 3: Si no se encuentra valor específico, usar fallback directamente
  return _normalizeMultiValue(fallback);
}

/// Helper especializado para size() - valores directos sin normalización
double _getDirectValueForDevice(
  ScreenInfo screenInfo,
  Map<DeviceType, num> values,
  num fallback,
) {
  final deviceType = screenInfo.deviceType; // ⚡ Ya calculado, acceso O(1)
  
  // PRIORIDAD 1: Intentar obtener valor específico para el deviceType exacto
  if (values.containsKey(deviceType)) {
    return _normalizeDirectValue(values[deviceType]!);
  }
  
  // PRIORIDAD 2: Fallbacks inteligentes basados en jerarquía de tipos
  switch (deviceType) {
    case DeviceType.ios:
      // iOS: prioridad ios > mobile > fallback
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeDirectValue(values[DeviceType.mobile]!);
      }
      break;
    case DeviceType.android:
      // Android: prioridad android > mobile > fallback
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeDirectValue(values[DeviceType.mobile]!);
      }
      break;
    case DeviceType.web:
      // Web: prioridad web > desktop > fallback
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeDirectValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.tablet:
      // Tablet: prioridad tablet > mobile > fallback
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeDirectValue(values[DeviceType.mobile]!);
      }
      break;
    case DeviceType.mobile:
    case DeviceType.desktop:
      // Estos casos ya se manejan en PRIORIDAD 1
      break;
  }
  
  // PRIORIDAD 3: Si no se encuentra valor específico, usar fallback directamente
  return _normalizeDirectValue(fallback);
}
