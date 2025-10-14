import 'package:flutter/widgets.dart';
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

/// Extensión para usar porcentajes en valores numéricos.
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

  /// **Ancho Responsive:** Obtiene el ancho como porcentaje de la pantalla. Ej: `80.w(context)`
  double w(BuildContext context) {
    final screenInfo = _getInfo(context);
    return screenInfo.width * (this / 100);
  }

  /// **Alto Responsive:** Obtiene el alto como porcentaje de la pantalla. Ej: `30.h(context)`
  double h(BuildContext context) {
    final screenInfo = _getInfo(context);
    return screenInfo.height * (this / 100);
  }
  
  /// **Tamaño de Fuente Responsive (sp):** Escala la fuente usando un porcentaje
  /// del ancho base y aplica el factor de escala de accesibilidad del usuario.
  /// Ej: `3.sp(context)`
  double sp(BuildContext context) {
    final screenInfo = _getInfo(context);
    
    // Usamos el ancho como base para el escalado (sin cambios).
    final baseSize = screenInfo.width * (this / 1000); 
    
    // CAMBIO CLAVE: Usar screenInfo.textScale.
    return baseSize * screenInfo.textScale;
  }
}
