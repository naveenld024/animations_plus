/// Scale animation widget for smooth size transitions
library;

import 'package:flutter/material.dart';
import '../utils/animation_types.dart';

/// A widget that provides scale/zoom animations
class ScaleAnimation extends StatefulWidget {
  /// Creates a scale animation widget
  const ScaleAnimation({
    super.key,
    required this.child,
    this.config = const AnimationConfig(),
    this.scaleFrom = 0.0,
    this.scaleTo = 1.0,
    this.alignment = Alignment.center,
    this.trigger = AnimationTrigger.automatic,
    this.onComplete,
    this.onStatusChanged,
  });

  /// The child widget to animate
  final Widget child;

  /// Animation configuration
  final AnimationConfig config;

  /// Initial scale value
  final double scaleFrom;

  /// Final scale value
  final double scaleTo;

  /// Alignment for the scale transformation
  final Alignment alignment;

  /// When to trigger the animation
  final AnimationTrigger trigger;

  /// Callback when animation completes
  final AnimationCallback? onComplete;

  /// Callback when animation status changes
  final AnimationStatusCallback? onStatusChanged;

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
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

    _animation = Tween<double>(
      begin: widget.scaleFrom,
      end: widget.scaleTo,
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
    return ScaleTransition(
      scale: _animation,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}

/// A simplified scale animation widget with common presets
class SimpleScaleAnimation extends StatelessWidget {
  /// Creates a simple scale animation
  const SimpleScaleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
    this.scaleFrom = 0.0,
    this.scaleTo = 1.0,
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

  /// Initial scale value
  final double scaleFrom;

  /// Final scale value
  final double scaleTo;

  /// Alignment for the scale transformation
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ScaleAnimation(
      scaleFrom: scaleFrom,
      scaleTo: scaleTo,
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

/// Preset scale animations for common use cases
class ScaleAnimationPresets {
  ScaleAnimationPresets._();

  /// Scale in from zero
  static Widget scaleIn(Widget child, {Duration? duration}) {
    return SimpleScaleAnimation(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      scaleFrom: 0.0,
      scaleTo: 1.0,
      child: child,
    );
  }

  /// Scale out to zero
  static Widget scaleOut(Widget child, {Duration? duration}) {
    return SimpleScaleAnimation(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      scaleFrom: 1.0,
      scaleTo: 0.0,
      child: child,
    );
  }

  /// Pop in with overshoot
  static Widget popIn(Widget child) {
    return SimpleScaleAnimation(
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      scaleFrom: 0.0,
      scaleTo: 1.0,
      child: child,
    );
  }

  /// Zoom in with bounce
  static Widget zoomInBounce(Widget child) {
    return SimpleScaleAnimation(
      duration: const Duration(milliseconds: 600),
      curve: Curves.bounceOut,
      scaleFrom: 0.3,
      scaleTo: 1.0,
      child: child,
    );
  }

  /// Pulse effect (scale up and down)
  static Widget pulse(Widget child, {double scale = 1.1}) {
    return ScaleAnimation(
      scaleFrom: 1.0,
      scaleTo: scale,
      config: const AnimationConfig(
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        autoReverse: true,
        repeat: true,
      ),
      child: child,
    );
  }

  /// Heartbeat effect
  static Widget heartbeat(Widget child) {
    return ScaleAnimation(
      scaleFrom: 1.0,
      scaleTo: 1.3,
      config: const AnimationConfig(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        autoReverse: true,
        repeat: true,
      ),
      child: child,
    );
  }

  /// Scale from center with custom alignment
  static Widget scaleFromCorner(Widget child, Alignment alignment) {
    return SimpleScaleAnimation(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      scaleFrom: 0.0,
      scaleTo: 1.0,
      alignment: alignment,
      child: child,
    );
  }

  /// Gentle scale in
  static Widget gentleScaleIn(Widget child) {
    return SimpleScaleAnimation(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      scaleFrom: 0.8,
      scaleTo: 1.0,
      child: child,
    );
  }
}

/// A widget that scales in when tapped
class TapToScale extends StatefulWidget {
  /// Creates a tap-to-scale widget
  const TapToScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.95,
    this.duration = const Duration(milliseconds: 100),
  });

  /// The child widget
  final Widget child;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Scale value when pressed down
  final double scaleDown;

  /// Animation duration
  final Duration duration;

  @override
  State<TapToScale> createState() => _TapToScaleState();
}

class _TapToScaleState extends State<TapToScale>
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
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
