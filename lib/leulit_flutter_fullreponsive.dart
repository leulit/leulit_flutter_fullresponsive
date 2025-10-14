import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'core/screen_scaler_inherited_widget.dart';
import 'domain/screen_info.dart';

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
    // Creación del objeto inmutable.
    final screenInfo = ScreenInfo(
      width: mediaQuery.size.width,
      height: mediaQuery.size.height,
      textScale: newTextScale,
    );

    // Devolver el propagador con la información.
    return ScreenScalerInheritedWidget(
      info: screenInfo,
      child: child,
    );
  }
}

// -----------------------------------------------------------------------------
// 2. Extension Methods para Sintaxis Limpia y Acceso Eficiente
// -----------------------------------------------------------------------------

/// Extensión para usar valores responsive en números.
/// Acepta dos formatos:
/// - Porcentajes tradicionales: 0-100 (ej: 80.w(context) = 80%)
/// - Decimales precisos: 0-1 (ej: 0.8.w(context) = 80%)
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
  double w(BuildContext context) {
    final screenInfo = _getInfo(context);
    final normalizedValue = _normalizeValue(this);
    return screenInfo.width * normalizedValue;
  }

  /// **Alto Responsive:** Obtiene el alto como porcentaje de la pantalla.
  /// Acepta valores de 0-100 (ej: 30.h(context)) o 0-1 (ej: 0.3.h(context))
  double h(BuildContext context) {
    final screenInfo = _getInfo(context);
    final normalizedValue = _normalizeValue(this);
    return screenInfo.height * normalizedValue;
  }
  
  /// **Tamaño de Fuente Responsive (sp):** Escala la fuente usando un porcentaje
  /// del ancho base y aplica el factor de escala de accesibilidad del usuario.
  /// Acepta valores de 0-100 (ej: 3.sp(context)) o 0-1 (ej: 0.03.sp(context))
  double sp(BuildContext context) {
    final screenInfo = _getInfo(context);
    
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
}

// -----------------------------------------------------------------------------
// 3. Funciones Multi-Plataforma para Valores Específicos por Dispositivo
// -----------------------------------------------------------------------------

/// Enumeration para tipos de dispositivos
enum DeviceType {
  web,
  ios,
  android,
  mobile, // Incluye tanto iOS como Android
  tablet,
  desktop // Incluye web y desktop apps
}

/// Helper para detectar el tipo de dispositivo actual
DeviceType _getCurrentDeviceType(BuildContext context) {
  final platform = defaultTargetPlatform;
  final screenInfo = ScreenScalerInheritedWidget.of(context)!.info;
  
  // Determinar si es tablet basándose en el tamaño de pantalla
  final isTablet = screenInfo.width >= 600;
  
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

/// Helper para normalizar valores en las funciones multi-plataforma
double _normalizeMultiValue(num value) {
  return value <= 1 ? value.toDouble() : value.toDouble() / 100;
}

/// Helper para obtener el valor apropiado según el dispositivo
double _getValueForDevice(
  BuildContext context,
  Map<DeviceType, num> values,
  num? fallback,
) {
  final deviceType = _getCurrentDeviceType(context);
  
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
  
  if (fallback != null) {
    return _normalizeMultiValue(fallback);
  }
  
  throw FlutterError('No se encontró valor apropiado para el dispositivo $deviceType');
}

/// **Ancho Multi-Plataforma:** Obtiene el ancho basado en el tipo de dispositivo.
/// 
/// Ejemplo de uso:
/// ```dart
/// width: w(context, web: 0.3, mobile: 0.8, tablet: 0.5)
/// width: w(context, ios: 50, android: 60, web: 30) // Formato porcentaje
/// ```
double w(
  BuildContext context, {
  num? web,
  num? ios,
  num? android,
  num? mobile,
  num? tablet,
  num? desktop,
  num? fallback,
}) {
  final screenInfo = ScreenScalerInheritedWidget.of(context)?.info;
  if (screenInfo == null) {
    throw FlutterError.fromParts([
      ErrorSummary('ScreenScale Error: Missing ScreenSizeInitializer.'),
      ErrorDescription(
        'Debes envolver tu aplicación con ScreenSizeInitializer para usar w().'
      ),
    ]);
  }
  
  final values = <DeviceType, num>{};
  if (web != null) values[DeviceType.web] = web;
  if (ios != null) values[DeviceType.ios] = ios;
  if (android != null) values[DeviceType.android] = android;
  if (mobile != null) values[DeviceType.mobile] = mobile;
  if (tablet != null) values[DeviceType.tablet] = tablet;
  if (desktop != null) values[DeviceType.desktop] = desktop;
  
  final normalizedValue = _getValueForDevice(context, values, fallback);
  return screenInfo.width * normalizedValue;
}

/// **Alto Multi-Plataforma:** Obtiene el alto basado en el tipo de dispositivo.
/// 
/// Ejemplo de uso:
/// ```dart
/// height: h(context, web: 0.2, mobile: 0.4, tablet: 0.3)
/// height: h(context, ios: 25, android: 30, web: 20) // Formato porcentaje
/// ```
double h(
  BuildContext context, {
  num? web,
  num? ios,
  num? android,
  num? mobile,
  num? tablet,
  num? desktop,
  num? fallback,
}) {
  final screenInfo = ScreenScalerInheritedWidget.of(context)?.info;
  if (screenInfo == null) {
    throw FlutterError.fromParts([
      ErrorSummary('ScreenScale Error: Missing ScreenSizeInitializer.'),
      ErrorDescription(
        'Debes envolver tu aplicación con ScreenSizeInitializer para usar h().'
      ),
    ]);
  }
  
  final values = <DeviceType, num>{};
  if (web != null) values[DeviceType.web] = web;
  if (ios != null) values[DeviceType.ios] = ios;
  if (android != null) values[DeviceType.android] = android;
  if (mobile != null) values[DeviceType.mobile] = mobile;
  if (tablet != null) values[DeviceType.tablet] = tablet;
  if (desktop != null) values[DeviceType.desktop] = desktop;
  
  final normalizedValue = _getValueForDevice(context, values, fallback);
  return screenInfo.height * normalizedValue;
}

/// **Tamaño de Fuente Multi-Plataforma:** Obtiene el tamaño de fuente basado en el tipo de dispositivo.
/// 
/// Ejemplo de uso:
/// ```dart
/// fontSize: sp(context, web: 0.02, mobile: 0.04, tablet: 0.03)
/// fontSize: sp(context, ios: 3, android: 4, web: 2) // Formato tradicional
/// ```
double sp(
  BuildContext context, {
  num? web,
  num? ios,
  num? android,
  num? mobile,
  num? tablet,
  num? desktop,
  num? fallback,
}) {
  final screenInfo = ScreenScalerInheritedWidget.of(context)?.info;
  if (screenInfo == null) {
    throw FlutterError.fromParts([
      ErrorSummary('ScreenScale Error: Missing ScreenSizeInitializer.'),
      ErrorDescription(
        'Debes envolver tu aplicación con ScreenSizeInitializer para usar sp().'
      ),
    ]);
  }
  
  final values = <DeviceType, num>{};
  if (web != null) values[DeviceType.web] = web;
  if (ios != null) values[DeviceType.ios] = ios;
  if (android != null) values[DeviceType.android] = android;
  if (mobile != null) values[DeviceType.mobile] = mobile;
  if (tablet != null) values[DeviceType.tablet] = tablet;
  if (desktop != null) values[DeviceType.desktop] = desktop;
  
  final rawValue = _getValueForDevice(context, values, fallback);
  
  // Aplicar la misma lógica de escalado que en la extensión
  final double baseSize;
  if (rawValue <= 1) {
    // Si es decimal (0-1), multiplicamos directamente por el ancho
    baseSize = screenInfo.width * rawValue;
  } else {
    // Si es porcentaje (0-100), usamos la lógica original
    baseSize = screenInfo.width * (rawValue / 100);
  }
  
  return baseSize * screenInfo.textScale;
}
