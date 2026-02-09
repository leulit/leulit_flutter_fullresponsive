import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'core/screen_scaler_inherited_widget.dart';
import 'domain/screen_info.dart';

// Re-export para conveniencia del usuario
export 'domain/screen_info.dart' show DeviceType, ResponsiveBreakpoints;

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
            'las extensiones sin context (.w, .h, .sp, etc.).'),
        ErrorHint('Ejemplo: ScreenSizeInitializer(child: MaterialApp(...))')
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
  static double debugSizeValue(
    BuildContext context,
    num baseValue, {
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

    // Si no hay valores específicos, usar baseValue como mobile
    if (values.isEmpty) {
      values[DeviceType.mobile] = baseValue;
    }

    final directValue = _getDirectValueForDevice(screenInfo, values);
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
  final ResponsiveBreakpoints breakpoints;

  const ScreenSizeInitializer({
    super.key,
    required this.child,
    this.breakpoints = const ResponsiveBreakpoints(),
  });

  @override
  Widget build(BuildContext context) {
    // Lectura directa de MediaQuery.
    final mediaQuery = MediaQuery.of(context);

    final double newTextScale = mediaQuery.textScaler.scale(1);

    // ⚡ OPTIMIZACIÓN: Calcular DeviceType UNA SOLA VEZ aquí basado en breakpoints
    final deviceType = _calculateDeviceType(mediaQuery.size.width, breakpoints);

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
  /// Usa breakpoints personalizados y platform para determinar el tipo
  static DeviceType _calculateDeviceType(
    double screenWidth,
    ResponsiveBreakpoints breakpoints,
  ) {
    final platform = defaultTargetPlatform;

    // Determinar el tipo de dispositivo basado en breakpoints
    final bool isDesktopSize = screenWidth >= breakpoints.desktop;
    final bool isTabletSize =
        screenWidth >= breakpoints.tablet && screenWidth < breakpoints.desktop;

    // Para plataformas desktop, siempre usar web/desktop
    if (platform == TargetPlatform.linux ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows) {
      return DeviceType.web;
    }

    // Para plataformas móviles, usar breakpoints para determinar si es tablet
    if (isDesktopSize) {
      return DeviceType.desktop;
    } else if (isTabletSize) {
      return DeviceType.tablet;
    } else {
      // Mobile size - diferenciar entre iOS y Android
      switch (platform) {
        case TargetPlatform.iOS:
          return DeviceType.ios;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          return DeviceType.android;
        default:
          return DeviceType.mobile;
      }
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
  ///
  /// // Para variaciones multi-plataforma, usa rw()
  /// width: rw(mobile: 90, tablet: 70, desktop: 50)
  /// ```
  double get w {
    final screenInfo = ScreenInfoManager().info;
    final normalizedValue = _normalizeValue(this);
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
  ///
  /// // Para variaciones multi-plataforma, usa rh()
  /// height: rh(mobile: 40, tablet: 30, desktop: 25)
  /// ```
  double get h {
    final screenInfo = ScreenInfoManager().info;
    final normalizedValue = _normalizeValue(this);
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
  ///
  /// // Para variaciones multi-plataforma, usa rsp()
  /// fontSize: rsp(mobile: 16, tablet: 14, desktop: 12)
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
  ///
  /// // Para variaciones multi-plataforma, usa rsize()
  /// padding: EdgeInsets.all(rsize(mobile: 16, tablet: 20, desktop: 24))
  /// ```
  double get size {
    final screenInfo = ScreenInfoManager().info;
    // Factor base: 0.1% del ancho de pantalla por cada unidad
    return screenInfo.width * (this * 0.1 / 100);
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
  ///
  /// // Para variaciones multi-plataforma, usa rradius()
  /// borderRadius: BorderRadius.circular(rradius(mobile: 12, desktop: 8))
  /// ```
  double get radius {
    final screenInfo = ScreenInfoManager().info;
    // Factor base: 1.5% del ancho de pantalla por cada unidad de radius
    return screenInfo.width * (this * 0.015 / 100);
  }
}

/// Extensión para hacer responsive valores de flex en layouts
extension ResponsiveFlex on int {
  /// **Flex Value Responsive (sin context):** Ajusta valores de flex según el dispositivo.
  ///
  /// Ejemplos:
  /// ```dart
  /// Expanded(flex: 3.flexValue, child: widget)
  ///
  /// // Para variaciones multi-plataforma, usa rflexValue()
  /// Expanded(flex: rflexValue(mobile: 2, tablet: 3, desktop: 4), child: widget)
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
}

// -----------------------------------------------------------------------------
// 2.2. Funciones Multi-Plataforma (sin context)
// -----------------------------------------------------------------------------

/// **Ancho Responsive con variaciones por plataforma:**
/// Calcula el ancho como porcentaje de pantalla con valores específicos por dispositivo.
///
/// Ejemplos:
/// ```dart
/// Container(
///   width: rw(mobile: 90, tablet: 70, desktop: 50),
///   child: ...,
/// )
///
/// // Con plataformas específicas
/// width: rw(ios: 95, android: 90, tablet: 70, web: 50)
/// ```
double rw({
  num? mobile,
  num? tablet,
  num? desktop,
  num? ios,
  num? android,
  num? web,
}) {
  final screenInfo = ScreenInfoManager().info;
  final values = <DeviceType, num>{};

  if (mobile != null) values[DeviceType.mobile] = mobile;
  if (tablet != null) values[DeviceType.tablet] = tablet;
  if (desktop != null) values[DeviceType.desktop] = desktop;
  if (ios != null) values[DeviceType.ios] = ios;
  if (android != null) values[DeviceType.android] = android;
  if (web != null) values[DeviceType.web] = web;

  if (values.isEmpty) {
    throw FlutterError('rw() requiere al menos un valor de plataforma');
  }

  final normalizedValue = _getValueForDevice(screenInfo, values);
  return screenInfo.width * normalizedValue;
}

/// **Alto Responsive con variaciones por plataforma:**
/// Calcula el alto como porcentaje de pantalla con valores específicos por dispositivo.
///
/// Ejemplos:
/// ```dart
/// Container(
///   height: rh(mobile: 30, tablet: 25, desktop: 20),
///   child: ...,
/// )
/// ```
double rh({
  num? mobile,
  num? tablet,
  num? desktop,
  num? ios,
  num? android,
  num? web,
}) {
  final screenInfo = ScreenInfoManager().info;
  final values = <DeviceType, num>{};

  if (mobile != null) values[DeviceType.mobile] = mobile;
  if (tablet != null) values[DeviceType.tablet] = tablet;
  if (desktop != null) values[DeviceType.desktop] = desktop;
  if (ios != null) values[DeviceType.ios] = ios;
  if (android != null) values[DeviceType.android] = android;
  if (web != null) values[DeviceType.web] = web;

  if (values.isEmpty) {
    throw FlutterError('rh() requiere al menos un valor de plataforma');
  }

  final normalizedValue = _getValueForDevice(screenInfo, values);
  return screenInfo.height * normalizedValue;
}

/// **Font Size Responsive con variaciones por plataforma:**
/// Calcula el tamaño de fuente con valores específicos por dispositivo.
///
/// Ejemplos:
/// ```dart
/// Text(
///   'Hola',
///   style: TextStyle(
///     fontSize: rsp(mobile: 16, tablet: 14, desktop: 12),
///   ),
/// )
/// ```
double rsp({
  num? mobile,
  num? tablet,
  num? desktop,
  num? ios,
  num? android,
  num? web,
}) {
  final screenInfo = ScreenInfoManager().info;
  final values = <DeviceType, num>{};

  if (mobile != null) values[DeviceType.mobile] = mobile;
  if (tablet != null) values[DeviceType.tablet] = tablet;
  if (desktop != null) values[DeviceType.desktop] = desktop;
  if (ios != null) values[DeviceType.ios] = ios;
  if (android != null) values[DeviceType.android] = android;
  if (web != null) values[DeviceType.web] = web;

  if (values.isEmpty) {
    throw FlutterError('rsp() requiere al menos un valor de plataforma');
  }

  final rawValue = _getValueForDevice(screenInfo, values);

  // Aplicar la misma lógica de escalado que .sp
  final double baseSize;
  if (rawValue <= 1) {
    baseSize = screenInfo.width * rawValue;
  } else {
    baseSize = screenInfo.width * (rawValue / 1000);
  }

  return baseSize * screenInfo.textScale;
}

/// **Size Responsive con variaciones por plataforma:**
/// Calcula tamaños (padding, margin, icon size) con valores específicos por dispositivo.
///
/// Ejemplos:
/// ```dart
/// Icon(
///   Icons.star,
///   size: rsize(mobile: 24, tablet: 28, desktop: 32),
/// )
///
/// padding: EdgeInsets.all(rsize(mobile: 16, tablet: 20, desktop: 24))
/// ```
double rsize({
  num? mobile,
  num? tablet,
  num? desktop,
  num? ios,
  num? android,
  num? web,
}) {
  final screenInfo = ScreenInfoManager().info;
  final values = <DeviceType, num>{};

  if (mobile != null) values[DeviceType.mobile] = mobile;
  if (tablet != null) values[DeviceType.tablet] = tablet;
  if (desktop != null) values[DeviceType.desktop] = desktop;
  if (ios != null) values[DeviceType.ios] = ios;
  if (android != null) values[DeviceType.android] = android;
  if (web != null) values[DeviceType.web] = web;

  if (values.isEmpty) {
    throw FlutterError('rsize() requiere al menos un valor de plataforma');
  }

  final directValue = _getDirectValueForDevice(screenInfo, values);
  return screenInfo.width * (directValue * 0.1 / 100);
}

/// **Border Radius Responsive con variaciones por plataforma:**
/// Calcula border radius con valores específicos por dispositivo.
///
/// Ejemplos:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: BorderRadius.circular(
///       rradius(mobile: 12, tablet: 10, desktop: 8),
///     ),
///   ),
/// )
/// ```
double rradius({
  num? mobile,
  num? tablet,
  num? desktop,
  num? ios,
  num? android,
  num? web,
}) {
  final screenInfo = ScreenInfoManager().info;
  final values = <DeviceType, num>{};

  if (mobile != null) values[DeviceType.mobile] = mobile;
  if (tablet != null) values[DeviceType.tablet] = tablet;
  if (desktop != null) values[DeviceType.desktop] = desktop;
  if (ios != null) values[DeviceType.ios] = ios;
  if (android != null) values[DeviceType.android] = android;
  if (web != null) values[DeviceType.web] = web;

  if (values.isEmpty) {
    throw FlutterError('rradius() requiere al menos un valor de plataforma');
  }

  final directValue = _getDirectValueForDevice(screenInfo, values);
  return screenInfo.width * (directValue * 0.015 / 100);
}

/// **Flex Value Responsive con variaciones por plataforma:**
/// Calcula valores de flex con valores específicos por dispositivo.
///
/// Ejemplos:
/// ```dart
/// Expanded(
///   flex: rflexValue(mobile: 2, tablet: 3, desktop: 4),
///   child: widget,
/// )
/// ```
int rflexValue({
  int? mobile,
  int? tablet,
  int? desktop,
  int? ios,
  int? android,
  int? web,
}) {
  final screenInfo = ScreenInfoManager().info;

  // Usar fallbacks inteligentes
  switch (screenInfo.deviceType) {
    case DeviceType.ios:
      return ios ?? mobile ?? tablet ?? desktop ?? 1;
    case DeviceType.android:
      return android ?? mobile ?? tablet ?? desktop ?? 1;
    case DeviceType.mobile:
      return mobile ?? tablet ?? desktop ?? 1;
    case DeviceType.tablet:
      return tablet ?? mobile ?? desktop ?? 1;
    case DeviceType.desktop:
      return desktop ?? tablet ?? mobile ?? 1;
    case DeviceType.web:
      return web ?? desktop ?? tablet ?? mobile ?? 1;
  }
}

// -----------------------------------------------------------------------------
// 2.3. Widgets Responsivos
// -----------------------------------------------------------------------------

/// Widget que renderiza diferentes layouts según el tipo de dispositivo.
///
/// Ejemplos:
/// ```dart
/// ResponsiveWidget(
///   mobile: MobileLayout(),
///   tablet: TabletLayout(),
///   desktop: DesktopLayout(),
/// )
///
/// // Con fallback
/// ResponsiveWidget(
///   mobile: MobileLayout(),
///   desktop: DesktopLayout(),
///   // tablet usará mobile como fallback
/// )
/// ```
class ResponsiveWidget extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? ios;
  final Widget? android;
  final Widget? web;

  const ResponsiveWidget({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.ios,
    this.android,
    this.web,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = ScreenInfoManager().info;

    switch (screenInfo.deviceType) {
      case DeviceType.ios:
        return ios ?? mobile ?? tablet ?? desktop ?? const SizedBox.shrink();
      case DeviceType.android:
        return android ??
            mobile ??
            tablet ??
            desktop ??
            const SizedBox.shrink();
      case DeviceType.mobile:
        return mobile ?? tablet ?? desktop ?? const SizedBox.shrink();
      case DeviceType.tablet:
        return tablet ?? mobile ?? desktop ?? const SizedBox.shrink();
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile ?? const SizedBox.shrink();
      case DeviceType.web:
        return web ?? desktop ?? tablet ?? mobile ?? const SizedBox.shrink();
    }
  }
}

/// Builder que proporciona el ScreenInfo actual para construir widgets responsivos.
///
/// Ejemplos:
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, screenInfo) {
///     if (screenInfo.isMobile) {
///       return MobileLayout();
///     } else if (screenInfo.isTablet) {
///       return TabletLayout();
///     } else {
///       return DesktopLayout();
///     }
///   },
/// )
///
/// // Con lógica más compleja
/// ResponsiveBuilder(
///   builder: (context, screenInfo) {
///     if (screenInfo.width > 1440) {
///       return UltraWideLayout();
///     }
///     return screenInfo.when(
///       mobile: () => MobileLayout(),
///       tablet: () => TabletLayout(),
///       desktop: () => DesktopLayout(),
///     );
///   },
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenInfo screenInfo) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = ScreenInfoManager().info;
    return builder(context, screenInfo);
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
/// Con jerarquía de fallbacks inteligentes
double _getValueForDevice(
  ScreenInfo screenInfo,
  Map<DeviceType, num> values,
) {
  final deviceType = screenInfo.deviceType; // ⚡ Ya calculado, acceso O(1)

  // PRIORIDAD 1: Intentar obtener valor específico para el deviceType exacto
  if (values.containsKey(deviceType)) {
    return _normalizeMultiValue(values[deviceType]!);
  }

  // PRIORIDAD 2: Fallbacks inteligentes basados en jerarquía de tipos
  switch (deviceType) {
    case DeviceType.ios:
      // iOS: prioridad ios > mobile > tablet > desktop
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeMultiValue(values[DeviceType.mobile]!);
      }
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeMultiValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeMultiValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.android:
      // Android: prioridad android > mobile > tablet > desktop
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeMultiValue(values[DeviceType.mobile]!);
      }
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeMultiValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeMultiValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.mobile:
      // Mobile: prioridad mobile > tablet > desktop
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeMultiValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeMultiValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.tablet:
      // Tablet: prioridad tablet > mobile > desktop
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeMultiValue(values[DeviceType.mobile]!);
      }
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeMultiValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.desktop:
      // Desktop: prioridad desktop > tablet > mobile
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeMultiValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeMultiValue(values[DeviceType.mobile]!);
      }
      break;
    case DeviceType.web:
      // Web: prioridad web > desktop > tablet > mobile
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeMultiValue(values[DeviceType.desktop]!);
      }
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeMultiValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeMultiValue(values[DeviceType.mobile]!);
      }
      break;
  }

  // ÚLTIMA OPCIÓN: Si no hay ningún fallback, usar el primer valor disponible
  return _normalizeMultiValue(values.values.first);
}

/// Helper especializado para size(), radius - valores directos sin normalización
/// Con jerarquía de fallbacks inteligentes
double _getDirectValueForDevice(
  ScreenInfo screenInfo,
  Map<DeviceType, num> values,
) {
  final deviceType = screenInfo.deviceType; // ⚡ Ya calculado, acceso O(1)

  // PRIORIDAD 1: Intentar obtener valor específico para el deviceType exacto
  if (values.containsKey(deviceType)) {
    return _normalizeDirectValue(values[deviceType]!);
  }

  // PRIORIDAD 2: Fallbacks inteligentes basados en jerarquía de tipos
  switch (deviceType) {
    case DeviceType.ios:
      // iOS: prioridad ios > mobile > tablet > desktop
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeDirectValue(values[DeviceType.mobile]!);
      }
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeDirectValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeDirectValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.android:
      // Android: prioridad android > mobile > tablet > desktop
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeDirectValue(values[DeviceType.mobile]!);
      }
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeDirectValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeDirectValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.mobile:
      // Mobile: prioridad mobile > tablet > desktop
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeDirectValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeDirectValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.tablet:
      // Tablet: prioridad tablet > mobile > desktop
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeDirectValue(values[DeviceType.mobile]!);
      }
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeDirectValue(values[DeviceType.desktop]!);
      }
      break;
    case DeviceType.desktop:
      // Desktop: prioridad desktop > tablet > mobile
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeDirectValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeDirectValue(values[DeviceType.mobile]!);
      }
      break;
    case DeviceType.web:
      // Web: prioridad web > desktop > tablet > mobile
      if (values.containsKey(DeviceType.desktop)) {
        return _normalizeDirectValue(values[DeviceType.desktop]!);
      }
      if (values.containsKey(DeviceType.tablet)) {
        return _normalizeDirectValue(values[DeviceType.tablet]!);
      }
      if (values.containsKey(DeviceType.mobile)) {
        return _normalizeDirectValue(values[DeviceType.mobile]!);
      }
      break;
  }

  // ÚLTIMA OPCIÓN: Si no hay ningún fallback, usar el primer valor disponible
  return _normalizeDirectValue(values.values.first);
}
