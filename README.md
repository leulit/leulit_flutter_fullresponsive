# Leulit Flutter Full Responsive

[![pub package](https://img.shields.io/pub/v/leulit_flutter_fullresponsive.svg)](https://pub.dev/packages/leulit_flutter_fullresponsive)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Una librería agnóstica de alto rendimiento para responsividad en Flutter usando `InheritedWidget` y Extension Methods. Proporciona una API unificada y eficiente para crear interfaces que se adapten a diferentes tamaños de pantalla y plataformas.

## ✨ Características

- 🚀 **Alto rendimiento**: Utiliza `InheritedWidget` y singleton para propagación eficiente
- 📱 **Completamente responsive**: Adapta automáticamente el ancho, alto y tamaño de fuente
- 🎯 **API dual**: Simple (`.w`, `.h`, `.sp`) y multi-plataforma (`rw()`, `rh()`, `rsp()`)
- 🌐 **Multi-plataforma**: Valores específicos por dispositivo (web, iOS, Android, tablet, desktop)
- 🎚️ **Breakpoints personalizables**: Define tus propios puntos de quiebre para tablet y desktop
- 🔍 **Helpers condicionales**: Métodos de utilidad como `isMobile`, `isTablet`, `when()`, `widthBetween()`
- 🧩 **Widgets especializados**: `ResponsiveWidget` y `ResponsiveBuilder` para renderizado condicional
- ♿ **Accesibilidad**: Respeta la configuración de escala de texto del usuario
- 🔒 **Type-safe**: Aprovecha el null safety de Dart
- 📦 **Ligero**: Sin dependencias externas, solo Flutter SDK

## 🔥 Novedades v3.0.0

### 🎯 API Dual: Simple y Multi-plataforma

```dart
// ✅ API Simple (sin context) - Para valores únicos
Container(
  width: 80.w,        // 80% del ancho
  height: 50.h,       // 50% del alto
  child: Text('Hola', style: TextStyle(fontSize: 3.sp)),
)

// ✅ API Multi-plataforma - Para valores específicos por dispositivo
Container(
  width: rw(mobile: 90, tablet: 70, desktop: 50),  // Diferentes valores por plataforma
  height: rh(mobile: 40, tablet: 30, desktop: 25),
  child: Text('Hola', style: TextStyle(fontSize: rsp(mobile: 4, tablet: 3))),
)
```

### 🎚️ Breakpoints Personalizables

```dart
ScreenSizeInitializer(
  breakpoints: ResponsiveBreakpoints(
    mobile: 0,      // De 0px en adelante
    tablet: 600,    // De 600px en adelante
    desktop: 1200,  // De 1200px en adelante
  ),
  child: MaterialApp(...),
)
```

### 🔍 Helpers Condicionales

```dart
// Acceso desde ScreenInfo
final screenInfo = ScreenInfo.of(context);

if (screenInfo.isMobile) {
  // Código específico para móvil
}

// Valores condicionales
final padding = screenInfo.when<double>(
  mobile: 16,
  tablet: 24,
  desktop: 32,
);

// Rangos de ancho
if (screenInfo.widthBetween(300, 600)) {
  // Código para pantallas entre 300 y 600px
}
```

### 🧩 Widgets de Renderizado Condicional

```dart
// Mostrar/ocultar según dispositivo
ResponsiveWidget(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)

// Builder personalizado con ScreenInfo
ResponsiveBuilder(
  builder: (context, screenInfo) {
    return Container(
      width: screenInfo.isMobile ? 100.w : 50.w,
      child: Text('Responsive'),
    );
  },
)
```

### ⚠️ BREAKING CHANGES

**v3.0.0 elimina todos los métodos `*WithContext` obsoletos:**

```dart
// ❌ ELIMINADO en v3.0.0
Container(width: 80.w(context, mobile: 90, tablet: 70))

// ✅ USA AHORA
Container(width: rw(mobile: 90, tablet: 70, desktop: 80))
```

📖 [Ver guía completa de migración](MIGRATION_GUIDE.md)

## 🔧 Instalación

Agrega la dependencia a tu `pubspec.yaml`:

```yaml
dependencies:
  leulit_flutter_fullresponsive: ^3.0.0
```

Ejecuta:

```bash
flutter pub get
```

## 🚀 Inicio Rápido

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
      // Opcional: Personalizar breakpoints
      breakpoints: ResponsiveBreakpoints(
        mobile: 0,      // 0px - 599px
        tablet: 600,    // 600px - 1199px
        desktop: 1200,  // 1200px+
      ),
      child: MaterialApp(
        title: 'Mi App Responsive',
        home: HomeScreen(),
      ),
    );
  }
}
```

### 2. API Simple - Valores únicos sin context

Para casos donde necesitas un solo valor responsive:

```dart
class SimpleExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 80.w,        // 80% del ancho
        height: 50.h,       // 50% del alto
        padding: EdgeInsets.all(16.size),  // Padding responsive
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.radius),  // Esquinas responsive
        ),
        child: Text(
          'Texto responsive',
          style: TextStyle(fontSize: 3.sp),  // Tamaño de fuente responsive
        ),
      ),
    );
  }
}
```

### 3. API Multi-plataforma - Valores específicos por dispositivo

Para casos donde necesitas valores diferentes según la plataforma:

```dart
class MultiPlatformExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Diferentes anchos por plataforma
        width: rw(
          mobile: 90,    // 90% en móvil
          tablet: 70,    // 70% en tablet
          desktop: 50,   // 50% en desktop
        ),
        
        // Diferentes alturas por plataforma
        height: rh(
          mobile: 40,
          tablet: 30,
          ios: 45,       // Específico para iOS
        ),
        
        child: Text(
          'Multi-platform',
          style: TextStyle(
            fontSize: rsp(
              mobile: 4,
              tablet: 3,
              desktop: 2.5,
            ),
          ),
        ),
      ),
    );
  }
}
```

## 📚 API Reference

### � API Simple (Extension Methods) - Sin context

Perfecta para valores únicos que se adaptan automáticamente al tamaño de pantalla:

#### `.w` - Ancho responsive
```dart
Container(width: 80.w)  // 80% del ancho de pantalla
```

#### `.h` - Alto responsive
```dart
Container(height: 50.h)  // 50% del alto de pantalla
```

#### `.sp` - Tamaño de fuente responsive
```dart
Text('Hola', style: TextStyle(fontSize: 3.sp))  // Respeta accesibilidad
```

#### `.size` - Tamaño para iconos, padding, margins
```dart
Icon(Icons.star, size: 24.size)
Padding(padding: EdgeInsets.all(16.size))
```

#### `.radius` - Border radius responsive
```dart
BorderRadius.circular(12.radius)
```

#### `.flexValue` - Flex responsive para layouts
```dart
Expanded(flex: 2.flexValue, child: ...)
```

### 🌐 API Multi-plataforma (Funciones) - Con valores específicos

Perfecta cuando necesitas valores diferentes por tipo de dispositivo:

#### `rw()` - Ancho multi-plataforma
```dart
Container(
  width: rw(
    mobile: 90,    // 90% en móvil
    tablet: 70,    // 70% en tablet
    desktop: 50,   // 50% en desktop
    web: 40,       // 40% en web
    ios: 95,       // 95% específico para iOS
    android: 88,   // 88% específico para Android
  ),
)
```

#### `rh()` - Alto multi-plataforma
```dart
Container(
  height: rh(
    mobile: 40,
    tablet: 30,
    desktop: 25,
  ),
)
```

#### `rsp()` - Tamaño de fuente multi-plataforma
```dart
Text(
  'Hola',
  style: TextStyle(
    fontSize: rsp(
      mobile: 4,    // Más grande en móvil
      tablet: 3,    // Medio en tablet
      desktop: 2.5, // Más pequeño en desktop
    ),
  ),
)
```

#### `rsize()` - Tamaño multi-plataforma (iconos, padding, etc.)
```dart
Icon(
  Icons.star,
  size: rsize(
    mobile: 20,
    tablet: 24,
    desktop: 28,
  ),
)

Padding(
  padding: EdgeInsets.all(
    rsize(mobile: 12, tablet: 16, desktop: 20),
  ),
)
```

#### `rradius()` - Border radius multi-plataforma
```dart
BorderRadius.circular(
  rradius(
    mobile: 8,
    tablet: 12,
    desktop: 16,
  ),
)
```

#### `rflexValue()` - Flex multi-plataforma
```dart
Expanded(
  flex: rflexValue(
    mobile: 1,
    tablet: 2,
    desktop: 3,
  ),
  child: ...,
)
```

### 🎚️ Breakpoints Personalizables

Configura tus propios puntos de quiebre:

```dart
ScreenSizeInitializer(
  breakpoints: ResponsiveBreakpoints(
    mobile: 0,      // De 0px en adelante
    tablet: 768,    // De 768px en adelante (personalizado)
    desktop: 1440,  // De 1440px en adelante (personalizado)
  ),
  child: MaterialApp(...),
)
```

### 🔍 Helpers Condicionales en ScreenInfo

Obtén información del dispositivo y pantalla:

```dart
final screenInfo = ScreenInfo.of(context);

// Propiedades básicas
final width = screenInfo.width;           // Ancho en px
final height = screenInfo.height;         // Alto en px
final deviceType = screenInfo.deviceType; // DeviceType enum

// Helpers booleanos
if (screenInfo.isMobile) { }    // true si es móvil
if (screenInfo.isTablet) { }    // true si es tablet
if (screenInfo.isDesktop) { }   // true si es desktop
if (screenInfo.isWeb) { }       // true si es web
if (screenInfo.isIOS) { }       // true si es iOS
if (screenInfo.isAndroid) { }   // true si es Android

// Valores condicionales según dispositivo
final padding = screenInfo.when<double>(
  mobile: 16,
  tablet: 24,
  desktop: 32,
);

// Rangos de ancho
if (screenInfo.widthBetween(300, 600)) {
  // Pantalla entre 300px y 600px
}
if (screenInfo.widthGreaterThan(1200)) {
  // Pantalla mayor a 1200px
}
if (screenInfo.widthLessThan(600)) {
  // Pantalla menor a 600px
}
```

### 🧩 Widgets Especializados

#### `ResponsiveWidget` - Renderizado condicional por dispositivo

Muestra diferentes widgets según el tipo de dispositivo:

```dart
ResponsiveWidget(
  mobile: MobileLayout(),      // Mostrar en móvil
  tablet: TabletLayout(),      // Mostrar en tablet
  desktop: DesktopLayout(),    // Mostrar en desktop
)
```

#### `ResponsiveBuilder` - Builder con acceso a ScreenInfo

Construye widgets con acceso completo a la información de pantalla:

```dart
ResponsiveBuilder(
  builder: (context, screenInfo) {
    if (screenInfo.isMobile) {
      return MobileLayout();
    } else if (screenInfo.isTablet) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

### 🎯 Orden de Precedencia Multi-plataforma

Cuando usas la API multi-plataforma, los valores se resuelven en este orden:

1. **Plataforma específica**: `ios`, `android`, `web`
2. **Categoría de dispositivo**: `mobile`, `tablet`, `desktop`
3. **Valor por defecto**: Primer parámetro nombrado encontrado

Ejemplo:
```dart
rw(
  mobile: 80,   // Para móvil genérico
  ios: 90,      // Para iOS específicamente
  tablet: 60,
  desktop: 50,
)
// En iPhone: usa 90 (ios tiene precedencia sobre mobile)
// En Android: usa 80 (mobile)
// En Tablet: usa 60 (tablet)
// En Desktop: usa 50 (desktop)
```
## 💡 Ejemplos Avanzados

### Layout Responsive Completo

```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'App Responsive',
          style: TextStyle(fontSize: 4.sp),
        ),
      ),
      body: ResponsiveBuilder(
        builder: (context, screenInfo) {
          if (screenInfo.isMobile) {
            return _buildMobileLayout();
          } else if (screenInfo.isTablet) {
            return _buildTabletLayout();
          } else {
            return _buildDesktopLayout();
          }
        },
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: rh(mobile: 30),
          color: Colors.blue,
          child: Center(
            child: Text(
              'Header Móvil',
              style: TextStyle(fontSize: 5.sp, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16.size),
            children: [
              _buildCard('Item 1'),
              _buildCard('Item 2'),
              _buildCard('Item 3'),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabletLayout() {
    return Row(
      children: [
        Container(
          width: rw(tablet: 30),
          color: Colors.grey[300],
          child: Center(child: Text('Sidebar', style: TextStyle(fontSize: 3.sp))),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                height: rh(tablet: 20),
                color: Colors.blue,
                child: Center(
                  child: Text('Header', style: TextStyle(fontSize: 5.sp, color: Colors.white)),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(16.size),
                  children: [
                    _buildCard('Item 1'),
                    _buildCard('Item 2'),
                    _buildCard('Item 3'),
                    _buildCard('Item 4'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          width: rw(desktop: 20),
          color: Colors.grey[300],
          child: Center(child: Text('Sidebar', style: TextStyle(fontSize: 3.sp))),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                height: rh(desktop: 15),
                color: Colors.blue,
                child: Center(
                  child: Text('Header', style: TextStyle(fontSize: 5.sp, color: Colors.white)),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: EdgeInsets.all(rsize(desktop: 24)),
                  children: List.generate(6, (i) => _buildCard('Item ${i + 1}')),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: rw(desktop: 20),
          color: Colors.grey[200],
          child: Center(child: Text('Panel Derecho', style: TextStyle(fontSize: 3.sp))),
        ),
      ],
    );
  }
  
  Widget _buildCard(String title) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size),
        child: Center(
          child: Text(title, style: TextStyle(fontSize: 3.sp)),
        ),
      ),
    );
  }
}
```

### Usando Breakpoints Personalizados

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeInitializer(
      // Breakpoints personalizados según diseño
      breakpoints: ResponsiveBreakpoints(
        mobile: 0,      // 0 - 767px
        tablet: 768,    // 768 - 1439px
        desktop: 1440,  // 1440px+
      ),
      child: MaterialApp(
        home: CustomBreakpointsExample(),
      ),
    );
  }
}

class CustomBreakpointsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenInfo = ScreenInfo.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Breakpoints Personalizados'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ancho: ${screenInfo.width.toStringAsFixed(0)}px',
              style: TextStyle(fontSize: 3.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              'Tipo: ${screenInfo.deviceType}',
              style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Container(
              width: rw(mobile: 90, tablet: 70, desktop: 50),
              height: rh(mobile: 30, tablet: 25, desktop: 20),
              decoration: BoxDecoration(
                color: screenInfo.when<Color>(
                  mobile: Colors.blue,
                  tablet: Colors.green,
                  desktop: Colors.purple,
                ),
                borderRadius: BorderRadius.circular(
                  rradius(mobile: 8, tablet: 12, desktop: 16),
                ),
              ),
              child: Center(
                child: Text(
                  screenInfo.when<String>(
                    mobile: 'Vista Móvil',
                    tablet: 'Vista Tablet',
                    desktop: 'Vista Desktop',
                  ),
                  style: TextStyle(
                    fontSize: rsp(mobile: 4, tablet: 3.5, desktop: 3),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Card Responsive con Múltiples Plataformas

```dart
class ResponsiveCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  
  const ResponsiveCard({
    required this.title,
    required this.description,
    required this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    final screenInfo = ScreenInfo.of(context);
    
    return Card(
      elevation: screenInfo.when<double>(
        mobile: 2,
        tablet: 4,
        desktop: 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          rradius(mobile: 8, tablet: 12, desktop: 16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          rsize(mobile: 16, tablet: 20, desktop: 24),
        ),
        child: screenInfo.isMobile
            ? _buildMobileLayout()
            : _buildTabletDesktopLayout(),
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    return Column(
      children: [
        Icon(
          icon,
          size: rsize(mobile: 40),
          color: Colors.blue,
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: TextStyle(
            fontSize: rsp(mobile: 4),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          description,
          style: TextStyle(fontSize: rsp(mobile: 3)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildTabletDesktopLayout() {
    return Row(
      children: [
        Icon(
          icon,
          size: rsize(tablet: 48, desktop: 56),
          color: Colors.blue,
        ),
        SizedBox(width: rsize(tablet: 16, desktop: 24)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: rsp(tablet: 3.5, desktop: 3),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                description,
                style: TextStyle(fontSize: rsp(tablet: 2.8, desktop: 2.5)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

### Form Responsive Multi-plataforma

```dart
class ResponsiveForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return Padding(
          padding: EdgeInsets.all(
            rsize(mobile: 16, tablet: 24, desktop: 32),
          ),
          child: Column(
            children: [
              _buildTextField(
                label: 'Nombre',
                icon: Icons.person,
              ),
              SizedBox(height: rsize(mobile: 12, tablet: 16, desktop: 20)),
              _buildTextField(
                label: 'Email',
                icon: Icons.email,
              ),
              SizedBox(height: rsize(mobile: 12, tablet: 16, desktop: 20)),
              _buildTextField(
                label: 'Contraseña',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: rsize(mobile: 24, tablet: 32, desktop: 40)),
              SizedBox(
                width: rw(mobile: 100, tablet: 50, desktop: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: rsize(mobile: 14, tablet: 16, desktop: 18),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        rradius(mobile: 8, tablet: 10, desktop: 12),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Enviar',
                    style: TextStyle(
                      fontSize: rsp(mobile: 3.5, tablet: 3, desktop: 2.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(fontSize: rsp(mobile: 3.5, tablet: 3, desktop: 2.8)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: rsp(mobile: 3, tablet: 2.8, desktop: 2.5)),
        prefixIcon: Icon(
          icon,
          size: rsize(mobile: 20, tablet: 22, desktop: 24),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            rradius(mobile: 8, tablet: 10, desktop: 12),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: rsize(mobile: 16, tablet: 18, desktop: 20),
          vertical: rsize(mobile: 14, tablet: 16, desktop: 18),
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

## ⚠️ Troubleshooting

### Error: "Missing ScreenSizeInitializer"

**Problema:** Las extensiones lanzan error sobre inicializador faltante.

**Solución:** Asegúrate de envolver tu `MaterialApp` con `ScreenSizeInitializer`:

```dart
ScreenSizeInitializer(
  child: MaterialApp(...),
)
```

### Comportamiento inesperado en multi-plataforma

**Problema:** Los valores multi-plataforma no se aplican correctamente.

**Solución:** Verifica el orden de precedencia:
1. Plataforma específica (`ios`, `android`, `web`)
2. Categoría (`mobile`, `tablet`, `desktop`)

```dart
// Correcto: iOS tendrá 95, Android 85
rw(mobile: 80, ios: 95, android: 85)

// El valor mobile no se aplica si hay ios/android específico
```

### Las extensiones simples (.w, .h, .sp) no se adaptan a plataforma

**Problema:** Esperaba valores diferentes por plataforma usando `.w`, `.h`, `.sp`.

**Solución:** Las extensiones simples son para valores únicos. Usa las funciones multi-plataforma:

```dart
// ❌ Esto no funcionará
Container(width: 80.w)  // Siempre será 80%

// ✅ Para valores específicos por plataforma
Container(width: rw(mobile: 90, tablet: 70, desktop: 50))
```

## 📦 Desarrollo Local

### Estructura del proyecto

```
lib/
├── leulit_flutter_fullresponsive.dart    # API principal
├── core/
│   └── screen_scaler_inherited_widget.dart # InheritedWidget
└── domain/
    └── screen_info.dart                  # Modelo y helpers
```

### Instalación local

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

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

## 📖 Documentación Adicional

- [CHANGELOG.md](CHANGELOG.md) - Historial de cambios
- [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Guía de migración desde v2.x
- [USAGE_EXAMPLES.md](USAGE_EXAMPLES.md) - Ejemplos exhaustivos de uso

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👥 Autor

Desarrollado por [Leulit](https://github.com/leulit)

## 🔗 Enlaces Útiles

- [pub.dev](https://pub.dev/packages/leulit_flutter_fullresponsive)
- [GitHub Repository](https://github.com/leulit/leulit_flutter_fullresponsive)
- [Documentación de Flutter](https://flutter.dev/docs)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

---

**¡Disfruta construyendo aplicaciones responsive! 🚀**