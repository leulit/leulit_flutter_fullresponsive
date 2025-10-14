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
