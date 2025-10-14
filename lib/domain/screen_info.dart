import 'package:flutter/widgets.dart';

/// Clase inmutable que almacena las dimensiones de la pantalla.
/// La inmutabilidad es clave para la eficiencia del InheritedWidget y el null safety.
@immutable
class ScreenInfo {
  final double width;
  final double height;
  final double textScale;

  const ScreenInfo({
    required this.width,
    required this.height,
    required this.textScale,
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
          textScale == other.textScale; 

  @override
  int get hashCode => width.hashCode ^ height.hashCode ^ textScale.hashCode;
}