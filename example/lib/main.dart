import 'package:flutter/material.dart';
import 'demo_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Plus Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const AnimationDemoPage(),
    );
  }
}

class AnimationDemoPage extends StatefulWidget {
  const AnimationDemoPage({super.key});

  @override
  State<AnimationDemoPage> createState() => _AnimationDemoPageState();
}

class _AnimationDemoPageState extends State<AnimationDemoPage> {
  int _selectedIndex = 0;

  final List<DemoPage> _pages = [
    const DemoPage(
      title: 'Fade Animations',
      icon: Icons.visibility,
      color: Color(0xFF8B5CF6),
      child: FadeAnimationDemo(),
    ),
    const DemoPage(
      title: 'Slide Animations',
      icon: Icons.swipe,
      color: Color(0xFF06B6D4),
      child: SlideAnimationDemo(),
    ),
    const DemoPage(
      title: 'Scale Animations',
      icon: Icons.zoom_in,
      color: Color(0xFF10B981),
      child: ScaleAnimationDemo(),
    ),
    const DemoPage(
      title: 'Rotation Animations',
      icon: Icons.rotate_right,
      color: Color(0xFFF59E0B),
      child: RotationAnimationDemo(),
    ),
    const DemoPage(
      title: 'Bounce Animations',
      icon: Icons.sports_basketball,
      color: Color(0xFFEF4444),
      child: BounceAnimationDemo(),
    ),
    const DemoPage(
      title: 'Shimmer Animations',
      icon: Icons.auto_awesome,
      color: Color(0xFF8B5CF6),
      child: ShimmerAnimationDemo(),
    ),
    const DemoPage(
      title: 'Staggered Animations',
      icon: Icons.view_list,
      color: Color(0xFF6366F1),
      child: StaggeredAnimationDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: _pages[_selectedIndex].color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _pages[_selectedIndex].title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _pages[_selectedIndex].color,
                      _pages[_selectedIndex].color.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _pages[_selectedIndex].icon,
                    size: 48,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _pages[_selectedIndex].child,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: _pages[_selectedIndex].color,
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: _pages
              .map((page) => BottomNavigationBarItem(
                    icon: Icon(page.icon),
                    label: page.title.split(' ').first,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class DemoPage {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const DemoPage({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });
}
