import 'package:flutter/widgets.dart';
import '../domain/screen_info.dart';

/// Un InheritedWidget que propaga el ScreenInfo y gestiona la notificación
/// de reconstrucción solo cuando el tamaño de pantalla cambia.
class ScreenScalerInheritedWidget extends InheritedWidget {
  final ScreenInfo info;

  const ScreenScalerInheritedWidget({
    super.key,
    required this.info,
    required super.child,
  });

  /// Método estático para obtener la instancia y suscribir al widget llamador.
  static ScreenScalerInheritedWidget? of(BuildContext context) {
    // dependOnInheritedWidgetOfExactType es el mecanismo de suscripción eficiente.
    return context.dependOnInheritedWidgetOfExactType<ScreenScalerInheritedWidget>();
  }

  /// CLAVE: Solo notifica a los suscriptores si el objeto 'info' ha cambiado.
  /// Esto previene reconstrucciones innecesarias.
  @override
  bool updateShouldNotify(covariant ScreenScalerInheritedWidget oldWidget) {
    return info != oldWidget.info;
  }
}