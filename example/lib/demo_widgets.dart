import 'package:flutter/material.dart';
import 'package:animations_plus/animations_plus.dart';

// Simple demo classes for the main app
class FadeAnimationDemo extends StatefulWidget {
  const FadeAnimationDemo({super.key});

  @override
  State<FadeAnimationDemo> createState() => _FadeAnimationDemoState();
}

class _FadeAnimationDemoState extends State<FadeAnimationDemo> {
  int _restartKey = 0;

  void _restartAnimations() {
    setState(() {
      _restartKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildRestartButton(_restartAnimations, const Color(0xFF8B5CF6)),

          const SizedBox(height: 24),

          buildAnimationCard(
            key: ValueKey('quick_fade_$_restartKey'),
            title: 'Quick Fade In',
            subtitle: '200ms duration with ease-out curve',
            icon: Icons.flash_on,
            color: Colors.orange,
            child: FadeAnimationPresets.quickFadeIn(
              buildDemoContent('⚡ Quick Fade', Colors.orange),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('slow_fade_$_restartKey'),
            title: 'Slow Fade In',
            subtitle: '800ms duration with ease-in-out curve',
            icon: Icons.hourglass_empty,
            color: Colors.blue,
            child: FadeAnimationPresets.slowFadeIn(
              buildDemoContent('🐌 Slow Fade', Colors.blue),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('delayed_fade_$_restartKey'),
            title: 'Delayed Fade In',
            subtitle: '500ms delay before animation starts',
            icon: Icons.schedule,
            color: Colors.green,
            child: FadeAnimationPresets.delayedFadeIn(
              buildDemoContent('⏰ Delayed Fade', Colors.green),
              const Duration(milliseconds: 500),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('custom_fade_$_restartKey'),
            title: 'Custom Fade Animation',
            subtitle: '800ms duration with 1s delay',
            icon: Icons.tune,
            color: Colors.purple,
            child: SimpleFadeAnimation(
              key: ValueKey('custom_$_restartKey'),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              delay: const Duration(milliseconds: 1000),
              child: buildDemoContent('🎨 Custom Fade', Colors.purple),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class SlideAnimationDemo extends StatefulWidget {
  const SlideAnimationDemo({super.key});

  @override
  State<SlideAnimationDemo> createState() => _SlideAnimationDemoState();
}

class _SlideAnimationDemoState extends State<SlideAnimationDemo> {
  int _restartKey = 0;

  void _restartAnimations() {
    setState(() {
      _restartKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildRestartButton(_restartAnimations, const Color(0xFF06B6D4)),

          const SizedBox(height: 24),

          buildAnimationCard(
            key: ValueKey('slide_left_$_restartKey'),
            title: 'Slide from Left',
            subtitle: 'Slides in from the left side',
            icon: Icons.arrow_forward,
            color: Colors.blue,
            child: SlideAnimationPresets.slideInLeft(
              buildDemoContent('← Left Slide', Colors.blue),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('slide_right_$_restartKey'),
            title: 'Slide from Right',
            subtitle: 'Slides in from the right side',
            icon: Icons.arrow_back,
            color: Colors.cyan,
            child: SlideAnimationPresets.slideInRight(
              buildDemoContent('Right Slide →', Colors.cyan),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('slide_up_$_restartKey'),
            title: 'Slide from Top',
            subtitle: 'Slides in from the top',
            icon: Icons.arrow_downward,
            color: Colors.teal,
            child: SlideAnimationPresets.slideInUp(
              buildDemoContent('↑ Top Slide', Colors.teal),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('slide_bounce_$_restartKey'),
            title: 'Slide with Bounce',
            subtitle: 'Slides in from bottom with elastic effect',
            icon: Icons.sports_basketball,
            color: Colors.indigo,
            child: SlideAnimationPresets.slideInWithBounce(
              buildDemoContent('🏀 Bouncy Slide', Colors.indigo),
              SlideDirection.down,
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Shared widget for building animation cards
Widget buildAnimationCard({
  required Key key,
  required String title,
  required String subtitle,
  required IconData icon,
  required Color color,
  required Widget child,
}) {
  return Card(
    key: key,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(child: child),
        ],
      ),
    ),
  );
}

// Shared widget for building demo content
Widget buildDemoContent(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color.withValues(alpha: 0.8),
      ),
    ),
  );
}

// Shared restart button
Widget buildRestartButton(VoidCallback onPressed, Color color) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: const Icon(Icons.refresh),
    label: const Text('Restart Animations'),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
    ),
  );
}

class ScaleAnimationDemo extends StatefulWidget {
  const ScaleAnimationDemo({super.key});

  @override
  State<ScaleAnimationDemo> createState() => _ScaleAnimationDemoState();
}

class _ScaleAnimationDemoState extends State<ScaleAnimationDemo> {
  int _restartKey = 0;

  void _restartAnimations() {
    setState(() {
      _restartKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildRestartButton(_restartAnimations, const Color(0xFF10B981)),

          const SizedBox(height: 24),

          buildAnimationCard(
            key: ValueKey('scale_in_$_restartKey'),
            title: 'Scale In',
            subtitle: 'Scales from 0 to 1 with ease-out curve',
            icon: Icons.zoom_in,
            color: Colors.green,
            child: ScaleAnimationPresets.scaleIn(
              buildDemoContent('📈 Scale In', Colors.green),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('pop_in_$_restartKey'),
            title: 'Pop In',
            subtitle: 'Elastic scale animation with overshoot',
            icon: Icons.bubble_chart,
            color: Colors.lightGreen,
            child: ScaleAnimationPresets.popIn(
              buildDemoContent('🎈 Pop In', Colors.lightGreen),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('zoom_bounce_$_restartKey'),
            title: 'Zoom with Bounce',
            subtitle: 'Zoom in with bouncy effect',
            icon: Icons.zoom_out_map,
            color: Colors.teal,
            child: ScaleAnimationPresets.zoomInBounce(
              buildDemoContent('🔍 Zoom Bounce', Colors.teal),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('tap_scale_$_restartKey'),
            title: 'Interactive Tap to Scale',
            subtitle: 'Tap to see scale animation',
            icon: Icons.touch_app,
            color: Colors.green,
            child: TapToScale(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tapped! 🎯'),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
              },
              child: buildDemoContent('👆 Tap Me!', Colors.green),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class RotationAnimationDemo extends StatefulWidget {
  const RotationAnimationDemo({super.key});

  @override
  State<RotationAnimationDemo> createState() => _RotationAnimationDemoState();
}

class _RotationAnimationDemoState extends State<RotationAnimationDemo> {
  int _restartKey = 0;

  void _restartAnimations() {
    setState(() {
      _restartKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildRestartButton(_restartAnimations, const Color(0xFFF59E0B)),

          const SizedBox(height: 24),

          buildAnimationCard(
            key: ValueKey('spin_clockwise_$_restartKey'),
            title: 'Spin Clockwise',
            subtitle: 'Full 360° clockwise rotation',
            icon: Icons.rotate_right,
            color: Colors.orange,
            child: RotationAnimationPresets.spinClockwise(
              buildDemoContent('🔄 Spin Right', Colors.orange),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('wobble_$_restartKey'),
            title: 'Wobble Effect',
            subtitle: 'Small rotation back and forth',
            icon: Icons.vibration,
            color: Colors.amber,
            child: RotationAnimationPresets.wobble(
              buildDemoContent('🌊 Wobble', Colors.amber),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('loading_spinner_$_restartKey'),
            title: 'Loading Spinner',
            subtitle: 'Continuous rotation for loading states',
            icon: Icons.refresh,
            color: Colors.yellow,
            child: RotationAnimationPresets.loadingSpinner(
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.yellow.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.refresh, size: 32, color: Colors.orange),
              ),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('tap_rotate_$_restartKey'),
            title: 'Interactive Tap to Rotate',
            subtitle: 'Tap to rotate by 90 degrees',
            icon: Icons.touch_app,
            color: Colors.deepOrange,
            child: TapToRotate(
              turns: 0.25, // 90 degrees
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rotated! 🔄'),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
              },
              child: buildDemoContent('🔄 Tap to Rotate', Colors.deepOrange),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class BounceAnimationDemo extends StatefulWidget {
  const BounceAnimationDemo({super.key});

  @override
  State<BounceAnimationDemo> createState() => _BounceAnimationDemoState();
}

class _BounceAnimationDemoState extends State<BounceAnimationDemo> {
  int _restartKey = 0;

  void _restartAnimations() {
    setState(() {
      _restartKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildRestartButton(_restartAnimations, const Color(0xFFEF4444)),

          const SizedBox(height: 24),

          buildAnimationCard(
            key: ValueKey('quick_bounce_$_restartKey'),
            title: 'Quick Bounce In',
            subtitle: 'Fast bounce animation with spring effect',
            icon: Icons.sports_basketball,
            color: Colors.red,
            child: BounceAnimationPresets.quickBounceIn(
              buildDemoContent('⚡ Quick Bounce', Colors.red),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('elastic_bounce_$_restartKey'),
            title: 'Elastic Bounce',
            subtitle: 'Smooth elastic bounce with overshoot',
            icon: Icons.waves,
            color: Colors.pink,
            child: BounceAnimationPresets.elasticBounceIn(
              buildDemoContent('🌊 Elastic Bounce', Colors.pink),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('rubber_band_$_restartKey'),
            title: 'Rubber Band Effect',
            subtitle: 'Stretchy rubber band animation',
            icon: Icons.linear_scale,
            color: Colors.redAccent,
            child: BounceAnimationPresets.rubberBand(
              buildDemoContent('🎯 Rubber Band', Colors.redAccent),
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('tap_bounce_$_restartKey'),
            title: 'Interactive Tap to Bounce',
            subtitle: 'Tap to trigger bounce animation',
            icon: Icons.touch_app,
            color: Colors.pink[700]!,
            child: TapToBounce(
              bounceType: BounceType.spring,
              intensity: 1.2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bounced! 🏀'),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
              },
              child: buildDemoContent('🏀 Tap to Bounce', Colors.pink[700]!),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class ShimmerAnimationDemo extends StatefulWidget {
  const ShimmerAnimationDemo({super.key});

  @override
  State<ShimmerAnimationDemo> createState() => _ShimmerAnimationDemoState();
}

class _ShimmerAnimationDemoState extends State<ShimmerAnimationDemo> {
  bool _isLoading = true;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _toggleLoading,
            icon: Icon(_isLoading ? Icons.stop : Icons.play_arrow),
            label: Text(_isLoading ? 'Stop Loading' : 'Start Loading'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          buildAnimationCard(
            key: const ValueKey('loading_text'),
            title: 'Loading Text Placeholder',
            subtitle: 'Shimmer effect for text content',
            icon: Icons.text_fields,
            color: Colors.purple,
            child: ShimmerAnimationPresets.loadingText(
              width: 200,
              height: 20,
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: const ValueKey('loading_avatar'),
            title: 'Loading Avatar',
            subtitle: 'Circular shimmer for profile pictures',
            icon: Icons.account_circle,
            color: Colors.indigo,
            child: ShimmerAnimationPresets.loadingAvatar(radius: 30),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: const ValueKey('loading_card'),
            title: 'Loading Card',
            subtitle: 'Rectangular shimmer for card content',
            icon: Icons.credit_card,
            color: Colors.blue,
            child: ShimmerAnimationPresets.loadingCard(
              width: double.infinity,
              height: 80,
            ),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: const ValueKey('loading_list'),
            title: 'Loading List Item',
            subtitle: 'Complete list item with avatar and text',
            icon: Icons.list,
            color: Colors.cyan,
            child: ShimmerAnimationPresets.loadingListItem(),
          ),

          const SizedBox(height: 16),

          buildAnimationCard(
            key: ValueKey('skeleton_loader_$_isLoading'),
            title: 'Skeleton Loader',
            subtitle: 'Toggle between loading and content',
            icon: Icons.visibility,
            color: Colors.teal,
            child: SkeletonLoader(
              isLoading: _isLoading,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.withValues(alpha: 0.1),
                      Colors.teal.withValues(alpha: 0.05)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.withValues(alpha: 0.2)),
                ),
                child: const Text(
                  '✨ This content shows when not loading!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class StaggeredAnimationDemo extends StatefulWidget {
  const StaggeredAnimationDemo({super.key});

  @override
  State<StaggeredAnimationDemo> createState() => _StaggeredAnimationDemoState();
}

class _StaggeredAnimationDemoState extends State<StaggeredAnimationDemo> {
  int _restartKey = 0;

  void _restartAnimations() {
    setState(() {
      _restartKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildRestartButton(_restartAnimations, const Color(0xFF6366F1)),

          const SizedBox(height: 24),

          const Text(
            'Staggered List Animation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            'Each item animates with a 150ms delay',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 16),

          // Staggered list
          Expanded(
            child: StaggeredList(
              key: ValueKey('staggered_list_$_restartKey'),
              staggerDelay: const Duration(milliseconds: 150),
              animationType: StaggeredListAnimationType.fadeSlide,
              slideDirection: SlideDirection.up,
              children: List.generate(
                8,
                (index) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColorForIndex(index),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'Staggered Item ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'This item animates with ${(index * 150)}ms delay',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Icon(
                      Icons.animation,
                      color: _getColorForIndex(index),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}