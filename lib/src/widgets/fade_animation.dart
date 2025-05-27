/// Fade animation widget for smooth opacity transitions
library;

import 'package:flutter/material.dart';
import '../utils/animation_types.dart';

/// A widget that provides fade in/out animations
class FadeAnimation extends StatefulWidget {
  /// Creates a fade animation widget
  const FadeAnimation({
    super.key,
    required this.child,
    this.config = const AnimationConfig(),
    this.fadeIn = true,
    this.trigger = AnimationTrigger.automatic,
    this.onComplete,
    this.onStatusChanged,
  });

  /// The child widget to animate
  final Widget child;

  /// Animation configuration
  final AnimationConfig config;

  /// Whether to fade in (true) or fade out (false)
  final bool fadeIn;

  /// When to trigger the animation
  final AnimationTrigger trigger;

  /// Callback when animation completes
  final AnimationCallback? onComplete;

  /// Callback when animation status changes
  final AnimationStatusCallback? onStatusChanged;

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startAnimationIfNeeded();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve,
    );

    // Set initial value based on fade direction
    if (widget.fadeIn) {
      _controller.value = 0.0;
    } else {
      _controller.value = 1.0;
    }

    _controller.addStatusListener(_onStatusChanged);
  }

  void _startAnimationIfNeeded() {
    if (widget.trigger == AnimationTrigger.automatic && widget.config.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _playAnimation();
      });
    }
  }

  Future<void> _playAnimation() async {
    if (widget.config.delay > Duration.zero) {
      await Future.delayed(widget.config.delay);
    }

    if (widget.fadeIn) {
      await _controller.forward();
    } else {
      await _controller.reverse();
    }

    if (widget.config.autoReverse) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (widget.fadeIn) {
        await _controller.reverse();
      } else {
        await _controller.forward();
      }
    }

    if (widget.config.repeat) {
      _handleRepeat();
    }
  }

  void _handleRepeat() {
    if (widget.config.repeatCount != null) {
      _controller.repeat(
        reverse: widget.config.autoReverse,
      );

      // Stop after specified count
      Future.delayed(
        Duration(
          milliseconds: widget.config.duration.inMilliseconds *
                      (widget.config.repeatCount! * (widget.config.autoReverse ? 2 : 1)),
        ),
      ).then((_) {
        if (mounted) {
          _controller.stop();
        }
      });
    } else {
      _controller.repeat(reverse: widget.config.autoReverse);
    }
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onComplete?.call();
    }

    widget.onStatusChanged?.call(_getAnimationState(status));
  }

  AnimationState _getAnimationState(AnimationStatus status) {
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

  /// Manually trigger the animation
  Future<void> play() => _playAnimation();

  /// Play animation forward
  Future<void> forward() => _controller.forward();

  /// Play animation in reverse
  Future<void> reverse() => _controller.reverse();

  /// Reset animation to initial state
  void reset() {
    if (widget.fadeIn) {
      _controller.reset();
    } else {
      _controller.value = 1.0;
    }
  }

  /// Stop the animation
  void stop() => _controller.stop();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// A simplified fade animation widget with common presets
class SimpleFadeAnimation extends StatelessWidget {
  /// Creates a simple fade animation
  const SimpleFadeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
    this.fadeIn = true,
  });

  /// The child widget to animate
  final Widget child;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Delay before animation starts
  final Duration delay;

  /// Whether to fade in or out
  final bool fadeIn;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      config: AnimationConfig(
        duration: duration,
        curve: curve,
        delay: delay,
      ),
      fadeIn: fadeIn,
      child: child,
    );
  }
}

/// Preset fade animations for common use cases
class FadeAnimationPresets {
  FadeAnimationPresets._();

  /// Quick fade in (200ms)
  static Widget quickFadeIn(Widget child) {
    return SimpleFadeAnimation(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: child,
    );
  }

  /// Slow fade in (800ms)
  static Widget slowFadeIn(Widget child) {
    return SimpleFadeAnimation(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: child,
    );
  }

  /// Fade in with delay
  static Widget delayedFadeIn(Widget child, Duration delay) {
    return SimpleFadeAnimation(
      duration: const Duration(milliseconds: 400),
      delay: delay,
      child: child,
    );
  }

  /// Smooth fade out
  static Widget fadeOut(Widget child) {
    return SimpleFadeAnimation(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      fadeIn: false,
      child: child,
    );
  }
}
