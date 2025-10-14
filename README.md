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
  leulit_flutter_fullresponsive: ^1.2.0
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

### 🆕 Funciones Multi-Plataforma

#### `w(BuildContext context, {...})`
Ancho responsive específico por plataforma:
```dart
// Ejemplo con diferentes plataformas
width: w(context, web: 0.4, mobile: 0.9, tablet: 0.6, fallback: 0.5)

// Solo especificar algunas plataformas
width: w(context, web: 30, mobile: 80) // Formato porcentaje

// Específico por sistema operativo
width: w(context, ios: 0.8, android: 0.85, web: 0.4)
```

#### `h(BuildContext context, {...})`
Alto responsive específico por plataforma:
```dart
height: h(context, web: 0.3, mobile: 0.5, tablet: 0.4, fallback: 0.35)
```

#### `sp(BuildContext context, {...})`
Tamaño de fuente responsive específico por plataforma:
```dart
fontSize: sp(context, web: 0.02, mobile: 0.04, tablet: 0.03, fallback: 0.025)
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

### 🚀 **NUEVO: Funciones Multi-Plataforma**

**Ahora puedes especificar valores diferentes para cada plataforma:**

```dart
class MultiPlatformExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Diferentes anchos según la plataforma
      width: w(context, 
        web: 0.3,      // 30% en web
        mobile: 0.9,   // 90% en móviles (iOS y Android)
        tablet: 0.6,   // 60% en tablets
        fallback: 0.5, // 50% como fallback
      ),
      
      // Diferentes alturas según la plataforma
      height: h(context,
        web: 0.4,       // 40% en web
        ios: 0.25,      // 25% específico para iOS
        android: 0.3,   // 30% específico para Android
        tablet: 0.35,   // 35% en tablets
        fallback: 0.28, // 28% como fallback
      ),
      
      child: Text(
        'Responsive Multi-Platform',
        style: TextStyle(
          // Diferentes tamaños de fuente según la plataforma
          fontSize: sp(context,
            web: 0.02,    // Tamaño para web
            mobile: 0.04, // Tamaño para móviles
            tablet: 0.03, // Tamaño para tablets
            fallback: 0.025,
          ),
        ),
      ),
    );
  }
}
```

#### Plataformas soportadas:
- **`web`**: Aplicaciones web y desktop
- **`ios`**: Específico para iOS
- **`android`**: Específico para Android  
- **`mobile`**: Ambos iOS y Android
- **`tablet`**: Tablets (detectado por tamaño de pantalla ≥600px)
- **`desktop`**: Aplicaciones de escritorio
- **`fallback`**: Valor por defecto si no se encuentra una plataforma específica

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

## 🎨 **NUEVO: Extensiones Especializadas**

### 📏 ResponsiveSize - Para Iconos, Padding, Margins

Ahora puedes hacer responsive fácilmente los tamaños de iconos, padding, margins y otros elementos UI pequeños:

```dart
class IconExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Iconos responsive
        Icon(
          Icons.star,
          size: 24.size(context), // Tamaño responsive automático
          color: Colors.gold,
        ),
        
        // Con valores específicos por plataforma
        Icon(
          Icons.favorite,
          size: 20.sizeFor(context,
            mobile: 18,   // Más pequeño en móviles
            tablet: 24,   // Medio en tablets
            desktop: 32,  // Más grande en desktop
          ),
          color: Colors.red,
        ),
        
        // Padding responsive
        Padding(
          padding: EdgeInsets.all(16.size(context)),
          child: Text('Padding responsive'),
        ),
        
        // Margins responsive
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20.size(context),
            vertical: 12.size(context),
          ),
          child: Text('Margin responsive'),
        ),
      ],
    );
  }
}
```

### 🔄 ResponsiveRadius - Para Border Radius

Crea esquinas redondeadas que se adapten perfectamente a diferentes pantallas:

```dart
class RadiusExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Border radius simple
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12.radius(context)),
          ),
          child: Text('Esquinas responsive'),
        ),
        
        // Border radius específico por plataforma
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(
              8.radiusFor(context,
                mobile: 6,    // Esquinas más suaves en móvil
                tablet: 12,   // Intermedias en tablet
                desktop: 20,  // Más pronunciadas en desktop
              ),
            ),
          ),
          child: Text('Multi-platform radius'),
        ),
        
        // Diferentes esquinas
        Container(
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.radius(context)),
              topRight: Radius.circular(8.radius(context)),
              bottomLeft: Radius.circular(4.radius(context)),
              bottomRight: Radius.circular(20.radius(context)),
            ),
          ),
          child: Text('Esquinas asimétricas'),
        ),
      ],
    );
  }
}
```

### 📐 ResponsiveFlex - Para Layouts Flexibles

Optimiza tus layouts con valores de flex que se adapten al tipo de dispositivo:

```dart
class FlexExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row con flex responsive automático
        Row(
          children: [
            Expanded(
              flex: 3.flexValue(context), // Se ajusta automáticamente
              child: Container(
                color: Colors.red,
                height: 100,
                child: Center(child: Text('Flex 3')),
              ),
            ),
            Expanded(
              flex: 2.flexValue(context), // Se ajusta automáticamente  
              child: Container(
                color: Colors.blue,
                height: 100,
                child: Center(child: Text('Flex 2')),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 20),
        
        // Row con flex específico por plataforma
        Row(
          children: [
            Expanded(
              flex: 4.flexFor(context,
                mobile: 3,    // Más equilibrado en móvil
                tablet: 5,    // Más prominente en tablet
                desktop: 6,   // Dominante en desktop
              ),
              child: Container(
                color: Colors.green,
                height: 100,
                child: Center(child: Text('Flex Adaptativo')),
              ),
            ),
            Expanded(
              flex: 2.flexFor(context,
                mobile: 2,
                tablet: 2,
                desktop: 1,   // Menos espacio en desktop
              ),
              child: Container(
                color: Colors.orange,
                height: 100,
                child: Center(child: Text('Flex Secundario')),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

### 🎯 Casos de Uso Prácticos

```dart
class PracticalExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          size: 24.sizeFor(context, mobile: 20, tablet: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 22.size(context),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              size: 22.size(context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          children: [
            // Card con esquinas y padding responsive
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.radius(context)),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.size(context)),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 28.sizeFor(context,
                        mobile: 24,
                        tablet: 32,
                        desktop: 36,
                      ),
                      color: Colors.blue,
                    ),
                    SizedBox(width: 16.size(context)),
                    Expanded(
                      flex: 4.flexValue(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notificación',
                            style: TextStyle(
                              fontSize: 3.sp(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Descripción de la notificación',
                            style: TextStyle(fontSize: 2.5.sp(context)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20.size(context)),
            
            // Botones con diferentes estilos responsive
            Row(
              children: [
                Expanded(
                  flex: 2.flexFor(context, mobile: 1, tablet: 2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.radius(context)),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.size(context),
                        horizontal: 24.size(context),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Aceptar',
                      style: TextStyle(fontSize: 2.8.sp(context)),
                    ),
                  ),
                ),
                SizedBox(width: 12.size(context)),
                Expanded(
                  flex: 1.flexValue(context),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.radius(context)),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.size(context),
                        horizontal: 16.size(context),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 2.8.sp(context)),
                    ),
                  ),
                ),
              ],
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