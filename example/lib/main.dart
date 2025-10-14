import 'package:flutter/material.dart';
import 'package:leulit_flutter_fullresponsive/leulit_flutter_fullreponsive.dart';

void main() {
  runApp(const ResponsiveExampleApp());
}

class ResponsiveExampleApp extends StatelessWidget {
  const ResponsiveExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSizeInitializer(
      child: MaterialApp(
        title: 'Leulit Flutter Full Responsive Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const ResponsiveHomePage(),
      ),
    );
  }
}

class ResponsiveHomePage extends StatefulWidget {
  const ResponsiveHomePage({super.key});

  @override
  State<ResponsiveHomePage> createState() => _ResponsiveHomePageState();
}

class _ResponsiveHomePageState extends State<ResponsiveHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BasicExamplePage(),
    const MultiPlatformExamplePage(),
    const SpecializedExtensionsPage(),
    const PracticalExamplePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Responsive Examples',
          style: TextStyle(
            fontSize: 4.sp(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedLabelStyle: TextStyle(fontSize: 2.2.sp(context)),
        unselectedLabelStyle: TextStyle(fontSize: 2.sp(context)),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets, size: 24.size(context)),
            label: 'Basic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices, size: 24.size(context)),
            label: 'Multi-Platform',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune, size: 24.size(context)),
            label: 'Extensions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, size: 24.size(context)),
            label: 'Practical',
          ),
        ],
      ),
    );
  }
}

/// Página que demuestra el uso básico de las extensiones .w(), .h(), .sp()
class BasicExamplePage extends StatelessWidget {
  const BasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.size(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Basic Extensions (.w, .h, .sp)'),
          
          // Ejemplo de contenedores con diferentes tamaños
          _buildExampleCard(
            context,
            title: 'Percentage Format (0-100)',
            child: Row(
              children: [
                Container(
                  width: 30.w(context),
                  height: 20.h(context),
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(8.radius(context)),
                  ),
                  child: Center(
                    child: Text(
                      '30% W\n20% H',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 2.5.sp(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w(context)),
                Container(
                  width: 50.w(context),
                  height: 15.h(context),
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(12.radius(context)),
                  ),
                  child: Center(
                    child: Text(
                      '50% Width, 15% Height',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 2.8.sp(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.size(context)),
          
          _buildExampleCard(
            context,
            title: 'Decimal Format (0-1) - Higher Precision',
            child: Column(
              children: [
                Container(
                  width: 0.618.w(context), // Golden ratio
                  height: 0.1.h(context),
                  decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.circular(6.radius(context)),
                  ),
                  child: Center(
                    child: Text(
                      'Golden Ratio Width (0.618)',
                      style: TextStyle(
                        fontSize: 2.5.sp(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.size(context)),
                Container(
                  width: 0.75.w(context),
                  height: 0.08.h(context),
                  decoration: BoxDecoration(
                    color: Colors.purple[200],
                    borderRadius: BorderRadius.circular(10.radius(context)),
                  ),
                  child: Center(
                    child: Text(
                      '75% Width (0.75 format)',
                      style: TextStyle(
                        fontSize: 2.3.sp(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.size(context)),
          
          _buildExampleCard(
            context,
            title: 'Font Scaling with .sp()',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Large Header',
                  style: TextStyle(
                    fontSize: 6.sp(context),
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 8.size(context)),
                Text(
                  'Medium Subtitle',
                  style: TextStyle(
                    fontSize: 4.sp(context),
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[600],
                  ),
                ),
                SizedBox(height: 8.size(context)),
                Text(
                  'Regular body text that adapts to screen size and user accessibility settings. This text uses 3.sp() for optimal readability.',
                  style: TextStyle(
                    fontSize: 3.sp(context),
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8.size(context)),
                Text(
                  'Small caption text',
                  style: TextStyle(
                    fontSize: 2.5.sp(context),
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.size(context)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 5.sp(context),
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, {required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 3.5.sp(context),
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 12.size(context)),
            child,
          ],
        ),
      ),
    );
  }
}

/// Página que demuestra las funciones multi-plataforma
class MultiPlatformExamplePage extends StatelessWidget {
  const MultiPlatformExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.size(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Multi-Platform Functions'),
          
          _buildExampleCard(
            context,
            title: 'Platform-Specific Widths',
            description: 'Different widths based on device type',
            child: Container(
              width: w(context, 
                web: 0.4,      // 40% on web
                mobile: 0.9,   // 90% on mobile
                tablet: 0.6,   // 60% on tablet
                desktop: 0.5,  // 50% on desktop
                fallback: 0.7, // 70% fallback
              ),
              height: 0.12.h(context),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[300]!, Colors.blue[600]!],
                ),
                borderRadius: BorderRadius.circular(8.radius(context)),
              ),
              child: Center(
                child: Text(
                  'Adaptive Width Container',
                  style: TextStyle(
                    fontSize: sp(context,
                      web: 0.02,
                      mobile: 0.035,
                      tablet: 0.025,
                      fallback: 0.03,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 20.size(context)),
          
          _buildExampleCard(
            context,
            title: 'Platform-Specific Heights',
            description: 'Optimized heights for different devices',
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: h(context,
                      web: 0.15,
                      mobile: 0.25,
                      tablet: 0.18,
                      desktop: 0.12,
                      fallback: 0.2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(
                        8.radiusFor(context,
                          mobile: 6,
                          tablet: 10,
                          desktop: 12,
                          fallback: 8,
                        )
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Adaptive\nHeight',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 3.sp(context),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.size(context)),
                Expanded(
                  child: Container(
                    height: h(context,
                      web: 0.1,
                      mobile: 0.2,
                      tablet: 0.15,
                      fallback: 0.18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[300], 
                      borderRadius: BorderRadius.circular(8.radius(context)),
                    ),
                    child: Center(
                      child: Text(
                        'Different\nHeight',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 2.8.sp(context),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.size(context)),
          
          _buildDeviceInfo(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.size(context)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 5.sp(context),
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 3.5.sp(context),
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 4.size(context)),
            Text(
              description,
              style: TextStyle(
                fontSize: 2.5.sp(context),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.size(context)),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfo(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Device Information',
              style: TextStyle(
                fontSize: 3.5.sp(context),
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 12.size(context)),
            _buildInfoRow(context, 'Screen Width:', '${MediaQuery.of(context).size.width.toStringAsFixed(1)}px'),
            _buildInfoRow(context, 'Screen Height:', '${MediaQuery.of(context).size.height.toStringAsFixed(1)}px'),
            _buildInfoRow(context, 'Text Scale:', '${MediaQuery.of(context).textScaler.scale(1).toStringAsFixed(2)}x'),
            _buildInfoRow(context, 'Platform:', Theme.of(context).platform.name),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.size(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 2.8.sp(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 2.8.sp(context),
              color: Colors.blue[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Página que demuestra las extensiones especializadas
class SpecializedExtensionsPage extends StatelessWidget {
  const SpecializedExtensionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.size(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Specialized Extensions'),
          
          // ResponsiveSize Examples
          _buildExampleCard(
            context,
            title: 'ResponsiveSize (.size())',
            description: 'For icons, padding, margins',
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIconExample(context, Icons.star, 20.size(context), '20.size()'),
                    _buildIconExample(context, Icons.favorite, 24.size(context), '24.size()'),
                    _buildIconExample(context, Icons.thumb_up, 28.size(context), '28.size()'),
                  ],
                ),
                SizedBox(height: 16.size(context)),
                Container(
                  padding: EdgeInsets.all(16.size(context)),
                  margin: EdgeInsets.symmetric(horizontal: 20.size(context)),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8.radius(context)),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    'This container uses responsive padding (16.size()) and margin (20.size())',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 2.8.sp(context)),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.size(context)),
          
          // ResponsiveRadius Examples
          _buildExampleCard(
            context,
            title: 'ResponsiveRadius (.radius())',
            description: 'For border radius',
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80.size(context),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
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
                      color: Colors.purple[200],
                      borderRadius: BorderRadius.circular(16.radius(context)),
                    ),
                    child: Center(
                      child: Text(
                        '16.radius()',
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
                      color: Colors.orange[200],
                      borderRadius: BorderRadius.circular(
                        16.radiusFor(context,
                          mobile: 12,
                          tablet: 20,
                          desktop: 24,
                          fallback: 16,
                        )
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Multi-platform\nRadius',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 2.2.sp(context)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.size(context)),
          
          // ResponsiveFlex Examples
          _buildExampleCard(
            context,
            title: 'ResponsiveFlex (.flexValue())',
            description: 'For adaptive layouts',
            child: Column(
              children: [
                // Basic flex
                Text(
                  'Automatic Flex Adjustment',
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
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(6.radius(context)),
                        ),
                        child: Center(
                          child: Text(
                            'Flex 3',
                            style: TextStyle(
                              fontSize: 2.5.sp(context),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
                        decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.circular(6.radius(context)),
                        ),
                        child: Center(
                          child: Text(
                            'Flex 2',
                            style: TextStyle(
                              fontSize: 2.5.sp(context),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.size(context)),
                // Multi-platform flex
                Text(
                  'Multi-Platform Flex',
                  style: TextStyle(
                    fontSize: 3.sp(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.size(context)),
                Row(
                  children: [
                    Expanded(
                      flex: 4.flexFor(context,
                        mobile: 3,
                        tablet: 5,
                        desktop: 6,
                        fallback: 4,
                      ),
                      child: Container(
                        height: 50.size(context),
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.circular(6.radius(context)),
                        ),
                        child: Center(
                          child: Text(
                            'Adaptive',
                            style: TextStyle(
                              fontSize: 2.5.sp(context),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.size(context)),
                    Expanded(
                      flex: 2.flexFor(context,
                        mobile: 2,
                        tablet: 2,
                        desktop: 1,
                        fallback: 2,
                      ),
                      child: Container(
                        height: 50.size(context),
                        decoration: BoxDecoration(
                          color: Colors.purple[300],
                          borderRadius: BorderRadius.circular(6.radius(context)),
                        ),
                        child: Center(
                          child: Text(
                            'Secondary',
                            style: TextStyle(
                              fontSize: 2.3.sp(context),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.size(context)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 5.sp(context),
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 3.5.sp(context),
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 4.size(context)),
            Text(
              description,
              style: TextStyle(
                fontSize: 2.5.sp(context),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.size(context)),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildIconExample(BuildContext context, IconData icon, double size, String label) {
    return Column(
      children: [
        Icon(
          icon,
          size: size,
          color: Colors.blue[600],
        ),
        SizedBox(height: 4.size(context)),
        Text(
          label,
          style: TextStyle(
            fontSize: 2.sp(context),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// Página con ejemplo práctico completo
class PracticalExamplePage extends StatelessWidget {
  const PracticalExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.size(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Practical Example'),
          
          // Header Section
          _buildHeaderSection(context),
          
          SizedBox(height: 20.size(context)),
          
          // Stats Cards
          _buildStatsSection(context),
          
          SizedBox(height: 20.size(context)),
          
          // Action Buttons
          _buildActionSection(context),
          
          SizedBox(height: 20.size(context)),
          
          // List Example
          _buildListSection(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.size(context)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 5.sp(context),
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.radius(context)),
      ),
      child: Container(
        width: 100.w(context),
        padding: EdgeInsets.all(20.size(context)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[400]!, Colors.blue[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.radius(context)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4.flexFor(context,
                mobile: 3,
                tablet: 4,
                desktop: 5,
                fallback: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: sp(context,
                        mobile: 0.045,
                        tablet: 0.035,
                        desktop: 0.03,
                        fallback: 0.04,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.size(context)),
                  Text(
                    'This is a practical example showing how all responsive extensions work together in a real app scenario.',
                    style: TextStyle(
                      fontSize: 2.8.sp(context),
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.size(context)),
            Expanded(
              flex: 1.flexValue(context),
              child: Icon(
                Icons.dashboard,
                size: 45.sizeFor(context,
                  mobile: 40,
                  tablet: 50,
                  desktop: 60,
                  fallback: 45,
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1.flexValue(context),
          child: _buildStatCard(context, '1.2K', 'Users', Icons.people, Colors.green),
        ),
        SizedBox(width: 12.size(context)),
        Expanded(
          flex: 1.flexValue(context),
          child: _buildStatCard(context, '85%', 'Success', Icons.trending_up, Colors.orange),
        ),
        SizedBox(width: 12.size(context)),
        Expanded(
          flex: 1.flexValue(context),
          child: _buildStatCard(context, '42', 'Projects', Icons.folder, Colors.purple),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24.sizeFor(context,
                mobile: 20,
                tablet: 28,
                desktop: 32,
                fallback: 24,
              ),
              color: color,
            ),
            SizedBox(height: 8.size(context)),
            Text(
              value,
              style: TextStyle(
                fontSize: 4.sp(context),
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4.size(context)),
            Text(
              label,
              style: TextStyle(
                fontSize: 2.5.sp(context),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2.flexFor(context,
            mobile: 1,
            tablet: 2,
            desktop: 2,
            fallback: 2,
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.radius(context)),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 12.size(context),
                horizontal: 16.size(context),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Primary action executed!',
                    style: TextStyle(fontSize: 2.8.sp(context)),
                  ),
                ),
              );
            },
            icon: Icon(Icons.play_arrow, size: 18.size(context)),
            label: Text(
              'Primary Action',
              style: TextStyle(fontSize: 2.8.sp(context)),
            ),
          ),
        ),
        SizedBox(width: 12.size(context)),
        Expanded(
          flex: 1.flexValue(context),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.radius(context)),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 12.size(context),
                horizontal: 16.size(context),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Secondary action executed!',
                    style: TextStyle(fontSize: 2.8.sp(context)),
                  ),
                ),
              );
            },
            child: Text(
              'Secondary',
              style: TextStyle(fontSize: 2.8.sp(context)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 3.5.sp(context),
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 12.size(context)),
            ...List.generate(4, (index) => _buildListItem(context, index)),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.check_circle, 'title': 'Task Completed', 'time': '2 min ago', 'color': Colors.green},
      {'icon': Icons.upload, 'title': 'File Uploaded', 'time': '5 min ago', 'color': Colors.blue},
      {'icon': Icons.person_add, 'title': 'New User Joined', 'time': '10 min ago', 'color': Colors.orange},
      {'icon': Icons.notification_important, 'title': 'System Update', 'time': '1 hour ago', 'color': Colors.red},
    ];

    final item = items[index];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.size(context)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.size(context)),
            decoration: BoxDecoration(
              color: (item['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.radius(context)),
            ),
            child: Icon(
              item['icon'] as IconData,
              size: 20.size(context),
              color: item['color'] as Color,
            ),
          ),
          SizedBox(width: 12.size(context)),
          Expanded(
            flex: 3.flexValue(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: TextStyle(
                    fontSize: 2.8.sp(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.size(context)),
                Text(
                  item['time'] as String,
                  style: TextStyle(
                    fontSize: 2.3.sp(context),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 16.size(context),
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}