# Leulit Flutter Full Responsive - Example

This example demonstrates all the features of the `leulit_flutter_fullresponsive` package.

## Features Demonstrated

### 1. Basic Extensions (.w, .h, .sp)
- Percentage format (0-100): `80.w(context)`, `50.h(context)`
- Decimal format (0-1): `0.8.w(context)`, `0.5.h(context)`
- Font scaling with accessibility support: `3.sp(context)`

### 2. Multi-Platform Functions
- Platform-specific values: `w(context, web: 0.4, mobile: 0.9, tablet: 0.6)`
- Automatic device detection and adaptation
- Fallback values for unsupported platforms

### 3. Specialized Extensions
- **ResponsiveSize**: `24.size(context)` for icons, padding, margins
- **ResponsiveRadius**: `12.radius(context)` for border radius
- **ResponsiveFlex**: `3.flexValue(context)` for adaptive layouts

### 4. Practical Implementation
- Complete responsive dashboard example
- Real-world usage patterns
- Performance-optimized architecture

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run the example:
```bash
flutter run
```

## Navigation

The example app has 4 tabs:

- **Basic**: Demonstrates fundamental .w(), .h(), .sp() usage
- **Multi-Platform**: Shows platform-specific responsive values
- **Extensions**: Explores specialized extensions (size, radius, flex)
- **Practical**: Real-world implementation example

## Key Concepts

### Responsive Design Philosophy
All measurements adapt to:
- Screen size (width/height)
- Device type (mobile/tablet/desktop)
- Platform (iOS/Android/Web)
- User accessibility settings

### Performance
- Uses Flutter's InheritedWidget for efficient propagation
- Zero overhead for value calculations
- Optimized for high-frequency usage

## Code Examples

### Basic Usage
```dart
Container(
  width: 80.w(context),        // 80% width
  height: 50.h(context),       // 50% height
  child: Text(
    'Responsive Text',
    style: TextStyle(
      fontSize: 3.sp(context),  // Accessible font size
    ),
  ),
)
```

### Multi-Platform
```dart
Container(
  width: w(context,
    web: 0.4,      // 40% on web
    mobile: 0.9,   // 90% on mobile
    tablet: 0.6,   // 60% on tablet
    fallback: 0.7, // 70% default
  ),
)
```

### Specialized Extensions
```dart
// Icons and UI elements
Icon(Icons.star, size: 24.size(context))

// Border radius
BorderRadius.circular(12.radius(context))

// Flexible layouts
Expanded(flex: 3.flexValue(context), child: widget)
```

## Learn More

- [Package Documentation](https://pub.dev/packages/leulit_flutter_fullresponsive)
- [API Reference](https://pub.dev/documentation/leulit_flutter_fullresponsive/latest/)
- [GitHub Repository](https://github.com/leulit/leulit_flutter_fullresponsive)