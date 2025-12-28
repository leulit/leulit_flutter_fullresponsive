# 🔄 Guía de Migración a v2.0.0

## ✨ Nueva API sin Context

La versión 2.0.0 introduce una nueva API simplificada que **elimina la necesidad de pasar `context`** a las extensiones responsive.

### 🎯 Motivación

**ANTES (v1.x - Deprecated):**
```dart
SizedBox(width: 0.5.w(context))
Text('Hola', style: TextStyle(fontSize: 3.sp(context)))
Icon(Icons.star, size: 24.size(context))
```

**AHORA (v2.0.0 - Recomendado):**
```dart
SizedBox(width: 0.5.w)
Text('Hola', style: TextStyle(fontSize: 3.sp))
Icon(Icons.star, size: 24.size)
```

### 📋 Cambios Principales

#### 1. Extensión `ScreenScale` (w, h, sp)

| Versión | API | Estado |
|---------|-----|--------|
| v1.x | `.w(context)` → ahora `.wWithContext(context)` | ⚠️ Deprecated |
| v2.0 | `.w` | ✅ Recomendado |

**Importante:** Los métodos antiguos fueron renombrados con el sufijo `WithContext` para permitir la coexistencia de ambas APIs:
- `.w(context)` → `.wWithContext(context)` (deprecated)
- `.h(context)` → `.hWithContext(context)` (deprecated)  
- `.sp(context)` → `.spWithContext(context)` (deprecated)

```dart
// ❌ API Antigua (Deprecated)
Container(
  width: 80.wWithContext(context),
  height: 50.hWithContext(context),
  child: Text('Hola', style: TextStyle(fontSize: 3.spWithContext(context))),
)

// ✅ API Nueva (v2.0.0)
Container(
  width: 80.w,
  height: 50.h,
  child: Text('Hola', style: TextStyle(fontSize: 3.sp)),
)
```

#### 2. Extensión `ResponsiveSize` (size)

```dart
// ❌ Deprecated
Icon(Icons.star, size: 24.sizeWithContext(context))
padding: EdgeInsets.all(16.sizeWithContext(context))

// ✅ Nueva API
Icon(Icons.star, size: 24.size)
padding: EdgeInsets.all(16.size)
```

#### 3. Extensión `ResponsiveRadius` (radius)

```dart
// ❌ Deprecated
BorderRadius.circular(12.radiusWithContext(context))

// ✅ Nueva API
BorderRadius.circular(12.radius)
```

#### 4. Extensión `ResponsiveFlex` (flexValue)

```dart
// ❌ Deprecated
Expanded(flex: 3.flexValueWithContext(context), child: widget)

// ✅ Nueva API
Expanded(flex: 3.flexValue, child: widget)
```

### 🔧 Cómo Migrar

#### Paso 1: Asegúrate de tener `ScreenSizeInitializer`

El singleton requiere que inicialices tu app con `ScreenSizeInitializer` (igual que antes):

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeInitializer(  // ✅ Requerido
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}
```

#### Paso 2: Actualiza tu código

**Opción A - Si usabas la API sin parámetros:**

Tu código existente `.w(context)` ahora mostrará un warning de deprecación. Simplemente remueve `(context)`:

```dart
// Antes
width: 50.w(context)

// Después  
width: 50.w
```

**Opción B - Si usabas parámetros multi-plataforma:**

Los métodos con parámetros multi-plataforma fueron renombrados con sufijo `WithContext` (deprecated):

```dart
// Antes (v1.x)
width: 50.w(context, web: 30, mobile: 80)

// Ahora (v2.0 - deprecated pero funcional)
width: 50.wWithContext(context, web: 30, mobile: 80)

// Recomendado (v2.0)
width: 50.w  // Usa valor adaptativo automático
```

Para búsqueda y reemplazo masivo en tu IDE:

| Buscar (Regex) | Reemplazar con | Notas |
|----------------|----------------|-------|
| `\.w\(context\)` | `.w` | Sin parámetros |
| `\.h\(context\)` | `.h` | Sin parámetros |
| `\.sp\(context\)` | `.sp` | Sin parámetros |
| `\.size\(context\)` | `.size` | Sin parámetros |
| `\.radius\(context\)` | `.radius` | Sin parámetros |
| `\.flexValue\(context\)` | `.flexValue` | Sin parámetros |

#### Paso 3 (Opcional): Migrar parámetros multi-plataforma

⚠️ **Nota:** Los métodos con parámetros multi-plataforma (`web:`, `mobile:`, etc.) siguen disponibles pero están **deprecated** como `wWithContext()`, `hWithContext()`, etc.

Si usabas esta funcionalidad:

```dart
// ❌ v1.x (ya no compila)
width: 50.w(context, web: 30, mobile: 80, tablet: 60)

// ⚠️ v2.0 (deprecated pero funcional)
width: 50.wWithContext(context, web: 30, mobile: 80, tablet: 60)

// ✅ Opción 1: Usa valores por defecto adaptativos (Recomendado)
width: 50.w  // Se ajusta automáticamente según el dispositivo

// ✅ Opción 2: Usa condicionales explícitos si necesitas control fino
width: ScreenInfoManager().info.deviceType == DeviceType.web ? 30.w : 50.w

// ✅ Opción 3: Helper personalizado
width: _getResponsiveWidth()

double _getResponsiveWidth() {
  final deviceType = ScreenInfoManager().info.deviceType;
  switch (deviceType) {
    case DeviceType.web:
      return 30.w;
    case DeviceType.mobile:
      return 80.w;
    case DeviceType.tablet:
      return 60.w;
    default:
      return 50.w;
  }
}
```

### ⚠️ Advertencias de Deprecación

Al actualizar a v2.0.0, si usas la API antigua verás warnings:

```dart
// Si tienes código antiguo sin migrar
width: 50.w(context)  // ❌ Error: 'w' no acepta parámetros (es un getter ahora)

// La forma correcta ahora es:
width: 50.w  // ✅ Funciona

// O si necesitas multi-plataforma:
width: 50.wWithContext(context, web: 30, mobile: 80)  // ⚠️ Deprecated pero funciona
```

**Mensaje de warning típico:**
```
'wWithContext' is deprecated and shouldn't be used. 
Usa .w en su lugar (sin context). Será eliminado en v3.0.0
```

**Estos warnings NO romperán tu código**, pero te indican que debes migrar a la nueva API.

### 📅 Línea de Tiempo

- **v1.x (Actual):** API con `context` funcional
- **v2.0.0 (Ahora):** 
  - ✅ Nueva API sin `context` disponible
  - ⚠️ API antigua marcada como `@deprecated`
  - ⚙️ Ambas APIs funcionan simultáneamente
- **v3.0.0 (Futuro):** 
  - ❌ API antigua con `context` será eliminada
  - ✅ Solo API sin `context` disponible

### 🆘 Soporte

Si tienes problemas con la migración:

1. Verifica que `ScreenSizeInitializer` envuelva tu `MaterialApp`
2. Revisa que no haya errores de inicialización
3. Asegúrate de haber actualizado todas las referencias

### 📚 Recursos

- [README.md](README.md) - Documentación completa
- [example_usage.dart](example_usage.dart) - Ejemplos actualizados
- [CHANGELOG.md](CHANGELOG.md) - Historial de cambios
