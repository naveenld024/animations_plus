/// Rotation animation widget for smooth rotational transitions
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/animation_types.dart';
import '../utils/animation_utils.dart';

/// A widget that provides rotation animations
class RotationAnimation extends StatefulWidget {
  /// Creates a rotation animation widget
  const RotationAnimation({
    super.key,
    required this.child,
    this.config = const AnimationConfig(),
    this.direction = RotationDirection.clockwise,
    this.turns = 1.0,
    this.alignment = Alignment.center,
    this.trigger = AnimationTrigger.automatic,
    this.onComplete,
    this.onStatusChanged,
  });

  /// The child widget to animate
  final Widget child;

  /// Animation configuration
  final AnimationConfig config;

  /// Direction of rotation
  final RotationDirection direction;

  /// Number of full turns to rotate
  final double turns;

  /// Alignment for the rotation transformation
  final Alignment alignment;

  /// When to trigger the animation
  final AnimationTrigger trigger;

  /// Callback when animation completes
  final AnimationCallback? onComplete;

  /// Callback when animation status changes
  final AnimationStatusCallback? onStatusChanged;

  @override
  State<RotationAnimation> createState() => _RotationAnimationState();
}

class _RotationAnimationState extends State<RotationAnimation>
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

    final rotationValue = AnimationUtils.getRotationValue(
      widget.direction,
      widget.turns,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: rotationValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve,
    ));

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

    await _controller.forward();

    if (widget.config.autoReverse) {
      await Future.delayed(const Duration(milliseconds: 100));
      await _controller.reverse();
    }

    if (widget.config.repeat) {
      _handleRepeat();
    }
  }

  void _handleRepeat() {
    if (widget.config.repeatCount != null) {
      _controller.repeat(reverse: widget.config.autoReverse);
      
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
  void reset() => _controller.reset();

  /// Stop the animation
  void stop() => _controller.stop();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}

/// A simplified rotation animation widget with common presets
class SimpleRotationAnimation extends StatelessWidget {
  /// Creates a simple rotation animation
  const SimpleRotationAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
    this.direction = RotationDirection.clockwise,
    this.turns = 1.0,
    this.alignment = Alignment.center,
  });

  /// The child widget to animate
  final Widget child;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Delay before animation starts
  final Duration delay;

  /// Direction of rotation
  final RotationDirection direction;

  /// Number of turns
  final double turns;

  /// Alignment for rotation
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return RotationAnimation(
      direction: direction,
      turns: turns,
      alignment: alignment,
      config: AnimationConfig(
        duration: duration,
        curve: curve,
        delay: delay,
      ),
      child: child,
    );
  }
}

/// Preset rotation animations for common use cases
class RotationAnimationPresets {
  RotationAnimationPresets._();

  /// Spin clockwise once
  static Widget spinClockwise(Widget child, {Duration? duration}) {
    return SimpleRotationAnimation(
      duration: duration ?? const Duration(milliseconds: 500),
      direction: RotationDirection.clockwise,
      turns: 1.0,
      child: child,
    );
  }

  /// Spin counter-clockwise once
  static Widget spinCounterClockwise(Widget child, {Duration? duration}) {
    return SimpleRotationAnimation(
      duration: duration ?? const Duration(milliseconds: 500),
      direction: RotationDirection.counterClockwise,
      turns: 1.0,
      child: child,
    );
  }

  /// Continuous spinning animation
  static Widget continuousSpin(Widget child, {RotationDirection? direction}) {
    return RotationAnimation(
      direction: direction ?? RotationDirection.clockwise,
      turns: 1.0,
      config: const AnimationConfig(
        duration: Duration(milliseconds: 1000),
        curve: Curves.linear,
        repeat: true,
      ),
      child: child,
    );
  }

  /// Wobble effect (small rotation back and forth)
  static Widget wobble(Widget child) {
    return RotationAnimation(
      direction: RotationDirection.clockwise,
      turns: 0.05, // Small rotation
      config: const AnimationConfig(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        autoReverse: true,
        repeat: true,
        repeatCount: 3,
      ),
      child: child,
    );
  }

  /// Flip animation (180 degrees)
  static Widget flip(Widget child, {bool horizontal = false}) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateY(horizontal ? math.pi : 0)
        ..rotateX(horizontal ? 0 : math.pi),
      child: SimpleRotationAnimation(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        turns: 0.5,
        child: child,
      ),
    );
  }

  /// Shake animation (quick rotations)
  static Widget shake(Widget child) {
    return RotationAnimation(
      direction: RotationDirection.clockwise,
      turns: 0.02,
      config: const AnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        autoReverse: true,
        repeat: true,
        repeatCount: 5,
      ),
      child: child,
    );
  }

  /// Pendulum swing
  static Widget pendulum(Widget child) {
    return RotationAnimation(
      direction: RotationDirection.clockwise,
      turns: 0.1,
      config: const AnimationConfig(
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        autoReverse: true,
        repeat: true,
      ),
      child: child,
    );
  }

  /// Loading spinner
  static Widget loadingSpinner(Widget child) {
    return RotationAnimation(
      direction: RotationDirection.clockwise,
      turns: 1.0,
      config: const AnimationConfig(
        duration: Duration(milliseconds: 1200),
        curve: Curves.linear,
        repeat: true,
      ),
      child: child,
    );
  }
}

/// A widget that rotates on tap
class TapToRotate extends StatefulWidget {
  /// Creates a tap-to-rotate widget
  const TapToRotate({
    super.key,
    required this.child,
    this.onTap,
    this.turns = 0.25,
    this.duration = const Duration(milliseconds: 200),
  });

  /// The child widget
  final Widget child;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Number of turns per tap
  final double turns;

  /// Animation duration
  final Duration duration;

  @override
  State<TapToRotate> createState() => _TapToRotateState();
}

class _TapToRotateState extends State<TapToRotate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  double _currentRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _updateRotationAnimation();
  }

  void _updateRotationAnimation() {
    _rotationAnimation = Tween<double>(
      begin: _currentRotation,
      end: _currentRotation + widget.turns,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  void _handleTap() {
    _currentRotation += widget.turns;
    _updateRotationAnimation();
    _controller.forward(from: 0.0);
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: RotationTransition(
        turns: _rotationAnimation,
        child: widget.child,
      ),
    );
  }
}
