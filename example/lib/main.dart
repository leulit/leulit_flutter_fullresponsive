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
            fontSize: 4.sp,
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
        selectedLabelStyle: TextStyle(fontSize: 2.2.sp),
        unselectedLabelStyle: TextStyle(fontSize: 2.sp),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets, size: 24.size),
            label: 'Basic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices, size: 24.size),
            label: 'Multi-Platform',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune, size: 24.size),
            label: 'Extensions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, size: 24.size),
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
      padding: EdgeInsets.all(16.size),
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
                  width: 30.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(8.radius),
                  ),
                  child: Center(
                    child: Text(
                      '30% W\n20% H',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 2.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  width: 50.w,
                  height: 15.h,
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(12.radius),
                  ),
                  child: Center(
                    child: Text(
                      '50% Width, 15% Height',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 2.8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.size),
          
          _buildExampleCard(
            context,
            title: 'Decimal Format (0-1) - Higher Precision',
            child: Column(
              children: [
                Container(
                  width: 0.618.w, // Golden ratio
                  height: 0.1.h,
                  decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.circular(6.radius),
                  ),
                  child: Center(
                    child: Text(
                      'Golden Ratio Width (0.618)',
                      style: TextStyle(
                        fontSize: 2.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.size),
                Container(
                  width: 0.75.w,
                  height: 0.08.h,
                  decoration: BoxDecoration(
                    color: Colors.purple[200],
                    borderRadius: BorderRadius.circular(10.radius),
                  ),
                  child: Center(
                    child: Text(
                      '75% Width (0.75 format)',
                      style: TextStyle(
                        fontSize: 2.3.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.size),
          
          _buildExampleCard(
            context,
            title: 'Font Scaling with .sp()',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Large Header',
                  style: TextStyle(
                    fontSize: 6.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 8.size),
                Text(
                  'Medium Subtitle',
                  style: TextStyle(
                    fontSize: 4.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[600],
                  ),
                ),
                SizedBox(height: 8.size),
                Text(
                  'Regular body text that adapts to screen size and user accessibility settings. This text uses 3.sp() for optimal readability.',
                  style: TextStyle(
                    fontSize: 3.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8.size),
                Text(
                  'Small caption text',
                  style: TextStyle(
                    fontSize: 2.5.sp,
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
      padding: EdgeInsets.only(bottom: 16.size),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 5.sp,
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
        borderRadius: BorderRadius.circular(12.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 3.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 12.size),
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
      padding: EdgeInsets.all(16.size),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Multi-Platform Functions'),
          
          _buildExampleCard(
            context,
            title: 'Platform-Specific Widths',
            description: 'Different widths based on device type',
            child: Container(
              width: 70.wWithContext(context,                 web: 40,      // 40% on web
                mobile: 90,   // 90% on mobile
                tablet: 60,   // 60% on tablet
                desktop: 50,  // 50% on desktop
              ),
              height: 0.12.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[300]!, Colors.blue[600]!],
                ),
                borderRadius: BorderRadius.circular(8.radius),
              ),
              child: Center(
                child: Text(
                  'Adaptive Width Container',
                  style: TextStyle(
                    fontSize: 3.spWithContext(context,                       web: 2,
                      mobile: 3.5,
                      tablet: 2.5,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 20.size),
          
          _buildExampleCard(
            context,
            title: 'Platform-Specific Heights',
            description: 'Optimized heights for different devices',
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 20.hWithContext(context,                       web: 15,
                      mobile: 25,
                      tablet: 18,
                      desktop: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(
                        8.radiusWithContext(context,                           mobile: 6,
                          tablet: 10,
                          desktop: 12,
                        )
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Adaptive\nHeight',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 3.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.size),
                Expanded(
                  child: Container(
                    height: 18.hWithContext(context,                       web: 10,
                      mobile: 20,
                      tablet: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[300], 
                      borderRadius: BorderRadius.circular(8.radius),
                    ),
                    child: Center(
                      child: Text(
                        'Different\nHeight',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 2.8.sp,
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
          
          SizedBox(height: 20.size),
          
          _buildDeviceInfo(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.size),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 5.sp,
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
        borderRadius: BorderRadius.circular(12.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 3.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 4.size),
            Text(
              description,
              style: TextStyle(
                fontSize: 2.5.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.size),
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
        borderRadius: BorderRadius.circular(12.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Device Information',
              style: TextStyle(
                fontSize: 3.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 12.size),
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
      padding: EdgeInsets.symmetric(vertical: 4.size),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 2.8.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 2.8.sp,
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
      padding: EdgeInsets.all(16.size),
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
                    _buildIconExample(context, Icons.star, 20.size, '20.size()'),
                    _buildIconExample(context, Icons.favorite, 24.size, '24.size()'),
                    _buildIconExample(context, Icons.thumb_up, 28.size, '28.size()'),
                  ],
                ),
                SizedBox(height: 16.size),
                Container(
                  padding: EdgeInsets.all(16.size),
                  margin: EdgeInsets.symmetric(horizontal: 20.size),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8.radius),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    'This container uses responsive padding (16.size()) and margin (20.size())',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 2.8.sp),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.size),
          
          // ResponsiveRadius Examples
          _buildExampleCard(
            context,
            title: 'ResponsiveRadius (.radius())',
            description: 'For border radius',
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80.size,
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(8.radius),
                    ),
                    child: Center(
                      child: Text(
                        '8.radius()',
                        style: TextStyle(fontSize: 2.5.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.size),
                Expanded(
                  child: Container(
                    height: 80.size,
                    decoration: BoxDecoration(
                      color: Colors.purple[200],
                      borderRadius: BorderRadius.circular(16.radius),
                    ),
                    child: Center(
                      child: Text(
                        '16.radius()',
                        style: TextStyle(fontSize: 2.5.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.size),
                Expanded(
                  child: Container(
                    height: 80.size,
                    decoration: BoxDecoration(
                      color: Colors.orange[200],
                      borderRadius: BorderRadius.circular(
                        16.radiusWithContext(context,                           mobile: 12,
                          tablet: 20,
                          desktop: 24,
                        )
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Multi-platform\nRadius',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 2.2.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.size),
          
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
                    fontSize: 3.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.size),
                Row(
                  children: [
                    Expanded(
                      flex: 3.flexValue,
                      child: Container(
                        height: 50.size,
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(6.radius),
                        ),
                        child: Center(
                          child: Text(
                            'Flex 3',
                            style: TextStyle(
                              fontSize: 2.5.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.size),
                    Expanded(
                      flex: 2.flexValue,
                      child: Container(
                        height: 50.size,
                        decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.circular(6.radius),
                        ),
                        child: Center(
                          child: Text(
                            'Flex 2',
                            style: TextStyle(
                              fontSize: 2.5.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.size),
                // Multi-platform flex
                Text(
                  'Multi-Platform Flex',
                  style: TextStyle(
                    fontSize: 3.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.size),
                Row(
                  children: [
                    Expanded(
                      flex: 4.flexValueWithContext(context,                         mobile: 3,
                        tablet: 5,
                        desktop: 6,
                      ),
                      child: Container(
                        height: 50.size,
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.circular(6.radius),
                        ),
                        child: Center(
                          child: Text(
                            'Adaptive',
                            style: TextStyle(
                              fontSize: 2.5.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.size),
                    Expanded(
                      flex: 2.flexValueWithContext(context,                         mobile: 2,
                        tablet: 2,
                        desktop: 1,
                      ),
                      child: Container(
                        height: 50.size,
                        decoration: BoxDecoration(
                          color: Colors.purple[300],
                          borderRadius: BorderRadius.circular(6.radius),
                        ),
                        child: Center(
                          child: Text(
                            'Secondary',
                            style: TextStyle(
                              fontSize: 2.3.sp,
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
      padding: EdgeInsets.only(bottom: 16.size),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 5.sp,
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
        borderRadius: BorderRadius.circular(12.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 3.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 4.size),
            Text(
              description,
              style: TextStyle(
                fontSize: 2.5.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.size),
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
        SizedBox(height: 4.size),
        Text(
          label,
          style: TextStyle(
            fontSize: 2.sp,
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
      padding: EdgeInsets.all(16.size),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Practical Example'),
          
          // Header Section
          _buildHeaderSection(context),
          
          SizedBox(height: 20.size),
          
          // Stats Cards
          _buildStatsSection(context),
          
          SizedBox(height: 20.size),
          
          // Action Buttons
          _buildActionSection(context),
          
          SizedBox(height: 20.size),
          
          // List Example
          _buildListSection(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.size),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 5.sp,
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
        borderRadius: BorderRadius.circular(16.radius),
      ),
      child: Container(
        width: 100.w,
        padding: EdgeInsets.all(20.size),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[400]!, Colors.blue[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.radius),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4.flexValueWithContext(context,                 mobile: 3,
                tablet: 4,
                desktop: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 4.spWithContext(context,                         mobile: 4.5,
                        tablet: 3.5,
                        desktop: 3,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.size),
                  Text(
                    'This is a practical example showing how all responsive extensions work together in a real app scenario.',
                    style: TextStyle(
                      fontSize: 2.8.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.size),
            Expanded(
              flex: 1.flexValue,
              child: Icon(
                Icons.dashboard,
                size: 45.sizeWithContext(context,                   mobile: 40,
                  tablet: 50,
                  desktop: 60,
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
          flex: 1.flexValue,
          child: _buildStatCard(context, '1.2K', 'Users', Icons.people, Colors.green),
        ),
        SizedBox(width: 12.size),
        Expanded(
          flex: 1.flexValue,
          child: _buildStatCard(context, '85%', 'Success', Icons.trending_up, Colors.orange),
        ),
        SizedBox(width: 12.size),
        Expanded(
          flex: 1.flexValue,
          child: _buildStatCard(context, '42', 'Projects', Icons.folder, Colors.purple),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24.sizeWithContext(context,                 mobile: 20,
                tablet: 28,
                desktop: 32,
              ),
              color: color,
            ),
            SizedBox(height: 8.size),
            Text(
              value,
              style: TextStyle(
                fontSize: 4.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4.size),
            Text(
              label,
              style: TextStyle(
                fontSize: 2.5.sp,
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
          flex: 2.flexValueWithContext(context,             mobile: 1,
            tablet: 2,
            desktop: 2,
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.radius),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 12.size,
                horizontal: 16.size,
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Primary action executed!',
                    style: TextStyle(fontSize: 2.8.sp),
                  ),
                ),
              );
            },
            icon: Icon(Icons.play_arrow, size: 18.size),
            label: Text(
              'Primary Action',
              style: TextStyle(fontSize: 2.8.sp),
            ),
          ),
        ),
        SizedBox(width: 12.size),
        Expanded(
          flex: 1.flexValue,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.radius),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 12.size,
                horizontal: 16.size,
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Secondary action executed!',
                    style: TextStyle(fontSize: 2.8.sp),
                  ),
                ),
              );
            },
            child: Text(
              'Secondary',
              style: TextStyle(fontSize: 2.8.sp),
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
        borderRadius: BorderRadius.circular(12.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.size),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 3.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 12.size),
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
      padding: EdgeInsets.symmetric(vertical: 8.size),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.size),
            decoration: BoxDecoration(
              color: (item['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.radius),
            ),
            child: Icon(
              item['icon'] as IconData,
              size: 20.size,
              color: item['color'] as Color,
            ),
          ),
          SizedBox(width: 12.size),
          Expanded(
            flex: 3.flexValue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: TextStyle(
                    fontSize: 2.8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.size),
                Text(
                  item['time'] as String,
                  style: TextStyle(
                    fontSize: 2.3.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 16.size,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}