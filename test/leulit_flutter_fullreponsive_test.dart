import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leulit_flutter_fullresponsive/leulit_flutter_fullreponsive.dart';

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

      final context = tester.element(find.byType(Container));
      
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

      final context = tester.element(find.byType(Container));
      
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

      final context = tester.element(find.byType(Container));
      
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
  });
}
