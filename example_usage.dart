import 'package:flutter/material.dart';
import 'package:leulit_flutter_fullresponsive/leulit_flutter_fullreponsive.dart';


/// Ejemplo completo mostrando todas las nuevas funcionalidades:
/// - ResponsiveSize para iconos, padding, margins
/// - ResponsiveRadius para esquinas redondeadas
/// - ResponsiveFlex para layouts adaptativos
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSizeInitializer(
      child: MaterialApp(
        title: 'Leulit Responsive v1.4.0 Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ResponsiveDemo(),
      ),
    );
  }
}

class ResponsiveDemo extends StatelessWidget {
  const ResponsiveDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Responsive Demo',
          style: TextStyle(fontSize: 4.sp(context)),
        ),
        leading: Icon(
          Icons.menu,
          size: 24.sizeFor(context, mobile: 20, tablet: 28, desktop: 32),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección: Iconos Responsive
            _buildSectionTitle(context, '📏 Iconos Responsive'),
            _buildIconSection(context),
            
            SizedBox(height: 24.size(context)),
            
            // Sección: Border Radius Responsive
            _buildSectionTitle(context, '🔄 Border Radius Responsive'),
            _buildRadiusSection(context),
            
            SizedBox(height: 24.size(context)),
            
            // Sección: Flex Layouts Responsive
            _buildSectionTitle(context, '📐 Flex Layouts Responsive'),
            _buildFlexSection(context),
            
            SizedBox(height: 24.size(context)),
            
            // Sección: Ejemplo Práctico Completo
            _buildSectionTitle(context, '🎯 Ejemplo Práctico'),
            _buildPracticalExample(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.size(context)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 4.sp(context),
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildIconSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.star,
                      size: 32.size(context),
                      color: Colors.amber,
                    ),
                    Text('32.size()', style: TextStyle(fontSize: 2.sp(context))),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 28.sizeFor(context, mobile: 24, tablet: 32, desktop: 36),
                      color: Colors.red,
                    ),
                    Text('Multi-platform', style: TextStyle(fontSize: 2.sp(context))),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      size: 24.size(context),
                      color: Colors.green,
                    ),
                    Text('24.size()', style: TextStyle(fontSize: 2.sp(context))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadiusSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 80.size(context),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8.radius(context)),
            ),
            child: Center(
              child: Text(
                '8.radius()',
                style: TextStyle(fontSize: 2.5.sp(context)),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.size(context)),
        Expanded(
          child: Container(
            height: 80.size(context),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(
                16.radiusFor(context, mobile: 12, tablet: 20, desktop: 24),
              ),
            ),
            child: Center(
              child: Text(
                'Multi-platform\nRadius',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 2.5.sp(context)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlexSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          children: [
            // Flex automático
            Text(
              'Flex Automático (.flexValue())',
              style: TextStyle(
                fontSize: 3.sp(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.size(context)),
            Row(
              children: [
                Expanded(
                  flex: 3.flexValue(context),
                  child: Container(
                    height: 50.size(context),
                    color: Colors.blue[300],
                    child: Center(
                      child: Text(
                        'Flex 3',
                        style: TextStyle(
                          fontSize: 2.5.sp(context),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.size(context)),
                Expanded(
                  flex: 2.flexValue(context),
                  child: Container(
                    height: 50.size(context),
                    color: Colors.red[300],
                    child: Center(
                      child: Text(
                        'Flex 2',
                        style: TextStyle(
                          fontSize: 2.5.sp(context),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.size(context)),
            
            // Flex multi-plataforma
            Text(
              'Flex Multi-Plataforma (.flexFor())',
              style: TextStyle(
                fontSize: 3.sp(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.size(context)),
            Row(
              children: [
                Expanded(
                  flex: 4.flexFor(context, mobile: 3, tablet: 5, desktop: 6),
                  child: Container(
                    height: 50.size(context),
                    color: Colors.purple[300],
                    child: Center(
                      child: Text(
                        'Adaptativo',
                        style: TextStyle(
                          fontSize: 2.5.sp(context),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.size(context)),
                Expanded(
                  flex: 2.flexFor(context, mobile: 2, tablet: 2, desktop: 1),
                  child: Container(
                    height: 50.size(context),
                    color: Colors.orange[300],
                    child: Center(
                      child: Text(
                        'Secundario',
                        style: TextStyle(
                          fontSize: 2.5.sp(context),
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildPracticalExample(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.radius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.size(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  size: 28.sizeFor(context, mobile: 24, tablet: 32, desktop: 36),
                  color: Colors.blue[600],
                ),
                SizedBox(width: 12.size(context)),
                Expanded(
                  flex: 4.flexValue(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notificación Importante',
                        style: TextStyle(
                          fontSize: 3.5.sp(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tienes mensajes pendientes',
                        style: TextStyle(
                          fontSize: 2.8.sp(context),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.size(context)),
            
            // Contenido
            Container(
              padding: EdgeInsets.all(12.size(context)),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8.radius(context)),
              ),
              child: Text(
                'Este es un ejemplo práctico que combina todas las nuevas funcionalidades: iconos responsive, padding adaptativo, esquinas redondeadas y layouts flexibles.',
                style: TextStyle(fontSize: 2.5.sp(context)),
              ),
            ),
            
            SizedBox(height: 16.size(context)),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  flex: 2.flexFor(context, mobile: 1, tablet: 2, desktop: 2),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.radius(context)),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.size(context),
                        horizontal: 16.size(context),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.check,
                      size: 18.size(context),
                    ),
                    label: Text(
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