/// Shimmer animation widget for loading effects and highlights
library;

import 'package:flutter/material.dart';
import '../utils/animation_types.dart';

/// A widget that provides shimmer/loading animations
class ShimmerAnimation extends StatefulWidget {
  /// Creates a shimmer animation widget
  const ShimmerAnimation({
    super.key,
    required this.child,
    this.config = const AnimationConfig(
      duration: Duration(milliseconds: 1500),
      repeat: true,
    ),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.direction = ShimmerDirection.leftToRight,
    this.enabled = true,
    this.onComplete,
  });

  /// The child widget to apply shimmer effect to
  final Widget child;

  /// Animation configuration
  final AnimationConfig config;

  /// Base color of the shimmer
  final Color baseColor;

  /// Highlight color of the shimmer
  final Color highlightColor;

  /// Direction of the shimmer effect
  final ShimmerDirection direction;

  /// Whether the shimmer effect is enabled
  final bool enabled;

  /// Callback when animation completes (for non-repeating animations)
  final AnimationCallback? onComplete;

  @override
  State<ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startAnimation();
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

    if (!widget.config.repeat) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });
    }
  }

  void _startAnimation() {
    if (!widget.enabled) return;

    if (widget.config.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ShimmerAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _startAnimation();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return _createShimmerGradient(bounds).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }

  LinearGradient _createShimmerGradient(Rect bounds) {
    final progress = _animation.value;

    // Calculate gradient positions based on direction and progress
    final (begin, end) = _getGradientAlignment();
    final gradientWidth = 0.3; // Width of the shimmer highlight

    // Calculate the position of the shimmer highlight
    final shimmerPosition = progress * (1.0 + gradientWidth) - gradientWidth;

    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        widget.baseColor,
        widget.baseColor,
        widget.highlightColor,
        widget.baseColor,
        widget.baseColor,
      ],
      stops: [
        (shimmerPosition - gradientWidth).clamp(0.0, 1.0),
        (shimmerPosition - gradientWidth / 2).clamp(0.0, 1.0),
        shimmerPosition.clamp(0.0, 1.0),
        (shimmerPosition + gradientWidth / 2).clamp(0.0, 1.0),
        (shimmerPosition + gradientWidth).clamp(0.0, 1.0),
      ],
    );
  }

  (Alignment, Alignment) _getGradientAlignment() {
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        return (Alignment.centerLeft, Alignment.centerRight);
      case ShimmerDirection.rightToLeft:
        return (Alignment.centerRight, Alignment.centerLeft);
      case ShimmerDirection.topToBottom:
        return (Alignment.topCenter, Alignment.bottomCenter);
      case ShimmerDirection.bottomToTop:
        return (Alignment.bottomCenter, Alignment.topCenter);
      case ShimmerDirection.diagonal:
        return (Alignment.topLeft, Alignment.bottomRight);
    }
  }
}

/// Direction of the shimmer effect
enum ShimmerDirection {
  /// Left to right shimmer
  leftToRight,
  /// Right to left shimmer
  rightToLeft,
  /// Top to bottom shimmer
  topToBottom,
  /// Bottom to top shimmer
  bottomToTop,
  /// Diagonal shimmer
  diagonal,
}

/// A simplified shimmer animation widget with common presets
class SimpleShimmerAnimation extends StatelessWidget {
  /// Creates a simple shimmer animation
  const SimpleShimmerAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.direction = ShimmerDirection.leftToRight,
    this.enabled = true,
  });

  /// The child widget to animate
  final Widget child;

  /// Animation duration
  final Duration duration;

  /// Base color
  final Color baseColor;

  /// Highlight color
  final Color highlightColor;

  /// Shimmer direction
  final ShimmerDirection direction;

  /// Whether shimmer is enabled
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ShimmerAnimation(
      config: AnimationConfig(
        duration: duration,
        repeat: true,
        curve: Curves.linear,
      ),
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: direction,
      enabled: enabled,
      child: child,
    );
  }
}

/// Preset shimmer animations for common use cases
class ShimmerAnimationPresets {
  ShimmerAnimationPresets._();

  /// Loading shimmer for text
  static Widget loadingText({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return SimpleShimmerAnimation(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }

  /// Loading shimmer for circular avatar
  static Widget loadingAvatar({required double radius}) {
    return SimpleShimmerAnimation(
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[300],
      ),
    );
  }

  /// Loading shimmer for rectangular card
  static Widget loadingCard({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return SimpleShimmerAnimation(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Loading shimmer for list item
  static Widget loadingListItem() {
    return SimpleShimmerAnimation(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Highlight shimmer effect
  static Widget highlight(Widget child) {
    return ShimmerAnimation(
      config: const AnimationConfig(
        duration: Duration(milliseconds: 800),
        repeat: false,
      ),
      baseColor: Colors.transparent,
      highlightColor: Colors.white.withValues(alpha: 0.3),
      child: child,
    );
  }

  /// Success shimmer effect
  static Widget success(Widget child) {
    return ShimmerAnimation(
      config: const AnimationConfig(
        duration: Duration(milliseconds: 600),
        repeat: false,
      ),
      baseColor: Colors.transparent,
      highlightColor: Colors.green.withValues(alpha: 0.3),
      child: child,
    );
  }

  /// Custom color shimmer
  static Widget customColor(
    Widget child, {
    required Color baseColor,
    required Color highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    ShimmerDirection direction = ShimmerDirection.leftToRight,
  }) {
    return SimpleShimmerAnimation(
      duration: duration,
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: direction,
      child: child,
    );
  }
}

/// A widget that creates a skeleton loading effect
class SkeletonLoader extends StatelessWidget {
  /// Creates a skeleton loader
  const SkeletonLoader({
    super.key,
    required this.child,
    this.isLoading = true,
    this.shimmerBaseColor = const Color(0xFFE0E0E0),
    this.shimmerHighlightColor = const Color(0xFFF5F5F5),
  });

  /// The actual content to show when not loading
  final Widget child;

  /// Whether to show the loading skeleton
  final bool isLoading;

  /// Base color for shimmer
  final Color shimmerBaseColor;

  /// Highlight color for shimmer
  final Color shimmerHighlightColor;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    return SimpleShimmerAnimation(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: child,
    );
  }
}
