/// Utility functions and helpers for animations
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'animation_types.dart';

/// Utility class with static helper methods for animations
class AnimationUtils {
  AnimationUtils._(); // Private constructor to prevent instantiation

  /// Converts [SlideDirection] to appropriate [Offset] for slide animations
  static Offset getSlideOffset(SlideDirection direction, double value) {
    switch (direction) {
      case SlideDirection.left:
        return Offset(-value, 0.0);
      case SlideDirection.right:
        return Offset(value, 0.0);
      case SlideDirection.up:
        return Offset(0.0, -value);
      case SlideDirection.down:
        return Offset(0.0, value);
    }
  }

  /// Converts [RotationDirection] to appropriate rotation value
  static double getRotationValue(RotationDirection direction, double value) {
    switch (direction) {
      case RotationDirection.clockwise:
        return value;
      case RotationDirection.counterClockwise:
        return -value;
    }
  }

  /// Creates a delayed animation that starts after the specified delay
  static Animation<double> createDelayedAnimation({
    required AnimationController controller,
    required Duration delay,
    Duration? duration,
    Curve curve = Curves.linear,
  }) {
    final totalDuration = controller.duration ?? const Duration(milliseconds: 300);
    final delayRatio = delay.inMilliseconds / totalDuration.inMilliseconds;

    if (delayRatio >= 1.0) {
      // If delay is longer than total duration, return a constant animation
      return AlwaysStoppedAnimation<double>(0.0);
    }

    final animationStart = delayRatio;
    final animationEnd = 1.0;

    return CurvedAnimation(
      parent: controller,
      curve: Interval(animationStart, animationEnd, curve: curve),
    );
  }

  /// Creates a staggered animation with multiple intervals
  static List<Animation<double>> createStaggeredAnimations({
    required AnimationController controller,
    required int count,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Curve curve = Curves.easeInOut,
  }) {
    final animations = <Animation<double>>[];
    final totalDuration = controller.duration ?? const Duration(milliseconds: 300);
    final staggerRatio = staggerDelay.inMilliseconds / totalDuration.inMilliseconds;

    for (int i = 0; i < count; i++) {
      final start = (i * staggerRatio).clamp(0.0, 1.0);
      final end = ((i * staggerRatio) + (1.0 - (count - 1) * staggerRatio)).clamp(0.0, 1.0);

      animations.add(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: curve),
        ),
      );
    }

    return animations;
  }

  /// Converts [AnimationStatus] to [AnimationState]
  static AnimationState statusToState(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        return AnimationState.dismissed;
      case AnimationStatus.forward:
        return AnimationState.forward;
      case AnimationStatus.reverse:
        return AnimationState.reverse;
      case AnimationStatus.completed:
        return AnimationState.completed;
    }
  }

  /// Calculates the appropriate duration based on distance for slide animations
  static Duration calculateSlideDuration({
    required double distance,
    double pixelsPerSecond = 1000.0,
    Duration minDuration = const Duration(milliseconds: 200),
    Duration maxDuration = const Duration(milliseconds: 800),
  }) {
    final calculatedDuration = Duration(
      milliseconds: (distance / pixelsPerSecond * 1000).round(),
    );

    if (calculatedDuration < minDuration) return minDuration;
    if (calculatedDuration > maxDuration) return maxDuration;
    return calculatedDuration;
  }

  /// Creates a bounce effect using a custom curve
  static Curve createBounceCurve({
    double bounciness = 0.5,
    double speed = 1.0,
  }) {
    return _BounceCurve(bounciness: bounciness, speed: speed);
  }

  /// Creates an elastic effect using a custom curve
  static Curve createElasticCurve({
    double period = 0.4,
    double amplitude = 1.0,
  }) {
    return _ElasticCurve(period: period, amplitude: amplitude);
  }
}

/// Custom bounce curve implementation
class _BounceCurve extends Curve {
  const _BounceCurve({
    this.bounciness = 0.5,
    this.speed = 1.0,
  });

  final double bounciness;
  final double speed;

  @override
  double transform(double t) {
    t *= speed;
    if (t < 1 / 2.75) {
      return 7.5625 * t * t;
    } else if (t < 2 / 2.75) {
      t -= 1.5 / 2.75;
      return 7.5625 * t * t + 0.75;
    } else if (t < 2.5 / 2.75) {
      t -= 2.25 / 2.75;
      return 7.5625 * t * t + 0.9375;
    } else {
      t -= 2.625 / 2.75;
      return 7.5625 * t * t + 0.984375;
    }
  }
}

/// Custom elastic curve implementation
class _ElasticCurve extends Curve {
  const _ElasticCurve({
    this.period = 0.4,
    this.amplitude = 1.0,
  });

  final double period;
  final double amplitude;

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) return t;

    final s = period / 4.0;
    t = t - 1.0;

    return -(amplitude * math.pow(2.0, 10.0 * t) *
             math.sin((t - s) * (2.0 * math.pi) / period));
  }
}
