/// Extensions for AnimationController to provide additional functionality
library;

import 'package:flutter/material.dart';
import '../utils/animation_types.dart';

/// Extension methods for AnimationController
extension AnimationControllerExtensions on AnimationController {
  /// Plays the animation forward with optional delay
  Future<void> playForward({Duration? delay}) async {
    if (delay != null && delay > Duration.zero) {
      await Future.delayed(delay);
    }
    return forward();
  }

  /// Plays the animation in reverse with optional delay
  Future<void> playReverse({Duration? delay}) async {
    if (delay != null && delay > Duration.zero) {
      await Future.delayed(delay);
    }
    return reverse();
  }

  /// Plays the animation and then reverses it
  Future<void> playForwardThenReverse({
    Duration? delay,
    Duration? pauseBetween,
  }) async {
    if (delay != null && delay > Duration.zero) {
      await Future.delayed(delay);
    }

    await forward();

    if (pauseBetween != null && pauseBetween > Duration.zero) {
      await Future.delayed(pauseBetween);
    }

    return reverse();
  }

  /// Repeats the animation a specified number of times
  Future<void> repeat({
    int? count,
    bool reverse = false,
    Duration? delay,
  }) async {
    if (delay != null && delay > Duration.zero) {
      await Future.delayed(delay);
    }

    if (count == null) {
      // Infinite repeat
      return this.repeat(reverse: reverse);
    }

    for (int i = 0; i < count; i++) {
      if (reverse) {
        await playForwardThenReverse();
      } else {
        await forward();
        reset();
      }
    }
  }

  /// Animates to a specific value
  Future<void> animateToValue(
    double target, {
    Duration? duration,
    Curve curve = Curves.linear,
  }) {
    return animateTo(
      target,
      duration: duration ?? this.duration,
      curve: curve,
    );
  }

  /// Bounces the animation (quick forward then reverse)
  Future<void> bounce({
    double intensity = 0.3,
    Duration? duration,
  }) async {
    final originalDuration = this.duration;
    final bounceDuration = duration ?? Duration(milliseconds: 200);

    this.duration = bounceDuration;

    await animateToValue(intensity);
    await reverse();

    this.duration = originalDuration;
  }

  /// Shakes the animation (quick left-right movement)
  Future<void> shake({
    int shakeCount = 3,
    double intensity = 0.1,
    Duration? duration,
  }) async {
    final originalValue = value;
    final shakeDuration = duration ?? Duration(milliseconds: 500);
    final singleShakeDuration = Duration(
      milliseconds: shakeDuration.inMilliseconds ~/ (shakeCount * 2),
    );

    for (int i = 0; i < shakeCount; i++) {
      await animateTo(
        originalValue + intensity,
        duration: singleShakeDuration,
        curve: Curves.easeInOut,
      );
      await animateTo(
        originalValue - intensity,
        duration: singleShakeDuration,
        curve: Curves.easeInOut,
      );
    }

    await animateTo(
      originalValue,
      duration: singleShakeDuration,
      curve: Curves.easeInOut,
    );
  }

  /// Pulses the animation (scale up and down)
  Future<void> pulse({
    double scale = 1.2,
    Duration? duration,
  }) async {
    final pulseDuration = duration ?? Duration(milliseconds: 600);
    final halfDuration = Duration(milliseconds: pulseDuration.inMilliseconds ~/ 2);

    await animateTo(scale, duration: halfDuration, curve: Curves.easeOut);
    await animateTo(1.0, duration: halfDuration, curve: Curves.easeIn);
  }

  /// Gets the current animation state
  AnimationState get animationState {
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

  /// Checks if the animation is currently running
  bool get isAnimating {
    return status == AnimationStatus.forward || status == AnimationStatus.reverse;
  }

  /// Checks if the animation is idle
  bool get isIdle {
    return status == AnimationStatus.dismissed || status == AnimationStatus.completed;
  }

  /// Creates a curved animation with the specified curve
  CurvedAnimation curved(Curve curve) {
    return CurvedAnimation(parent: this, curve: curve);
  }

  /// Creates a tween animation with the specified begin and end values
  Animation<T> tween<T>(T begin, T end) {
    return Tween<T>(begin: begin, end: end).animate(this);
  }

  /// Creates a color tween animation
  Animation<Color?> colorTween(Color begin, Color end) {
    return ColorTween(begin: begin, end: end).animate(this);
  }

  /// Creates an offset tween animation
  Animation<Offset> offsetTween(Offset begin, Offset end) {
    return Tween<Offset>(begin: begin, end: end).animate(this);
  }

  /// Creates a size tween animation
  Animation<Size> sizeTween(Size begin, Size end) {
    return Tween<Size>(begin: begin, end: end).animate(this);
  }
}
