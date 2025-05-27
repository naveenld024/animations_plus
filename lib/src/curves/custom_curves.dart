/// Custom animation curves for enhanced animation effects
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Collection of custom animation curves
class CustomCurves {
  CustomCurves._(); // Private constructor

  /// A smooth bounce curve that's more subtle than the default bounce
  static const Curve smoothBounce = _SmoothBounceCurve();

  /// An elastic curve that provides a spring-like effect
  static const Curve elastic = _ElasticCurve();

  /// A curve that provides a gentle overshoot effect
  static const Curve gentleOvershoot = _OvershootCurve(tension: 1.5);

  /// A curve that provides a strong overshoot effect
  static const Curve strongOvershoot = _OvershootCurve(tension: 3.0);

  /// A curve that anticipates the animation (moves backward first)
  static const Curve anticipate = _AnticipateeCurve();

  /// A curve that combines anticipation with overshoot
  static const Curve anticipateOvershoot = _AnticipateOvershootCurve();

  /// A curve that provides a smooth deceleration
  static const Curve smoothDecelerate = _SmoothDecelerateCurve();

  /// A curve that provides a smooth acceleration
  static const Curve smoothAccelerate = _SmoothAccelerateCurve();

  /// A curve that creates a wobble effect
  static const Curve wobble = _WobbleCurve();

  /// A curve that creates a rubber band effect
  static const Curve rubberBand = _RubberBandCurve();
}

/// Smooth bounce curve implementation
class _SmoothBounceCurve extends Curve {
  const _SmoothBounceCurve();

  @override
  double transform(double t) {
    if (t < 0.5) {
      return 2 * t * t;
    } else {
      return -1 + (4 - 2 * t) * t;
    }
  }
}

/// Elastic curve implementation
class _ElasticCurve extends Curve {
  const _ElasticCurve();

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) return t;

    const period = 0.3;
    final s = period / 4.0;
    t = t - 1.0;

    return math.pow(2.0, -10.0 * t) *
           math.sin((t - s) * (2.0 * math.pi) / period) + 1.0;
  }
}

/// Overshoot curve implementation
class _OvershootCurve extends Curve {
  const _OvershootCurve({this.tension = 2.0});

  final double tension;

  @override
  double transform(double t) {
    t -= 1.0;
    return t * t * ((tension + 1.0) * t + tension) + 1.0;
  }
}

/// Anticipate curve implementation
class _AnticipateeCurve extends Curve {
  const _AnticipateeCurve();

  @override
  double transform(double t) {
    const tension = 2.0;
    return t * t * ((tension + 1.0) * t - tension);
  }
}

/// Anticipate overshoot curve implementation
class _AnticipateOvershootCurve extends Curve {
  const _AnticipateOvershootCurve();

  @override
  double transform(double t) {
    const tension = 2.0;
    if (t < 0.5) {
      return 0.5 * _anticipate(t * 2.0, tension);
    } else {
      return 0.5 * (_overshoot(t * 2.0 - 2.0, tension) + 2.0);
    }
  }

  double _anticipate(double t, double tension) {
    return t * t * ((tension + 1.0) * t - tension);
  }

  double _overshoot(double t, double tension) {
    return t * t * ((tension + 1.0) * t + tension);
  }
}

/// Smooth decelerate curve implementation
class _SmoothDecelerateCurve extends Curve {
  const _SmoothDecelerateCurve();

  @override
  double transform(double t) {
    return 1.0 - math.pow(1.0 - t, 3.0);
  }
}

/// Smooth accelerate curve implementation
class _SmoothAccelerateCurve extends Curve {
  const _SmoothAccelerateCurve();

  @override
  double transform(double t) {
    return math.pow(t, 3.0).toDouble();
  }
}

/// Wobble curve implementation
class _WobbleCurve extends Curve {
  const _WobbleCurve();

  @override
  double transform(double t) {
    const frequency = 3.0;
    return t * (1.0 + 0.3 * math.sin(frequency * 2.0 * math.pi * t));
  }
}

/// Rubber band curve implementation
class _RubberBandCurve extends Curve {
  const _RubberBandCurve();

  @override
  double transform(double t) {
    if (t == 0.0) return 0.0;
    if (t == 1.0) return 1.0;

    final period = 0.3;
    final s = period / 4.0;

    if (t < 1.0) {
      return -(math.pow(2.0, 10.0 * (t - 1.0)) *
               math.sin((t - 1.0 - s) * (2.0 * math.pi) / period));
    }

    return math.pow(2.0, -10.0 * (t - 1.0)) *
           math.sin((t - 1.0 - s) * (2.0 * math.pi) / period) + 1.0;
  }
}
