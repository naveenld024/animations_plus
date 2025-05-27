/// Staggered animation controller for creating sequential animations with delays
library;

import 'package:flutter/material.dart';
import '../utils/animation_types.dart';
import '../utils/animation_utils.dart';

/// A controller that manages staggered animations
class StaggeredAnimationController extends ChangeNotifier {
  /// Creates a staggered animation controller
  StaggeredAnimationController({
    required this.itemCount,
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 1000),
    Duration staggerDelay = const Duration(milliseconds: 100),
    Curve curve = Curves.easeInOut,
    this.onComplete,
  }) : _vsync = vsync,
       _staggerDelay = staggerDelay,
       _curve = curve {
    
    _controller = AnimationController(
      duration: duration,
      vsync: _vsync,
    );

    _setupAnimations();
    _controller.addStatusListener(_onStatusChanged);
  }

  final int itemCount;
  final TickerProvider _vsync;
  final Duration _staggerDelay;
  final Curve _curve;
  final AnimationCallback? onComplete;

  late final AnimationController _controller;
  late final List<Animation<double>> _animations;
  
  bool _disposed = false;

  /// Sets up individual animations for each item
  void _setupAnimations() {
    _animations = AnimationUtils.createStaggeredAnimations(
      controller: _controller,
      count: itemCount,
      staggerDelay: _staggerDelay,
      curve: _curve,
    );
  }

  /// Handles animation status changes
  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      onComplete?.call();
    }
    notifyListeners();
  }

  /// Gets the animation for a specific item index
  Animation<double> getAnimation(int index) {
    if (index < 0 || index >= itemCount) {
      throw RangeError.index(index, _animations, 'index');
    }
    return _animations[index];
  }

  /// Gets all animations
  List<Animation<double>> get animations => List.unmodifiable(_animations);

  /// Gets the main animation controller
  AnimationController get controller => _controller;

  /// Plays the staggered animation forward
  Future<void> forward() => _controller.forward();

  /// Plays the staggered animation in reverse
  Future<void> reverse() => _controller.reverse();

  /// Resets the animation to the beginning
  void reset() => _controller.reset();

  /// Stops the animation
  void stop() => _controller.stop();

  /// Gets the current animation status
  AnimationStatus get status => _controller.status;

  /// Gets the current animation value (0.0 to 1.0)
  double get value => _controller.value;

  /// Checks if the animation is currently running
  bool get isAnimating => _controller.isAnimating;

  /// Checks if the animation is completed
  bool get isCompleted => _controller.isCompleted;

  /// Checks if the animation is dismissed
  bool get isDismissed => _controller.isDismissed;

  @override
  void dispose() {
    if (_disposed) return;
    
    _controller.removeStatusListener(_onStatusChanged);
    _controller.dispose();
    _disposed = true;
    super.dispose();
  }
}

/// Widget that provides staggered animations for its children
class StaggeredAnimationBuilder extends StatefulWidget {
  /// Creates a staggered animation builder
  const StaggeredAnimationBuilder({
    super.key,
    required this.itemCount,
    required this.builder,
    this.duration = const Duration(milliseconds: 1000),
    this.staggerDelay = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
    this.autoPlay = true,
    this.onComplete,
  });

  /// Number of items to animate
  final int itemCount;

  /// Builder function for each animated item
  final Widget Function(BuildContext context, int index, Animation<double> animation) builder;

  /// Total duration of the animation
  final Duration duration;

  /// Delay between each item's animation start
  final Duration staggerDelay;

  /// Animation curve
  final Curve curve;

  /// Whether to start animation automatically
  final bool autoPlay;

  /// Callback when animation completes
  final AnimationCallback? onComplete;

  @override
  State<StaggeredAnimationBuilder> createState() => _StaggeredAnimationBuilderState();
}

class _StaggeredAnimationBuilderState extends State<StaggeredAnimationBuilder>
    with TickerProviderStateMixin {
  late StaggeredAnimationController _staggeredController;

  @override
  void initState() {
    super.initState();
    
    _staggeredController = StaggeredAnimationController(
      itemCount: widget.itemCount,
      vsync: this,
      duration: widget.duration,
      staggerDelay: widget.staggerDelay,
      curve: widget.curve,
      onComplete: widget.onComplete,
    );

    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _staggeredController.forward();
      });
    }
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _staggeredController,
      builder: (context, child) {
        return Column(
          children: List.generate(
            widget.itemCount,
            (index) => widget.builder(
              context,
              index,
              _staggeredController.getAnimation(index),
            ),
          ),
        );
      },
    );
  }
}

/// Widget that provides staggered list animations
class StaggeredList extends StatelessWidget {
  /// Creates a staggered list
  const StaggeredList({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 1000),
    this.staggerDelay = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
    this.autoPlay = true,
    this.animationType = StaggeredListAnimationType.fadeSlide,
    this.slideDirection = SlideDirection.up,
    this.onComplete,
  });

  /// List of child widgets to animate
  final List<Widget> children;

  /// Total duration of the animation
  final Duration duration;

  /// Delay between each item's animation start
  final Duration staggerDelay;

  /// Animation curve
  final Curve curve;

  /// Whether to start animation automatically
  final bool autoPlay;

  /// Type of animation to apply
  final StaggeredListAnimationType animationType;

  /// Direction for slide animations
  final SlideDirection slideDirection;

  /// Callback when animation completes
  final AnimationCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    return StaggeredAnimationBuilder(
      itemCount: children.length,
      duration: duration,
      staggerDelay: staggerDelay,
      curve: curve,
      autoPlay: autoPlay,
      onComplete: onComplete,
      builder: (context, index, animation) {
        return _buildAnimatedChild(children[index], animation);
      },
    );
  }

  Widget _buildAnimatedChild(Widget child, Animation<double> animation) {
    switch (animationType) {
      case StaggeredListAnimationType.fade:
        return FadeTransition(opacity: animation, child: child);
      
      case StaggeredListAnimationType.slide:
        final offset = AnimationUtils.getSlideOffset(slideDirection, 1.0 - animation.value);
        return SlideTransition(
          position: Tween<Offset>(begin: offset, end: Offset.zero).animate(animation),
          child: child,
        );
      
      case StaggeredListAnimationType.scale:
        return ScaleTransition(scale: animation, child: child);
      
      case StaggeredListAnimationType.fadeSlide:
        final offset = AnimationUtils.getSlideOffset(slideDirection, 1.0 - animation.value);
        return SlideTransition(
          position: Tween<Offset>(begin: offset, end: Offset.zero).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
    }
  }
}

/// Types of animations available for staggered lists
enum StaggeredListAnimationType {
  /// Fade in animation
  fade,
  /// Slide animation
  slide,
  /// Scale animation
  scale,
  /// Combined fade and slide animation
  fadeSlide,
}
