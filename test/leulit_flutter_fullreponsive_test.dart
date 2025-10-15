import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leulit_flutter_fullresponsive/leulit_flutter_fullresponsive.dart';

void main() {
  group('ScreenScale Extension Tests', () {
    testWidgets('should handle percentage values (0-100)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: SizedBox(
                    width: 50.w(context), // 50% del ancho
                    height: 25.h(context), // 25% del alto
                    child: const Text('Test'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      
      // Los valores exactos dependerán del tamaño del dispositivo de test
      // Verificamos que sean valores positivos y proporcionales
      final width50 = 50.w(context);
      final width25 = 25.w(context);
      final height50 = 50.h(context);
      final height25 = 25.h(context);
      
      expect(width50, greaterThan(0));
      expect(width25, greaterThan(0));
      expect(height50, greaterThan(0));
      expect(height25, greaterThan(0));
      
      // 50% debe ser el doble de 25%
      expect(width50 / width25, closeTo(2.0, 0.01));
      expect(height50 / height25, closeTo(2.0, 0.01));
    });

    testWidgets('should handle decimal values (0-1)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: SizedBox(
                    width: 0.5.w(context), // 50% del ancho
                    height: 0.25.h(context), // 25% del alto
                    child: const Text('Test'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      
      // Verificar que los valores decimales den el mismo resultado que los porcentajes
      expect(0.5.w(context), equals(50.w(context))); // 0.5 = 50%
      expect(0.25.h(context), equals(25.h(context))); // 0.25 = 25%
    });

    testWidgets('should handle high precision decimal values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: SizedBox(
                    width: 0.076543.w(context), // Valor muy preciso
                    height: 0.123456.h(context), // Valor muy preciso
                    child: const Text('Test'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(SizedBox));
      
      // Verificar que los valores de alta precisión sean positivos y proporcionales
      final preciseWidth = 0.076543.w(context);
      final preciseHeight = 0.123456.h(context);
      final baseWidth = 0.1.w(context); // 10%
      final baseHeight = 0.1.h(context); // 10%
      
      expect(preciseWidth, greaterThan(0));
      expect(preciseHeight, greaterThan(0));
      expect(preciseWidth, lessThan(baseWidth)); // 7.6543% < 10%
      expect(preciseHeight, greaterThan(baseHeight)); // 12.3456% > 10%
    });

    testWidgets('should handle sp (font size) with both formats', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Text(
                    'Test',
                    style: TextStyle(fontSize: 4.sp(context)),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Text));
      
      // Verificar que sp produzca valores positivos
      final spValue = 4.sp(context);
      final spDecimal = 0.01.sp(context);
      
      expect(spValue, greaterThan(0));
      expect(spDecimal, greaterThan(0));
      
      // Los valores decimales para sp deberían ser diferentes a los porcentajes
      expect(spDecimal, isNot(equals(spValue)));
    });

    testWidgets('should throw error when ScreenSizeInitializer is missing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Container();
            },
          ),
        ),
      );

      final context = tester.element(find.byType(Container));
      
      // Verificar que se lance el error cuando no está inicializado
      expect(() => 50.w(context), throwsA(isA<FlutterError>()));
      expect(() => 50.h(context), throwsA(isA<FlutterError>()));
      expect(() => 4.sp(context), throwsA(isA<FlutterError>()));
    });

    test('normalize value function logic', () {
      // Test de la lógica de normalización sin widgets
      // Simulamos el comportamiento de _normalizeValue
      double normalizeValue(num value) {
        return value <= 1 ? value.toDouble() : value.toDouble() / 100;
      }
      
      // Valores decimales (0-1)
      expect(normalizeValue(0.5), equals(0.5));
      expect(normalizeValue(0.25), equals(0.25));
      expect(normalizeValue(0.076543), equals(0.076543));
      expect(normalizeValue(1), equals(1.0));
      
      // Valores porcentaje (>1)
      expect(normalizeValue(50), equals(0.5));
      expect(normalizeValue(25), equals(0.25));
      expect(normalizeValue(100), equals(1.0));
      expect(normalizeValue(7.6543), equals(0.076543));
    });

    testWidgets('should handle multi-platform width extension method', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: SizedBox(
                    // Usando el extension method unificado con parámetros multi-plataforma
                    width: 60.w(context, web: 30, mobile: 80, tablet: 50),
                    child: const Text('Test'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Text));
      
      // Verificar que la función retorna un valor positivo
      final multiPlatformWidth = 60.w(context, web: 30, mobile: 80, tablet: 50);
      expect(multiPlatformWidth, greaterThan(0));
      
      // Verificar uso básico (sin parámetros multi-plataforma)
      final basicWidth = 50.w(context);
      expect(basicWidth, greaterThan(0));
      
      // Verificar con formato decimal
      final decimalWidth = 0.5.w(context, web: 0.3, mobile: 0.8);
      expect(decimalWidth, greaterThan(0));
    });

    testWidgets('should handle multi-platform height extension method', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: SizedBox(
                    height: 35.h(context, web: 20, mobile: 40, tablet: 30),
                    child: const Text('Test'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Text));
      
      // Verificar que la función retorna un valor positivo
      final multiPlatformHeight = 35.h(context, web: 20, mobile: 40, tablet: 30);
      expect(multiPlatformHeight, greaterThan(0));
      
      // Verificar uso básico (sin parámetros multi-plataforma)
      final basicHeight = 25.h(context);
      expect(basicHeight, greaterThan(0));
      
      // Verificar con formato decimal
      final decimalHeight = 0.25.h(context, web: 0.2, mobile: 0.4);
      expect(decimalHeight, greaterThan(0));
    });

    testWidgets('should handle multi-platform font size extension method', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Text(
                    'Test',
                    style: TextStyle(
                      fontSize: 3.sp(context, web: 2, mobile: 4, tablet: 3),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Text));
      
      // Verificar que la función retorna un valor positivo
      final multiPlatformSp = 3.sp(context, web: 2, mobile: 4, tablet: 3);
      expect(multiPlatformSp, greaterThan(0));
      
      // Verificar uso básico (sin parámetros multi-plataforma)
      final basicSp = 3.sp(context);
      expect(basicSp, greaterThan(0));
      
      // Verificar con formato decimal
      final decimalSp = 0.025.sp(context, web: 0.02, mobile: 0.04);
      expect(decimalSp, greaterThan(0));
    });

    testWidgets('performance test: DeviceType should be calculated only once', (WidgetTester tester) async {
      // Test que verifica que múltiples llamadas no recalculan DeviceType
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                // Simulamos múltiples llamadas a extension methods con parámetros multi-plataforma
                // Si DeviceType se calculara en cada llamada, esto sería lento
                final width1 = 15.w(context, web: 10, mobile: 20);
                final width2 = 25.w(context, web: 20, mobile: 30);
                final height1 = 8.h(context, web: 5, mobile: 10);
                final height2 = 12.h(context, web: 10, mobile: 15);
                final fontSize1 = 2.sp(context, web: 1.5, mobile: 2.5);
                final fontSize2 = 3.sp(context, web: 2.5, mobile: 3.5);
                
                return Scaffold(
                  body: SizedBox(
                    width: width1 + width2,
                    height: height1 + height2,
                    child: Text(
                      'Performance Test',
                      style: TextStyle(fontSize: fontSize1 + fontSize2),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Text));

      // Test de rendimiento: múltiples llamadas deben ser rápidas
      // porque DeviceType ya está calculado en ScreenInfo
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < 1000; i++) {
        // Múltiples llamadas usando extension methods con parámetros multi-plataforma
        15.w(context, web: 10, mobile: 20);
        8.h(context, web: 5, mobile: 10);
        2.sp(context, web: 1.5, mobile: 2.5);
      }
      
      stopwatch.stop();
      
      // Si toma menos de 100ms para 1000 llamadas, la optimización funciona
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      expect(find.text('Performance Test'), findsOneWidget);
    });
  });

  group('ResponsiveSize Extension Tests', () {
    testWidgets('should calculate responsive icon sizes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Icon(
                    Icons.star,
                    size: 24.size(context),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Icon));
      
      final size24 = 24.size(context);
      final size12 = 12.size(context);
      
      expect(size24, greaterThan(0));
      expect(size12, greaterThan(0));
      expect(size24 / size12, closeTo(2.0, 0.01)); // 24 debe ser doble de 12
    });

    testWidgets('should handle sizeFor multi-platform values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Icon(
                    Icons.home,
                    size: 20.sizeFor(context, mobile: 16, tablet: 24, desktop: 32),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Icon));
      final size = 20.sizeFor(context, mobile: 16, tablet: 24, desktop: 32);
      
      expect(size, greaterThan(0));
    });
  });

  group('ResponsiveRadius Extension Tests', () {
    testWidgets('should calculate responsive border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.radius(context)),
                    ),
                    child: const Text('Rounded Container'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Container));
      
      final radius12 = 12.radius(context);
      final radius6 = 6.radius(context);
      
      expect(radius12, greaterThan(0));
      expect(radius6, greaterThan(0));
      expect(radius12 / radius6, closeTo(2.0, 0.01)); // 12 debe ser doble de 6
    });

    testWidgets('should handle radiusFor multi-platform values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8.radiusFor(context, mobile: 4, tablet: 12, desktop: 16)
                      ),
                    ),
                    child: const Text('Multi-platform Radius'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Container));
      final radius = 8.radiusFor(context, mobile: 4, tablet: 12, desktop: 16);
      
      expect(radius, greaterThan(0));
    });
  });

  group('ResponsiveFlex Extension Tests', () {
    testWidgets('should calculate responsive flex values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Row(
                    children: [
                      Expanded(
                        flex: 3.flexValue(context),
                        child: Container(color: Colors.red),
                      ),
                      Expanded(
                        flex: 2.flexValue(context),
                        child: Container(color: Colors.blue),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Row));
      
      final flex3 = 3.flexValue(context);
      final flex2 = 2.flexValue(context);
      
      expect(flex3, greaterThan(0));
      expect(flex2, greaterThan(0));
      expect(flex3, greaterThanOrEqualTo(3));
      expect(flex2, greaterThanOrEqualTo(2));
    });

    testWidgets('should handle flexFor multi-platform values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Row(
                    children: [
                      Expanded(
                        flex: 4.flexFor(context, mobile: 2, tablet: 6, desktop: 8),
                        child: Container(color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Row));
      final flex = 4.flexFor(context, mobile: 2, tablet: 6, desktop: 8);
      
      expect(flex, greaterThan(0));
      expect(flex, greaterThanOrEqualTo(2)); // Al menos el valor mobile mínimo
    });
  });

}
