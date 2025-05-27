import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animations_plus/animations_plus.dart';

void main() {
  group('Animation Types', () {
    test('SlideDirection enum has correct values', () {
      expect(SlideDirection.values.length, 4);
      expect(SlideDirection.values, contains(SlideDirection.left));
      expect(SlideDirection.values, contains(SlideDirection.right));
      expect(SlideDirection.values, contains(SlideDirection.up));
      expect(SlideDirection.values, contains(SlideDirection.down));
    });

    test('RotationDirection enum has correct values', () {
      expect(RotationDirection.values.length, 2);
      expect(RotationDirection.values, contains(RotationDirection.clockwise));
      expect(RotationDirection.values, contains(RotationDirection.counterClockwise));
    });

    test('AnimationConfig has correct defaults', () {
      const config = AnimationConfig();
      expect(config.duration, const Duration(milliseconds: 300));
      expect(config.curve, Curves.easeInOut);
      expect(config.delay, Duration.zero);
      expect(config.autoPlay, true);
      expect(config.autoReverse, false);
      expect(config.repeat, false);
      expect(config.repeatCount, null);
    });

    test('AnimationConfig copyWith works correctly', () {
      const config = AnimationConfig();
      final newConfig = config.copyWith(
        duration: const Duration(milliseconds: 500),
        autoPlay: false,
      );

      expect(newConfig.duration, const Duration(milliseconds: 500));
      expect(newConfig.autoPlay, false);
      expect(newConfig.curve, Curves.easeInOut); // unchanged
    });
  });

  group('Animation Utils', () {
    test('getSlideOffset returns correct offsets', () {
      expect(
        AnimationUtils.getSlideOffset(SlideDirection.left, 1.0),
        const Offset(-1.0, 0.0),
      );
      expect(
        AnimationUtils.getSlideOffset(SlideDirection.right, 1.0),
        const Offset(1.0, 0.0),
      );
      expect(
        AnimationUtils.getSlideOffset(SlideDirection.up, 1.0),
        const Offset(0.0, -1.0),
      );
      expect(
        AnimationUtils.getSlideOffset(SlideDirection.down, 1.0),
        const Offset(0.0, 1.0),
      );
    });

    test('getRotationValue returns correct values', () {
      expect(
        AnimationUtils.getRotationValue(RotationDirection.clockwise, 1.0),
        1.0,
      );
      expect(
        AnimationUtils.getRotationValue(RotationDirection.counterClockwise, 1.0),
        -1.0,
      );
    });

    test('statusToState converts correctly', () {
      expect(
        AnimationUtils.statusToState(AnimationStatus.dismissed),
        AnimationState.dismissed,
      );
      expect(
        AnimationUtils.statusToState(AnimationStatus.forward),
        AnimationState.forward,
      );
      expect(
        AnimationUtils.statusToState(AnimationStatus.reverse),
        AnimationState.reverse,
      );
      expect(
        AnimationUtils.statusToState(AnimationStatus.completed),
        AnimationState.completed,
      );
    });

    test('calculateSlideDuration works within bounds', () {
      final duration = AnimationUtils.calculateSlideDuration(distance: 500.0);
      expect(duration.inMilliseconds, greaterThanOrEqualTo(200));
      expect(duration.inMilliseconds, lessThanOrEqualTo(800));
    });
  });

  group('Custom Curves', () {
    test('CustomCurves are defined', () {
      expect(CustomCurves.smoothBounce, isA<Curve>());
      expect(CustomCurves.elastic, isA<Curve>());
      expect(CustomCurves.gentleOvershoot, isA<Curve>());
      expect(CustomCurves.strongOvershoot, isA<Curve>());
      expect(CustomCurves.anticipate, isA<Curve>());
      expect(CustomCurves.anticipateOvershoot, isA<Curve>());
      expect(CustomCurves.smoothDecelerate, isA<Curve>());
      expect(CustomCurves.smoothAccelerate, isA<Curve>());
      expect(CustomCurves.wobble, isA<Curve>());
      expect(CustomCurves.rubberBand, isA<Curve>());
    });

    test('Custom curves transform values correctly', () {
      // Test that curves return values between 0 and 1 for input 0 and 1
      expect(CustomCurves.smoothBounce.transform(0.0), 0.0);
      expect(CustomCurves.smoothBounce.transform(1.0), 1.0);

      expect(CustomCurves.elastic.transform(0.0), 0.0);
      expect(CustomCurves.elastic.transform(1.0), 1.0);
    });
  });
}
