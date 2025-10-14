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
  int get hashCode => width.hashCode ^ height.hashCode ^ textScale.hashCode ^ deviceType.hashCode;
}