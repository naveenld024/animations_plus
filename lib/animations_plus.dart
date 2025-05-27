/// Animations Plus - A comprehensive animation package for Flutter
///
/// This library provides a collection of pre-built animation widgets and utilities
/// that make it easy to add smooth, performant animations to your Flutter apps
/// with minimal boilerplate code.
///
/// ## Features
/// - Pre-built animation widgets (fade, slide, scale, rotation, bounce, shimmer)
/// - Animation utilities for chaining and staggering animations
/// - Custom easing curves
/// - Simple, intuitive API
/// - Performance optimized for 60fps animations
///
/// ## Usage
/// ```dart
/// import 'package:animations_plus/animations_plus.dart';
///
/// // Simple fade animation
/// FadeAnimation(
///   child: Text('Hello World'),
/// )
///
/// // Slide animation with custom duration
/// SlideAnimation(
///   direction: SlideDirection.left,
///   duration: Duration(milliseconds: 800),
///   child: Container(...),
/// )
/// ```
library;

// Export all public APIs
export 'src/widgets/fade_animation.dart';
export 'src/widgets/slide_animation.dart';
export 'src/widgets/scale_animation.dart';
export 'src/widgets/rotation_animation.dart';
export 'src/widgets/bounce_animation.dart';
export 'src/widgets/shimmer_animation.dart';

export 'src/controllers/animation_chain.dart';
export 'src/controllers/staggered_animation.dart';
export 'src/controllers/animation_controller_extensions.dart';

export 'src/curves/custom_curves.dart';

export 'src/utils/animation_utils.dart';
export 'src/utils/animation_types.dart';
