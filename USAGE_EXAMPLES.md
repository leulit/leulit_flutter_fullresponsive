# Ejemplos de Uso - leulit_flutter_fullreponsive

## 📋 Índice

1. [Configuración Básica](#configuración-básica)
2. [API Simple (Sin context)](#api-simple-sin-context)
3. [API Multi-Plataforma](#api-multi-plataforma)
4. [Breakpoints Personalizados](#breakpoints-personalizados)
5. [Helpers Condicionales](#helpers-condicionales)
6. [Widgets Responsivos](#widgets-responsivos)
7. [Casos de Uso Completos](#casos-de-uso-completos)

---

## Configuración Básica

```dart
import 'package:flutter/material.dart';
import 'package:leulit_flutter_fullreponsive/leulit_flutter_fullreponsive.dart';

void main() {
  runApp(
    ScreenSizeInitializer(
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
```

---

## API Simple (Sin context)

### Uso más común (90% de los casos)

```dart
Container(
  width: 80.w,           // 80% del ancho
  height: 30.h,          // 30% del alto
  padding: EdgeInsets.all(16.size),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.radius),
  ),
  child: Text(
    'Hello World',
    style: TextStyle(fontSize: 16.sp),
  ),
)
```

### Valores decimales

```dart
Container(
  width: 0.8.w,    // Equivale a 80.w
  height: 0.3.h,   // Equivale a 30.h
)
```

---

## API Multi-Plataforma

### Funciones `rw()`, `rh()`, `rsp()`, etc.

Cuando necesitas valores diferentes por plataforma:

```dart
Container(
  // Ancho responsive con variaciones
  width: rw(
    mobile: 90,      // 90% en móviles
    tablet: 70,      // 70% en tablets
    desktop: 50,     // 50% en desktop
  ),
  
  // Alto responsive con variaciones
  height: rh(
    mobile: 40,
    tablet: 30,
    desktop: 25,
  ),
  
  // Padding responsive
  padding: EdgeInsets.all(
    rsize(
      mobile: 16,
      tablet: 20,
      desktop: 24,
    ),
  ),
  
  // Border radius responsive
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(
      rradius(mobile: 12, tablet: 10, desktop: 8),
    ),
  ),
  
  child: Text(
    'Hello',
    style: TextStyle(
      // Font size responsive
      fontSize: rsp(
        mobile: 16,
        tablet: 14,
        desktop: 12,
      ),
    ),
  ),
)
```

### Plataformas específicas (iOS, Android, Web)

```dart
Container(
  width: rw(
    ios: 95,         // Específico para iOS
    android: 90,     // Específico para Android
    tablet: 70,      // Tablets (cualquier OS)
    web: 50,         // Específico para Web
  ),
  
  padding: EdgeInsets.all(
    rsize(
      ios: 18,       // iOS tiene más padding
      android: 16,   // Android padding estándar
      web: 14,       // Web padding reducido
    ),
  ),
)
```

### Flex values responsive

```dart
Row(
  children: [
    Expanded(
      flex: rflexValue(
        mobile: 2,
        tablet: 3,
        desktop: 4,
      ),
      child: Container(...),
    ),
    Expanded(
      flex: rflexValue(
        mobile: 1,
        tablet: 2,
        desktop: 3,
      ),
      child: Container(...),
    ),
  ],
)
```

---

## Breakpoints Personalizados

### Configurar breakpoints custom

```dart
void main() {
  runApp(
    ScreenSizeInitializer(
      // Configurar tus propios breakpoints
      breakpoints: ResponsiveBreakpoints(
        mobile: 0,       // 0-599px
        tablet: 600,     // 600-1199px
        desktop: 1200,   // 1200px+
      ),
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
```

### Breakpoints para diseños específicos

```dart
// Para un diseño que necesita 3 columnas antes
ScreenSizeInitializer(
  breakpoints: ResponsiveBreakpoints(
    mobile: 0,
    tablet: 800,      // Tablet a partir de 800px
    desktop: 1440,    // Desktop a partir de 1440px
  ),
  child: MaterialApp(...),
)
```

---

## Helpers Condicionales

### Getters de ScreenInfo (sin context)

```dart
final info = ScreenInfoManager().info;

// Checks de tipo de dispositivo
if (info.isMobile) {
  // Código para móviles
}

if (info.isTablet) {
  // Código para tablets
}

if (info.isDesktop) {
  // Código para desktop
}

// Checks de plataforma específica
if (info.isMobileIOS) {
  // Código específico para iOS móvil
}

if (info.isMobileAndroid) {
  // Código específico para Android móvil
}

if (info.isWeb) {
  // Código específico para web
}

// Checks de orientación
if (info.isPortrait) {
  // Modo portrait
}

if (info.isLandscape) {
  // Modo landscape
}

// Checks de rangos
if (info.widthBetween(600, 1200)) {
  // Ancho entre 600 y 1200px
}
```

### Método `.when()`

```dart
final info = ScreenInfoManager().info;

final padding = info.when<double>(
  mobile: () => 16.0,
  tablet: () => 20.0,
  desktop: () => 24.0,
);

final widget = info.when<Widget>(
  mobile: () => MobileLayout(),
  tablet: () => TabletLayout(),
  desktop: () => DesktopLayout(),
);
```

---

## Widgets Responsivos

### ResponsiveWidget

Renderiza diferentes widgets según el dispositivo:

```dart
ResponsiveWidget(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

Con fallbacks automáticos:

```dart
ResponsiveWidget(
  mobile: MobileLayout(),
  desktop: DesktopLayout(),
  // tablet usará mobile como fallback automáticamente
)
```

Plataformas específicas:

```dart
ResponsiveWidget(
  ios: IOSSpecificLayout(),
  android: AndroidSpecificLayout(),
  web: WebSpecificLayout(),
  // Con fallbacks si es necesario
  mobile: GenericMobileLayout(),
)
```

### ResponsiveBuilder

Para lógica más compleja:

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

Con lógica avanzada:

```dart
ResponsiveBuilder(
  builder: (context, screenInfo) {
    // Ultra wide screens
    if (screenInfo.width > 1920) {
      return UltraWideLayout();
    }
    
    // Tablet en landscape
    if (screenInfo.isTablet && screenInfo.isLandscape) {
      return TabletLandscapeLayout();
    }
    
    // Default
    return screenInfo.when(
      mobile: () => MobileLayout(),
      tablet: () => TabletLayout(),
      desktop: () => DesktopLayout(),
    );
  },
)
```

---

## Casos de Uso Completos

### 1. Card Responsive Completo

```dart
Container(
  width: rw(mobile: 90, tablet: 45, desktop: 30),
  margin: EdgeInsets.all(rsize(mobile: 16, tablet: 20, desktop: 24)),
  padding: EdgeInsets.all(rsize(mobile: 16, tablet: 20, desktop: 24)),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(
      rradius(mobile: 12, tablet: 16, desktop: 20),
    ),
    boxShadow: [
      BoxShadow(
        blurRadius: rsize(mobile: 8, tablet: 12, desktop: 16),
        offset: Offset(0, 4),
        color: Colors.black12,
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Título',
        style: TextStyle(
          fontSize: rsp(mobile: 18, tablet: 20, desktop: 24),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: rsize(mobile: 12, tablet: 16, desktop: 20)),
      Text(
        'Descripción del contenido...',
        style: TextStyle(
          fontSize: rsp(mobile: 14, tablet: 15, desktop: 16),
        ),
      ),
    ],
  ),
)
```

### 2. Layout Adaptativo Completo

```dart
ResponsiveBuilder(
  builder: (context, screenInfo) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi App',
          style: TextStyle(
            fontSize: rsp(mobile: 18, tablet: 20, desktop: 24),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(
          rsize(mobile: 16, tablet: 24, desktop: 32),
        ),
        child: screenInfo.isMobile
            ? _buildMobileLayout()
            : screenInfo.isTablet
                ? _buildTabletLayout()
                : _buildDesktopLayout(),
      ),
    );
  },
)

Widget _buildMobileLayout() {
  return Column(
    children: [
      // Layout móvil (1 columna)
      Container(width: 100.w, height: 30.h, color: Colors.blue),
      SizedBox(height: 16.size),
      Container(width: 100.w, height: 50.h, color: Colors.green),
    ],
  );
}

Widget _buildTabletLayout() {
  return Row(
    children: [
      // Layout tablet (2 columnas)
      Expanded(
        flex: rflexValue(tablet: 1),
        child: Container(height: 80.h, color: Colors.blue),
      ),
      SizedBox(width: 16.size),
      Expanded(
        flex: rflexValue(tablet: 2),
        child: Container(height: 80.h, color: Colors.green),
      ),
    ],
  );
}

Widget _buildDesktopLayout() {
  return Row(
    children: [
      // Layout desktop (3 columnas)
      Expanded(
        flex: rflexValue(desktop: 1),
        child: Container(height: 80.h, color: Colors.blue),
      ),
      SizedBox(width: 24.size),
      Expanded(
        flex: rflexValue(desktop: 2),
        child: Container(height: 80.h, color: Colors.green),
      ),
      SizedBox(width: 24.size),
      Expanded(
        flex: rflexValue(desktop: 1),
        child: Container(height: 80.h, color: Colors.orange),
      ),
    ],
  );
}
```

### 3. Formulario Adaptativo

```dart
Form(
  child: Column(
    children: [
      TextFormField(
        style: TextStyle(
          fontSize: rsp(mobile: 14, tablet: 15, desktop: 16),
        ),
        decoration: InputDecoration(
          labelText: 'Email',
          contentPadding: EdgeInsets.all(
            rsize(mobile: 16, tablet: 18, desktop: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              rradius(mobile: 8, tablet: 10, desktop: 12),
            ),
          ),
        ),
      ),
      SizedBox(height: rsize(mobile: 16, tablet: 20, desktop: 24)),
      TextFormField(
        style: TextStyle(
          fontSize: rsp(mobile: 14, tablet: 15, desktop: 16),
        ),
        decoration: InputDecoration(
          labelText: 'Password',
          contentPadding: EdgeInsets.all(
            rsize(mobile: 16, tablet: 18, desktop: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              rradius(mobile: 8, tablet: 10, desktop: 12),
            ),
          ),
        ),
      ),
      SizedBox(height: rsize(mobile: 24, tablet: 28, desktop: 32)),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: rsize(mobile: 32, tablet: 40, desktop: 48),
            vertical: rsize(mobile: 12, tablet: 14, desktop: 16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              rradius(mobile: 8, tablet: 10, desktop: 12),
            ),
          ),
        ),
        onPressed: () {},
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: rsp(mobile: 16, tablet: 17, desktop: 18),
          ),
        ),
      ),
    ],
  ),
)
```

### 4. Grid Responsive

```dart
ResponsiveBuilder(
  builder: (context, screenInfo) {
    final crossAxisCount = screenInfo.when(
      mobile: () => 2,
      tablet: () => 3,
      desktop: () => 4,
    );
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: rsize(mobile: 12, tablet: 16, desktop: 20),
        mainAxisSpacing: rsize(mobile: 12, tablet: 16, desktop: 20),
      ),
      padding: EdgeInsets.all(
        rsize(mobile: 16, tablet: 24, desktop: 32),
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(
              rradius(mobile: 8, tablet: 12, desktop: 16),
            ),
          ),
          child: Center(
            child: Text(
              'Item $index',
              style: TextStyle(
                fontSize: rsp(mobile: 14, tablet: 16, desktop: 18),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  },
)
```

---

## 🎯 Resumen de APIs

### API Simple (sin variaciones)
- `80.w` - Ancho 80%
- `30.h` - Alto 30%
- `16.sp` - Font size
- `24.size` - Tamaño (padding, icon)
- `12.radius` - Border radius
- `3.flexValue` - Flex value

### API Multi-Plataforma (con variaciones)
- `rw()` - Ancho con variaciones
- `rh()` - Alto con variaciones
- `rsp()` - Font size con variaciones
- `rsize()` - Tamaño con variaciones
- `rradius()` - Border radius con variaciones
- `rflexValue()` - Flex value con variaciones

### Widgets
- `ResponsiveWidget` - Renderiza diferentes widgets por dispositivo
- `ResponsiveBuilder` - Builder con acceso a `ScreenInfo`

### Helpers
- `ScreenInfoManager().info` - Acceso al ScreenInfo actual
- Helpers: `.isMobile`, `.isTablet`, `.isDesktop`, etc.
- Método `.when()` - Valores condicionales por dispositivo

---

## ✅ Mejores Prácticas

1. **Usa API simple para casos comunes** (80.w, 30.h, etc.)
2. **Usa API multi-plataforma solo cuando necesites variaciones** específicas por dispositivo
3. **Configura breakpoints personalizados** si tu diseño lo requiere
4. **Usa ResponsiveWidget** para layouts completamente diferentes
5. **Usa ResponsiveBuilder** para lógica condicional compleja
6. **Los helpers de ScreenInfo** son ideales para checks rápidos sin context
