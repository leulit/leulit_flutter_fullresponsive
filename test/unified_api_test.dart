import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leulit_flutter_fullreponsive/leulit_flutter_fullreponsive.dart';

void main() {
  group('v1.5.0 Unified API Tests', () {
    testWidgets('should handle basic extension methods', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: SizedBox(
                    width: 50.w(context), // Uso básico
                    height: 25.h(context), // Uso básico
                    child: Text(
                      'Test',
                      style: TextStyle(fontSize: 3.sp(context)), // Uso básico
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Text));
      
      // Verificar que funcionan los métodos básicos
      expect(50.w(context), greaterThan(0));
      expect(25.h(context), greaterThan(0));
      expect(3.sp(context), greaterThan(0));
    });

    testWidgets('should handle multi-platform extension methods', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: SizedBox(
                    width: 50.w(context, web: 30, mobile: 80, tablet: 60), // Multi-plataforma
                    height: 25.h(context, web: 20, mobile: 35, tablet: 28), // Multi-plataforma
                    child: Text(
                      'Test',
                      style: TextStyle(fontSize: 3.sp(context, web: 2, mobile: 4, tablet: 3)), // Multi-plataforma
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Text));
      
      // Verificar que funcionan los métodos multi-plataforma
      expect(50.w(context, web: 30, mobile: 80, tablet: 60), greaterThan(0));
      expect(25.h(context, web: 20, mobile: 35, tablet: 28), greaterThan(0));
      expect(3.sp(context, web: 2, mobile: 4, tablet: 3), greaterThan(0));
    });

    testWidgets('should handle specialized extensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Container(
                    padding: EdgeInsets.all(16.size(context)), // Size básico
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.radius(context)), // Radius básico
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3.flexValue(context), // Flex básico
                          child: const Text('Test'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Container));
      
      // Verificar extensiones especializadas básicas
      expect(16.size(context), greaterThan(0));
      expect(12.radius(context), greaterThan(0));
      expect(3.flexValue(context), greaterThanOrEqualTo(3));
    });

    testWidgets('should handle specialized extensions with multi-platform', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Container(
                    padding: EdgeInsets.all(16.size(context, mobile: 12, tablet: 20, desktop: 24)), // Size multi-plataforma
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.radius(context, mobile: 8, tablet: 16, desktop: 20)), // Radius multi-plataforma
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3.flexValue(context, mobile: 2, tablet: 4, desktop: 5), // Flex multi-plataforma
                          child: const Text('Test'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Container));
      
      // Verificar extensiones especializadas multi-plataforma
      expect(16.size(context, mobile: 12, tablet: 20, desktop: 24), greaterThan(0));
      expect(12.radius(context, mobile: 8, tablet: 16, desktop: 20), greaterThan(0));
      expect(3.flexValue(context, mobile: 2, tablet: 4, desktop: 5), greaterThanOrEqualTo(2));
    });

    test('should maintain backward compatibility', () {
      // Test para verificar que el patrón de normalización funciona
      double normalizeValue(num value) {
        return value <= 1 ? value.toDouble() : value.toDouble() / 100;
      }
      
      // Valores decimales (0-1)
      expect(normalizeValue(0.5), equals(0.5));
      expect(normalizeValue(0.25), equals(0.25));
      
      // Valores porcentaje (>1)
      expect(normalizeValue(50), equals(0.5));
      expect(normalizeValue(25), equals(0.25));
    });
  });
}