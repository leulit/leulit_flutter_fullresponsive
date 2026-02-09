import 'package:flutter/widgets.dart';

/// Enumeration para tipos de dispositivos
/// Movido aquí para evitar dependencias circulares
enum DeviceType {
  web,
  ios,
  android,
  mobile, // Incluye tanto iOS como Android
  tablet,
  desktop // Incluye web y desktop apps
}

/// Configuración de breakpoints personalizados para responsive design
@immutable
class ResponsiveBreakpoints {
  final double mobile;
  final double tablet;
  final double desktop;
  final Map<String, double>? custom;

  const ResponsiveBreakpoints({
    this.mobile = 0,
    this.tablet = 600,
    this.desktop = 1200,
    this.custom,
  });

  /// Breakpoints por defecto
  static const defaultBreakpoints = ResponsiveBreakpoints();
}

/// Clase inmutable que almacena las dimensiones de la pantalla y tipo de dispositivo.
/// La inmutabilidad es clave para la eficiencia del InheritedWidget y el null safety.
@immutable
class ScreenInfo {
  final double width;
  final double height;
  final double textScale;
  final DeviceType deviceType; // ⚡ OPTIMIZACIÓN: Calculado una sola vez

  const ScreenInfo({
    required this.width,
    required this.height,
    required this.textScale,
    required this.deviceType,
  });

  // -------------------------------------------------------------------------
  // HELPERS CONDICIONALES (sin context)
  // -------------------------------------------------------------------------

  /// Verifica si el dispositivo es móvil (iOS o Android, no tablet)
  bool get isMobile =>
      deviceType == DeviceType.mobile ||
      deviceType == DeviceType.ios ||
      deviceType == DeviceType.android;

  /// Verifica si es específicamente iOS móvil
  bool get isMobileIOS => deviceType == DeviceType.ios;

  /// Verifica si es específicamente Android móvil
  bool get isMobileAndroid => deviceType == DeviceType.android;

  /// Verifica si el dispositivo es tablet
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Verifica si el dispositivo es desktop
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Verifica si el dispositivo es web
  bool get isWeb => deviceType == DeviceType.web;

  /// Verifica si es iOS (móvil o tablet)
  bool get isIOS => deviceType == DeviceType.ios;

  /// Verifica si es Android (móvil o tablet)
  bool get isAndroid => deviceType == DeviceType.android;

  /// Verifica si es tablet o desktop (pantallas grandes)
  bool get isTabletOrDesktop => isTablet || isDesktop;

  /// Verifica si está en modo portrait
  bool get isPortrait => height > width;

  /// Verifica si está en modo landscape
  bool get isLandscape => width > height;

  /// Verifica si el ancho está entre dos valores
  bool widthBetween(double min, double max) => width >= min && width <= max;

  /// Verifica si el alto está entre dos valores
  bool heightBetween(double min, double max) => height >= min && height <= max;

  /// Obtiene un valor según el tipo de dispositivo actual
  T when<T>({
    required T Function() mobile,
    required T Function() tablet,
    required T Function() desktop,
    T Function()? ios,
    T Function()? android,
    T Function()? web,
  }) {
    switch (deviceType) {
      case DeviceType.ios:
        return (ios ?? mobile)();
      case DeviceType.android:
        return (android ?? mobile)();
      case DeviceType.mobile:
        return mobile();
      case DeviceType.tablet:
        return tablet();
      case DeviceType.desktop:
        return desktop();
      case DeviceType.web:
        return (web ?? desktop)();
    }
  }

  /// Sobreescritura crucial: Permite al InheritedWidget saber si ALGO cambió.
  /// La igualdad requiere que TODAS las propiedades sean idénticas.
  /// Si un campo es diferente, devuelve false, lo que dispara la notificación (info != oldInfo -> true).
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenInfo &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          textScale == other.textScale &&
          deviceType == other.deviceType;

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      textScale.hashCode ^
      deviceType.hashCode;
}
