/// Bounce animation widget for elastic and bouncy effects
library;

import 'package:flutter/material.dart';
import '../utils/animation_types.dart';
import '../curves/custom_curves.dart';

/// A widget that provides bounce animations with elastic effects
class BounceAnimation extends StatefulWidget {
  /// Creates a bounce animation widget
  const BounceAnimation({
    super.key,
    required this.child,
    this.config = const AnimationConfig(),
    this.bounceType = BounceType.bounceIn,
    this.intensity = 1.0,
    this.trigger = AnimationTrigger.automatic,
    this.onComplete,
    this.onStatusChanged,
  });

  /// The child widget to animate
  final Widget child;

  /// Animation configuration
  final AnimationConfig config;

  /// Type of bounce animation
  final BounceType bounceType;

  /// Intensity of the bounce effect (0.0 to 2.0)
  final double intensity;

  /// When to trigger the animation
  final AnimationTrigger trigger;

  /// Callback when animation completes
  final AnimationCallback? onComplete;

  /// Callback when animation status changes
  final AnimationStatusCallback? onStatusChanged;

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
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

    final curve = _getBounceeCurve();
    final (begin, end) = _getAnimationValues();

    _animation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    _controller.addStatusListener(_onStatusChanged);
  }

  Curve _getBounceeCurve() {
    switch (widget.bounceType) {
      case BounceType.bounceIn:
      case BounceType.bounceOut:
        return Curves.bounceOut;
      case BounceType.elastic:
        return CustomCurves.elastic;
      case BounceType.rubber:
        return CustomCurves.rubberBand;
      case BounceType.spring:
        return Curves.elasticOut;
    }
  }

  (double, double) _getAnimationValues() {
    switch (widget.bounceType) {
      case BounceType.bounceIn:
        return (0.0, widget.intensity);
      case BounceType.bounceOut:
        return (widget.intensity, 0.0);
      case BounceType.elastic:
      case BounceType.rubber:
      case BounceType.spring:
        return (0.0, widget.intensity);
    }
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Types of bounce animations
enum BounceType {
  /// Bounce in from zero scale
  bounceIn,
  /// Bounce out to zero scale
  bounceOut,
  /// Elastic bounce effect
  elastic,
  /// Rubber band effect
  rubber,
  /// Spring bounce effect
  spring,
}

/// A simplified bounce animation widget with common presets
class SimpleBounceAnimation extends StatelessWidget {
  /// Creates a simple bounce animation
  const SimpleBounceAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.bounceType = BounceType.bounceIn,
    this.intensity = 1.0,
  });

  /// The child widget to animate
  final Widget child;

  /// Animation duration
  final Duration duration;

  /// Delay before animation starts
  final Duration delay;

  /// Type of bounce
  final BounceType bounceType;

  /// Bounce intensity
  final double intensity;

  @override
  Widget build(BuildContext context) {
    return BounceAnimation(
      bounceType: bounceType,
      intensity: intensity,
      config: AnimationConfig(
        duration: duration,
        delay: delay,
      ),
      child: child,
    );
  }
}

/// Preset bounce animations for common use cases
class BounceAnimationPresets {
  BounceAnimationPresets._();

  /// Quick bounce in
  static Widget quickBounceIn(Widget child) {
    return SimpleBounceAnimation(
      duration: const Duration(milliseconds: 400),
      bounceType: BounceType.bounceIn,
      child: child,
    );
  }

  /// Elastic bounce in
  static Widget elasticBounceIn(Widget child) {
    return SimpleBounceAnimation(
      duration: const Duration(milliseconds: 800),
      bounceType: BounceType.elastic,
      child: child,
    );
  }

  /// Rubber band effect
  static Widget rubberBand(Widget child) {
    return SimpleBounceAnimation(
      duration: const Duration(milliseconds: 600),
      bounceType: BounceType.rubber,
      intensity: 1.2,
      child: child,
    );
  }

  /// Spring bounce
  static Widget springBounce(Widget child) {
    return SimpleBounceAnimation(
      duration: const Duration(milliseconds: 700),
      bounceType: BounceType.spring,
      child: child,
    );
  }

  /// Gentle bounce
  static Widget gentleBounce(Widget child) {
    return SimpleBounceAnimation(
      duration: const Duration(milliseconds: 500),
      bounceType: BounceType.bounceIn,
      intensity: 0.8,
      child: child,
    );
  }

  /// Strong bounce
  static Widget strongBounce(Widget child) {
    return SimpleBounceAnimation(
      duration: const Duration(milliseconds: 800),
      bounceType: BounceType.elastic,
      intensity: 1.3,
      child: child,
    );
  }

  /// Continuous bounce (repeating)
  static Widget continuousBounce(Widget child) {
    return BounceAnimation(
      bounceType: BounceType.bounceIn,
      intensity: 1.1,
      config: const AnimationConfig(
        duration: Duration(milliseconds: 1000),
        autoReverse: true,
        repeat: true,
      ),
      child: child,
    );
  }
}

/// A widget that bounces when tapped
class TapToBounce extends StatefulWidget {
  /// Creates a tap-to-bounce widget
  const TapToBounce({
    super.key,
    required this.child,
    this.onTap,
    this.bounceType = BounceType.spring,
    this.intensity = 1.2,
    this.duration = const Duration(milliseconds: 300),
  });

  /// The child widget
  final Widget child;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Type of bounce
  final BounceType bounceType;

  /// Bounce intensity
  final double intensity;

  /// Animation duration
  final Duration duration;

  @override
  State<TapToBounce> createState() => _TapToBounceState();
}

class _TapToBounceState extends State<TapToBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.intensity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: _getBounceeCurve(),
    ));
  }

  Curve _getBounceeCurve() {
    switch (widget.bounceType) {
      case BounceType.bounceIn:
      case BounceType.bounceOut:
        return Curves.bounceOut;
      case BounceType.elastic:
        return CustomCurves.elastic;
      case BounceType.rubber:
        return CustomCurves.rubberBand;
      case BounceType.spring:
        return Curves.elasticOut;
    }
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
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
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
