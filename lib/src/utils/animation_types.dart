/// Common types and enums used throughout the animation package
library;

import 'package:flutter/material.dart';

/// Direction for slide animations
enum SlideDirection {
  /// Slide from left to right
  left,
  /// Slide from right to left
  right,
  /// Slide from top to bottom
  up,
  /// Slide from bottom to top
  down,
}

/// Direction for rotation animations
enum RotationDirection {
  /// Clockwise rotation
  clockwise,
  /// Counter-clockwise rotation
  counterClockwise,
}

/// Animation trigger types
enum AnimationTrigger {
  /// Animation starts automatically when widget is built
  automatic,
  /// Animation starts when widget becomes visible
  onVisible,
  /// Animation is controlled manually
  manual,
}

/// Animation state for tracking current status
enum AnimationState {
  /// Animation is idle/not started
  idle,
  /// Animation is currently running forward
  forward,
  /// Animation is currently running in reverse
  reverse,
  /// Animation has completed
  completed,
  /// Animation was dismissed/reset
  dismissed,
}

/// Configuration for animation behavior
class AnimationConfig {
  /// Creates an animation configuration
  const AnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
    this.autoPlay = true,
    this.autoReverse = false,
    this.repeat = false,
    this.repeatCount,
  });

  /// Duration of the animation
  final Duration duration;
  
  /// Animation curve/easing function
  final Curve curve;
  
  /// Delay before animation starts
  final Duration delay;
  
  /// Whether animation should start automatically
  final bool autoPlay;
  
  /// Whether animation should reverse automatically after completion
  final bool autoReverse;
  
  /// Whether animation should repeat
  final bool repeat;
  
  /// Number of times to repeat (null for infinite)
  final int? repeatCount;

  /// Creates a copy with modified properties
  AnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    bool? autoPlay,
    bool? autoReverse,
    bool? repeat,
    int? repeatCount,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      autoPlay: autoPlay ?? this.autoPlay,
      autoReverse: autoReverse ?? this.autoReverse,
      repeat: repeat ?? this.repeat,
      repeatCount: repeatCount ?? this.repeatCount,
    );
  }
}

/// Callback function type for animation events
typedef AnimationCallback = void Function();

/// Callback function type for animation status changes
typedef AnimationStatusCallback = void Function(AnimationState state);

/// Callback function type for animation value changes
typedef AnimationValueCallback = void Function(double value);
