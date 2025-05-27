/// Animation chain controller for sequencing multiple animations
library;

import 'package:flutter/material.dart';
import '../utils/animation_types.dart';

/// A controller that manages a sequence of animations
class AnimationChain {
  /// Creates an animation chain
  AnimationChain({
    required TickerProvider vsync,
    this.onComplete,
    this.onStepComplete,
  }) : _vsync = vsync;

  final TickerProvider _vsync;
  final List<_AnimationStep> _steps = [];
  final List<AnimationController> _controllers = [];
  
  /// Callback when the entire chain completes
  final AnimationCallback? onComplete;
  
  /// Callback when each step completes
  final AnimationCallback? onStepComplete;

  int _currentStep = 0;
  bool _isPlaying = false;
  bool _disposed = false;

  /// Adds an animation step to the chain
  AnimationChain addStep({
    required Duration duration,
    Curve curve = Curves.linear,
    Duration delay = Duration.zero,
    required AnimationCallback onAnimate,
  }) {
    if (_disposed) {
      throw StateError('Cannot add steps to a disposed AnimationChain');
    }

    _steps.add(_AnimationStep(
      duration: duration,
      curve: curve,
      delay: delay,
      onAnimate: onAnimate,
    ));

    return this;
  }

  /// Adds a fade animation step
  AnimationChain addFade({
    required Duration duration,
    double from = 0.0,
    double to = 1.0,
    Curve curve = Curves.easeInOut,
    Duration delay = Duration.zero,
    required ValueChanged<double> onUpdate,
  }) {
    return addStep(
      duration: duration,
      curve: curve,
      delay: delay,
      onAnimate: () {
        final controller = AnimationController(duration: duration, vsync: _vsync);
        final animation = Tween<double>(begin: from, end: to)
            .animate(CurvedAnimation(parent: controller, curve: curve));
        
        animation.addListener(() => onUpdate(animation.value));
        _controllers.add(controller);
        controller.forward();
      },
    );
  }

  /// Adds a slide animation step
  AnimationChain addSlide({
    required Duration duration,
    required Offset from,
    required Offset to,
    Curve curve = Curves.easeInOut,
    Duration delay = Duration.zero,
    required ValueChanged<Offset> onUpdate,
  }) {
    return addStep(
      duration: duration,
      curve: curve,
      delay: delay,
      onAnimate: () {
        final controller = AnimationController(duration: duration, vsync: _vsync);
        final animation = Tween<Offset>(begin: from, end: to)
            .animate(CurvedAnimation(parent: controller, curve: curve));
        
        animation.addListener(() => onUpdate(animation.value));
        _controllers.add(controller);
        controller.forward();
      },
    );
  }

  /// Adds a scale animation step
  AnimationChain addScale({
    required Duration duration,
    double from = 0.0,
    double to = 1.0,
    Curve curve = Curves.easeInOut,
    Duration delay = Duration.zero,
    required ValueChanged<double> onUpdate,
  }) {
    return addStep(
      duration: duration,
      curve: curve,
      delay: delay,
      onAnimate: () {
        final controller = AnimationController(duration: duration, vsync: _vsync);
        final animation = Tween<double>(begin: from, end: to)
            .animate(CurvedAnimation(parent: controller, curve: curve));
        
        animation.addListener(() => onUpdate(animation.value));
        _controllers.add(controller);
        controller.forward();
      },
    );
  }

  /// Adds a delay step (pause between animations)
  AnimationChain addDelay(Duration delay) {
    return addStep(
      duration: delay,
      onAnimate: () {
        // Just wait for the duration
      },
    );
  }

  /// Plays the animation chain
  Future<void> play() async {
    if (_disposed) {
      throw StateError('Cannot play a disposed AnimationChain');
    }

    if (_isPlaying) return;

    _isPlaying = true;
    _currentStep = 0;

    try {
      for (int i = 0; i < _steps.length; i++) {
        _currentStep = i;
        final step = _steps[i];

        // Apply delay if specified
        if (step.delay > Duration.zero) {
          await Future.delayed(step.delay);
        }

        // Execute the animation
        step.onAnimate();

        // Wait for the duration
        await Future.delayed(step.duration);

        // Notify step completion
        onStepComplete?.call();
      }

      // Notify chain completion
      onComplete?.call();
    } finally {
      _isPlaying = false;
    }
  }

  /// Stops the animation chain
  void stop() {
    _isPlaying = false;
    for (final controller in _controllers) {
      controller.stop();
    }
  }

  /// Resets the animation chain to the beginning
  void reset() {
    stop();
    _currentStep = 0;
    for (final controller in _controllers) {
      controller.reset();
    }
  }

  /// Gets the current step index
  int get currentStep => _currentStep;

  /// Gets the total number of steps
  int get stepCount => _steps.length;

  /// Checks if the chain is currently playing
  bool get isPlaying => _isPlaying;

  /// Checks if the chain has completed
  bool get isCompleted => _currentStep >= _steps.length && !_isPlaying;

  /// Disposes of all resources
  void dispose() {
    if (_disposed) return;
    
    stop();
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _steps.clear();
    _disposed = true;
  }
}

/// Internal class representing a single animation step
class _AnimationStep {
  const _AnimationStep({
    required this.duration,
    required this.curve,
    required this.delay,
    required this.onAnimate,
  });

  final Duration duration;
  final Curve curve;
  final Duration delay;
  final AnimationCallback onAnimate;
}
