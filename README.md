# Leulit Flutter Full Responsive

[![pub package](https://img.shields.io/pub/v/leulit_flutter_fullresponsive.svg)](https://pub.dev/packages/leulit_flutter_fullresponsive)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Una librería agnóstica de alto rendimiento para responsividad en Flutter usando `InheritedWidget` y Extension Methods. Proporciona una API simple y eficiente para crear interfaces que se adapten a diferentes tamaños de pantalla.

## ✨ Características

- 🚀 **Alto rendimiento**: Utiliza `InheritedWidget` para propagación eficiente
- 📱 **Completamente responsive**: Adapta automáticamente el ancho, alto y tamaño de fuente
- 🎯 **API intuitiva**: Extension methods simples (.w(), .h(), .sp())
- ♿ **Accesibilidad**: Respeta la configuración de escala de texto del usuario
- 🔒 **Type-safe**: Aprovecha el null safety de Dart
- 📦 **Ligero**: Sin dependencias externas, solo Flutter SDK

## 🔧 Instalación

### Desde pub.dev

Agrega la dependencia a tu `pubspec.yaml`:

```yaml
dependencies:
  leulit_flutter_fullresponsive: ^1.1.0
```

Ejecuta:

```bash
flutter pub get
```

### Instalación local (para desarrollo)

Si quieres usar la versión local del paquete:

1. Clona el repositorio:
```bash
git clone https://github.com/leulit/leulit_flutter_fullresponsive.git
cd leulit_flutter_fullresponsive
```

2. En tu proyecto Flutter, agrega la dependencia local al `pubspec.yaml`:
```yaml
dependencies:
  leulit_flutter_fullresponsive:
    path: ../path/to/leulit_flutter_fullresponsive
```

3. Ejecuta:
```bash
flutter pub get
```

## 🚀 Uso Básico

### 1. Configuración inicial

Envuelve tu `MaterialApp` o `CupertinoApp` con `ScreenSizeInitializer`:

```dart
import 'package:flutter/material.dart';
import 'package:leulit_flutter_fullresponsive/leulit_flutter_fullresponsive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeInitializer(
      child: MaterialApp(
        title: 'Mi App Responsive',
        home: HomeScreen(),
      ),
    );
  }
}
```

### 2. Usando las extensiones

Una vez configurado, puedes usar las extensiones en cualquier parte de tu aplicación. **Ahora soporta dos formatos:**

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Formato tradicional (0-100)
        width: 80.w(context),        // 80% del ancho de pantalla
        height: 50.h(context),       // 50% del alto de pantalla
        
        // O formato decimal (0-1) para mayor precisión
        // width: 0.8.w(context),       // Equivalente a 80%
        // height: 0.5.h(context),      // Equivalente a 50%
        
        // Valores ultra precisos
        // width: 0.076543.w(context),  // 7.6543% exacto
        
        child: Text(
          'Texto responsive',
          style: TextStyle(
            fontSize: 4.sp(context),  // Tamaño de fuente responsive
            // o fontSize: 0.03.sp(context), // Formato decimal
          ),
        ),
      ),
    );
  }
}
```

## 📚 API Reference

### Extension Methods

#### `.w(BuildContext context)`
Calcula un porcentaje del ancho de pantalla. Acepta dos formatos:
```dart
// Formato tradicional (0-100)
Container(width: 50.w(context))     // 50% del ancho

// Formato decimal (0-1) para mayor precisión
Container(width: 0.5.w(context))    // 50% del ancho
Container(width: 0.076543.w(context)) // 7.6543% exacto
```

#### `.h(BuildContext context)`
Calcula un porcentaje del alto de pantalla. Acepta dos formatos:
```dart
// Formato tradicional (0-100)
Container(height: 30.h(context))    // 30% del alto

// Formato decimal (0-1) para mayor precisión
Container(height: 0.3.h(context))   // 30% del alto
Container(height: 0.123456.h(context)) // 12.3456% exacto
```

#### `.sp(BuildContext context)`
Calcula un tamaño de fuente responsive que respeta la configuración de accesibilidad. Acepta dos formatos:
```dart
// Formato tradicional
Text(
  'Hola',
  style: TextStyle(fontSize: 3.sp(context)), // Fuente responsive
)

// Formato decimal para mayor control
Text(
  'Hola',
  style: TextStyle(fontSize: 0.025.sp(context)), // Control preciso
)
```

### Widgets

#### `ScreenSizeInitializer`
Widget que debe envolver tu aplicación para inicializar el sistema de responsividad.

```dart
ScreenSizeInitializer(
  child: MaterialApp(...),
)
```

## 💡 Ejemplos Avanzados

### Comparación de formatos

```dart
class FormatComparison extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Formato tradicional (0-100)
        Container(
          width: 75.w(context),        // 75%
          height: 10.h(context),       // 10%
          color: Colors.blue,
        ),
        
        // Formato decimal (0-1) - Equivalente
        Container(
          width: 0.75.w(context),      // 75%
          height: 0.1.h(context),      // 10%
          color: Colors.green,
        ),
        
        // Alta precisión solo posible con decimales
        Container(
          width: 0.618033.w(context),  // Proporción áurea exacta
          height: 0.08333.h(context),  // 1/12 exacto
          color: Colors.orange,
        ),
      ],
    );
  }
}
```

### Layout responsive completo

```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'App Responsive',
          style: TextStyle(fontSize: 4.sp(context)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w(context)),
        child: Column(
          children: [
            Container(
              width: 100.w(context),
              height: 25.h(context),
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Header',
                  style: TextStyle(
                    fontSize: 5.sp(context),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h(context)),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 30.w(context),
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        'Sidebar',
                        style: TextStyle(fontSize: 3.sp(context)),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w(context)),
                  Expanded(
                    child: Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: Text(
                          'Content',
                          style: TextStyle(fontSize: 3.sp(context)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🧪 Testing

Para ejecutar las pruebas:

```bash
flutter test
```

## 📦 Desarrollo Local

### Estructura del proyecto

```
lib/
├── leulit_flutter_fullresponsive.dart    # Archivo principal
├── core/
│   └── screen_scaler_inherited_widget.dart # InheritedWidget
└── domain/
    └── screen_info.dart                  # Modelo de datos
```

### Ejecutar ejemplo de desarrollo

```bash
flutter create example
cd example
# Agregar dependencia local en pubspec.yaml
flutter run
```

## 📋 Publicación en pub.dev

### Requisitos previos

1. Tener una cuenta en [pub.dev](https://pub.dev)
2. Configurar las credenciales:
```bash
dart pub login
```

### Proceso de publicación

1. **Verificar que el paquete esté listo:**
```bash
dart pub publish --dry-run
```

2. **Actualizar la versión en `pubspec.yaml`:**
```yaml
version: 1.0.1  # Incrementar según semantic versioning
```

3. **Actualizar el CHANGELOG.md:**
```markdown
## [1.0.1] - 2024-10-14
### Added
- Nueva funcionalidad X
### Fixed
- Corrección del bug Y
```

4. **Publicar:**
```bash
dart pub publish
```

### Semantic Versioning

- **MAJOR** (1.0.0 → 2.0.0): Cambios que rompen compatibilidad
- **MINOR** (1.0.0 → 1.1.0): Nuevas funcionalidades compatibles
- **PATCH** (1.0.0 → 1.0.1): Correcciones de bugs

### Actualización de versiones

1. Hacer cambios en el código
2. Ejecutar pruebas: `flutter test`
3. Actualizar versión en `pubspec.yaml`
4. Actualizar `CHANGELOG.md`
5. Commit y push a git
6. Publicar: `dart pub publish`

## ⚠️ Troubleshooting

### Error: "Missing ScreenSizeInitializer"

**Problema:** Las extensiones lanzan error sobre inicializador faltante.

**Solución:** Asegúrate de envolver tu `MaterialApp` con `ScreenSizeInitializer`:

```dart
ScreenSizeInitializer(
  child: MaterialApp(...),
)
```

### Comportamiento inesperado en tamaños

**Problema:** Los porcentajes no se comportan como esperado.

**Solución:** Verifica que estés usando los valores correctos:
- `.w()` y `.h()` esperan valores 0-100 (porcentajes)
- `.sp()` funciona mejor con valores pequeños (1-6 típicamente)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👥 Autor

Desarrollado por [Leulit](https://github.com/leulit)

## 🔗 Enlaces

- [Documentación de Flutter](https://flutter.dev/docs)
- [pub.dev](https://pub.dev)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)