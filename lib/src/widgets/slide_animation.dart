/// Slide animation widget for smooth position transitions
library;

import 'package:flutter/material.dart';
import '../utils/animation_types.dart';
import '../utils/animation_utils.dart';

/// A widget that provides slide animations in various directions
class SlideAnimation extends StatefulWidget {
  /// Creates a slide animation widget
  const SlideAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.left,
    this.config = const AnimationConfig(),
    this.distance = 1.0,
    this.trigger = AnimationTrigger.automatic,
    this.onComplete,
    this.onStatusChanged,
  });

  /// The child widget to animate
  final Widget child;

  /// Direction of the slide animation
  final SlideDirection direction;

  /// Animation configuration
  final AnimationConfig config;

  /// Distance to slide (1.0 = full widget width/height)
  final double distance;

  /// When to trigger the animation
  final AnimationTrigger trigger;

  /// Callback when animation completes
  final AnimationCallback? onComplete;

  /// Callback when animation status changes
  final AnimationStatusCallback? onStatusChanged;

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

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

    final begin = AnimationUtils.getSlideOffset(widget.direction, widget.distance);
    const end = Offset.zero;

    _animation = Tween<Offset>(
      begin: begin,
      end: end,
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
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

/// A simplified slide animation widget with common presets
class SimpleSlideAnimation extends StatelessWidget {
  /// Creates a simple slide animation
  const SimpleSlideAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.left,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
    this.distance = 1.0,
  });

  /// The child widget to animate
  final Widget child;

  /// Direction of the slide
  final SlideDirection direction;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Delay before animation starts
  final Duration delay;

  /// Distance to slide
  final double distance;

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      direction: direction,
      distance: distance,
      config: AnimationConfig(
        duration: duration,
        curve: curve,
        delay: delay,
      ),
      child: child,
    );
  }
}

/// Preset slide animations for common use cases
class SlideAnimationPresets {
  SlideAnimationPresets._();

  /// Slide in from left
  static Widget slideInLeft(Widget child, {Duration? duration}) {
    return SimpleSlideAnimation(
      direction: SlideDirection.left,
      duration: duration ?? const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: child,
    );
  }

  /// Slide in from right
  static Widget slideInRight(Widget child, {Duration? duration}) {
    return SimpleSlideAnimation(
      direction: SlideDirection.right,
      duration: duration ?? const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: child,
    );
  }

  /// Slide in from top
  static Widget slideInUp(Widget child, {Duration? duration}) {
    return SimpleSlideAnimation(
      direction: SlideDirection.up,
      duration: duration ?? const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: child,
    );
  }

  /// Slide in from bottom
  static Widget slideInDown(Widget child, {Duration? duration}) {
    return SimpleSlideAnimation(
      direction: SlideDirection.down,
      duration: duration ?? const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: child,
    );
  }

  /// Quick slide with bounce
  static Widget slideInWithBounce(Widget child, SlideDirection direction) {
    return SimpleSlideAnimation(
      direction: direction,
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      child: child,
    );
  }

  /// Slow slide with custom distance
  static Widget slowSlide(Widget child, SlideDirection direction, double distance) {
    return SimpleSlideAnimation(
      direction: direction,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      distance: distance,
      child: child,
    );
  }
}

/// A widget that slides in when it becomes visible on screen
class SlideInOnVisible extends StatefulWidget {
  /// Creates a slide animation that triggers when visible
  const SlideInOnVisible({
    super.key,
    required this.child,
    this.direction = SlideDirection.up,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.threshold = 0.1,
  });

  /// The child widget to animate
  final Widget child;

  /// Direction of the slide
  final SlideDirection direction;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Threshold for visibility (0.0 to 1.0)
  final double threshold;

  @override
  State<SlideInOnVisible> createState() => _SlideInOnVisibleState();
}

class _SlideInOnVisibleState extends State<SlideInOnVisible> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (info) {
        if (!_isVisible && info.visibleFraction >= widget.threshold) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible
          ? SimpleSlideAnimation(
              direction: widget.direction,
              duration: widget.duration,
              curve: widget.curve,
              child: widget.child,
            )
          : Opacity(
              opacity: 0.0,
              child: widget.child,
            ),
    );
  }
}

/// Simple visibility detector for triggering animations
class VisibilityDetector extends StatefulWidget {
  const VisibilityDetector({
    super.key,
    required this.child,
    required this.onVisibilityChanged,
  });

  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  @override
  Widget build(BuildContext context) {
    // Simplified implementation - in a real package you'd use
    // a proper visibility detection library
    return widget.child;
  }
}

/// Information about widget visibility
class VisibilityInfo {
  const VisibilityInfo({required this.visibleFraction});
  final double visibleFraction;
}
