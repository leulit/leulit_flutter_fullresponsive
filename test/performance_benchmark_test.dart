import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/leulit_flutter_fullresponsive.dart';

/// Benchmark para evaluar si la memoización aporta mejoras significativas
/// al rendimiento de las funciones responsive.
void main() {
  group('Performance Analysis - Current Implementation', () {
    late BuildContext context;
    
    setUpAll(() async {
      final tester = WidgetTester(binding: TestWidgetsFlutterBinding.ensureInitialized());
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (ctx) {
                context = ctx;
                return const Text('Benchmark');
              },
            ),
          ),
        ),
      );
    });

    test('Extension Methods Performance - 10,000 calls', () {
      final stopwatch = Stopwatch()..start();
      
      // Simular centenares de llamadas como en una app real
      for (int i = 0; i < 10000; i++) {
        // Valores típicos en una aplicación
        80.w(context);
        50.h(context);
        3.sp(context);
        
        // Diferentes valores para crear variedad
        final variance = i % 100;
        (70 + variance * 0.1).w(context);
        (40 + variance * 0.2).h(context);
        (2.5 + variance * 0.01).sp(context);
      }
      
      stopwatch.stop();
      print('Extension Methods - 10,000 calls: ${stopwatch.elapsedMilliseconds}ms');
      
      // Debería ser muy rápido si no hay overhead significativo
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    test('Multi-Platform Functions Performance - 10,000 calls', () {
      final stopwatch = Stopwatch()..start();
      
      // Simular centenares de llamadas multi-plataforma
      for (int i = 0; i < 10000; i++) {
        w(context, web: 0.4, mobile: 0.9, tablet: 0.6, fallback: 0.5);
        h(context, web: 0.3, mobile: 0.5, tablet: 0.4, fallback: 0.35);
        sp(context, web: 0.02, mobile: 0.04, tablet: 0.03, fallback: 0.025);
        
        // Variaciones para simular diferentes configuraciones
        final variance = i % 10;
        w(context, 
          web: 0.3 + variance * 0.01, 
          mobile: 0.8 + variance * 0.01,
          fallback: 0.5
        );
      }
      
      stopwatch.stop();
      print('Multi-Platform Functions - 10,000 calls: ${stopwatch.elapsedMilliseconds}ms');
      
      // Las funciones multi-plataforma son más complejas pero deberían ser eficientes
      expect(stopwatch.elapsedMilliseconds, lessThan(200));
    });

    test('ResponsiveSize Extension Performance - 10,000 calls', () {
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < 10000; i++) {
        24.size(context);
        16.size(context);
        12.radius(context);
        8.radius(context);
        3.flexValue(context);
        2.flexValue(context);
        
        // Variaciones multi-plataforma
        20.sizeFor(context, mobile: 18, tablet: 24, desktop: 32);
        8.radiusFor(context, mobile: 6, tablet: 12, desktop: 16);
      }
      
      stopwatch.stop();
      print('ResponsiveSize Extensions - 10,000 calls: ${stopwatch.elapsedMilliseconds}ms');
      
      expect(stopwatch.elapsedMilliseconds, lessThan(150));
    });

    test('Memory Usage Analysis', () {
      // Análisis de uso de memoria durante operaciones intensivas
      final stopwatch = Stopwatch()..start();
      final results = <double>[];
      
      // Simular una app con muchos widgets responsive
      for (int i = 0; i < 50000; i++) {
        results.add(80.w(context));
        results.add(50.h(context));
        results.add(3.sp(context));
        
        if (i % 1000 == 0) {
          // Limpiar ocasionalmente para simular condiciones reales
          results.clear();
        }
      }
      
      stopwatch.stop();
      print('Memory Usage Test - 50,000 calls: ${stopwatch.elapsedMilliseconds}ms');
      
      // El test no debería ser prohibitivamente lento
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });

  group('Performance Analysis - Bottleneck Identification', () {
    late BuildContext context;
    
    setUpAll(() async {
      final tester = WidgetTester(binding: TestWidgetsFlutterBinding.ensureInitialized());
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSizeInitializer(
            child: Builder(
              builder: (ctx) {
                context = ctx;
                return const Text('Bottleneck Analysis');
              },
            ),
          ),
        ),
      );
    });

    test('InheritedWidget.of() Lookup Performance', () {
      final stopwatch = Stopwatch()..start();
      
      // Test específico para medir el overhead de InheritedWidget.of()
      for (int i = 0; i < 10000; i++) {
        ScreenScalerInheritedWidget.of(context);
      }
      
      stopwatch.stop();
      print('InheritedWidget.of() - 10,000 lookups: ${stopwatch.elapsedMilliseconds}ms');
      
      // InheritedWidget.of() debería ser muy eficiente debido al cacheo de Flutter
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });

    test('Value Normalization Performance', () {
      final stopwatch = Stopwatch()..start();
      
      // Test del overhead de normalización
      final values = [0.8, 80, 0.5, 50, 0.3, 30, 0.9, 90];
      
      for (int i = 0; i < 10000; i++) {
        final value = values[i % values.length];
        // Simulamos la lógica de normalización
        final normalized = value <= 1 ? value.toDouble() : value.toDouble() / 100;
        // Evitar que el compilador optimice away la operación
        if (normalized < 0) print('unexpected');
      }
      
      stopwatch.stop();
      print('Value Normalization - 10,000 operations: ${stopwatch.elapsedMilliseconds}ms');
      
      // Operaciones aritméticas simples deberían ser extremadamente rápidas
      expect(stopwatch.elapsedMilliseconds, lessThan(10));
    });

    test('Map Creation Performance (Multi-Platform)', () {
      final stopwatch = Stopwatch()..start();
      
      // Test del overhead de crear Maps en funciones multi-plataforma
      for (int i = 0; i < 10000; i++) {
        final values = <DeviceType, num>{};
        values[DeviceType.web] = 0.4;
        values[DeviceType.mobile] = 0.9;
        values[DeviceType.tablet] = 0.6;
        // Simular acceso
        final _ = values[DeviceType.mobile];
      }
      
      stopwatch.stop();
      print('Map Creation/Access - 10,000 operations: ${stopwatch.elapsedMilliseconds}ms');
      
      // Creación de Maps pequeños debería ser rápida
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });
  });
}