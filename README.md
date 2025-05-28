# Animations Plus 🎬

A comprehensive Flutter animation package that provides pre-built animation widgets and utilities for creating smooth, performant animations with minimal boilerplate code.

[![pub package](https://img.shields.io/pub/v/animations_plus.svg)](https://pub.dev/packages/animations_plus)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🎥 Demo

<div align="center">
  <img src="assets/demo.gif" alt="Animations Plus Demo" width="400" style="max-width: 100%; height: auto;">
  <br>
  <em>If the GIF doesn't load, you can <a href="assets/demo.gif">view it directly here</a></em>
</div>

*Showcase of fade, slide, scale, rotation, bounce, shimmer, and staggered animations*

## ✨ Features

- **Pre-built Animation Widgets**: Fade, slide, scale, rotation, bounce, and shimmer animations
- **Animation Utilities**: Chain multiple animations, create staggered effects, and control timing
- **Custom Easing Curves**: Enhanced curves for more natural animation effects
- **Simple API**: Minimal boilerplate with intuitive, declarative syntax
- **Performance Optimized**: Designed for smooth 60fps animations
- **Highly Customizable**: Extensive configuration options for fine-tuning
- **Type Safe**: Full Dart type safety with comprehensive documentation

## 🚀 Getting Started

### Installation

Add `animations_plus` to your `pubspec.yaml`:

```yaml
dependencies:
  animations_plus: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### Basic Usage

Import the package:

```dart
import 'package:animations_plus/animations_plus.dart';
```

## 📖 Animation Widgets

### Fade Animation

Create smooth opacity transitions:

```dart
// Simple fade in
FadeAnimationPresets.quickFadeIn(
  Text('Hello World'),
)

// Custom fade animation
SimpleFadeAnimation(
  duration: Duration(milliseconds: 800),
  curve: Curves.easeInOut,
  delay: Duration(milliseconds: 200),
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
)

// Advanced fade animation with callbacks
FadeAnimation(
  config: AnimationConfig(
    duration: Duration(milliseconds: 600),
    curve: Curves.easeOut,
    autoReverse: true,
    repeat: true,
    repeatCount: 3,
  ),
  onComplete: () => print('Animation completed!'),
  onStatusChanged: (state) => print('Animation state: $state'),
  child: YourWidget(),
)
```

### Slide Animation

Animate widgets sliding in from different directions:

```dart
// Slide in from left
SlideAnimationPresets.slideInLeft(
  Card(child: Text('Sliding from left')),
)

// Slide in from any direction
SimpleSlideAnimation(
  direction: SlideDirection.up,
  duration: Duration(milliseconds: 500),
  curve: Curves.elasticOut,
  distance: 1.0, // 1.0 = full widget width/height
  child: YourWidget(),
)

// Slide with bounce effect
SlideAnimationPresets.slideInWithBounce(
  YourWidget(),
  SlideDirection.down,
)
```

### Scale Animation

Create zoom and scaling effects:

```dart
// Scale in from zero
ScaleAnimationPresets.scaleIn(
  Icon(Icons.star, size: 48),
)

// Pop in with elastic effect
ScaleAnimationPresets.popIn(
  Button(text: 'Click me!'),
)

// Interactive tap-to-scale
TapToScale(
  onTap: () => print('Tapped!'),
  scaleDown: 0.95,
  child: YourButton(),
)

// Continuous pulse effect
ScaleAnimationPresets.pulse(
  YourWidget(),
  scale: 1.1,
)
```

### Rotation Animation

Add spinning and rotation effects:

```dart
// Spin clockwise
RotationAnimationPresets.spinClockwise(
  Icon(Icons.refresh),
)

// Continuous loading spinner
RotationAnimationPresets.loadingSpinner(
  CircularProgressIndicator(),
)

// Wobble effect
RotationAnimationPresets.wobble(
  YourWidget(),
)

// Interactive tap-to-rotate
TapToRotate(
  turns: 0.25, // Quarter turn per tap
  onTap: () => print('Rotated!'),
  child: YourWidget(),
)
```

### Bounce Animation

Create elastic and bouncy effects:

```dart
// Quick bounce in
BounceAnimationPresets.quickBounceIn(
  Card(child: Text('Bouncing!')),
)

// Elastic bounce
BounceAnimationPresets.elasticBounceIn(
  YourWidget(),
)

// Rubber band effect
BounceAnimationPresets.rubberBand(
  YourWidget(),
)

// Interactive tap-to-bounce
TapToBounce(
  bounceType: BounceType.spring,
  intensity: 1.2,
  onTap: () => print('Bounced!'),
  child: YourWidget(),
)
```

### Shimmer Animation

Create loading and highlight effects:

```dart
// Loading text placeholder
ShimmerAnimationPresets.loadingText(
  width: 200,
  height: 20,
)

// Loading avatar
ShimmerAnimationPresets.loadingAvatar(
  radius: 30,
)

// Loading card
ShimmerAnimationPresets.loadingCard(
  width: double.infinity,
  height: 100,
)

// Custom shimmer
SimpleShimmerAnimation(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  direction: ShimmerDirection.leftToRight,
  child: YourWidget(),
)

// Skeleton loader
SkeletonLoader(
  isLoading: isLoading,
  child: YourActualContent(),
)
```

## 🔗 Animation Utilities

### Staggered Animations

Create sequential animations with delays:

```dart
// Staggered list
StaggeredList(
  staggerDelay: Duration(milliseconds: 100),
  animationType: StaggeredListAnimationType.fadeSlide,
  children: [
    Card(child: Text('Item 1')),
    Card(child: Text('Item 2')),
    Card(child: Text('Item 3')),
  ],
)

// Custom staggered animation
StaggeredAnimationBuilder(
  itemCount: 5,
  duration: Duration(milliseconds: 1000),
  staggerDelay: Duration(milliseconds: 150),
  builder: (context, index, animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: YourWidget(index),
      ),
    );
  },
)
```

### Animation Chains

Sequence multiple animations:

```dart
final animationChain = AnimationChain(vsync: this)
  ..addFade(
    duration: Duration(milliseconds: 300),
    from: 0.0,
    to: 1.0,
    onUpdate: (value) => setState(() => opacity = value),
  )
  ..addDelay(Duration(milliseconds: 200))
  ..addSlide(
    duration: Duration(milliseconds: 400),
    from: Offset(1, 0),
    to: Offset.zero,
    onUpdate: (offset) => setState(() => position = offset),
  )
  ..addScale(
    duration: Duration(milliseconds: 300),
    from: 1.0,
    to: 1.2,
    onUpdate: (scale) => setState(() => this.scale = scale),
  );

// Play the chain
await animationChain.play();
```

### Custom Curves

Use enhanced easing curves for more natural animations:

```dart
// Use custom curves
SimpleFadeAnimation(
  curve: CustomCurves.smoothBounce,
  child: YourWidget(),
)

// Available custom curves
CustomCurves.smoothBounce
CustomCurves.elastic
CustomCurves.gentleOvershoot
CustomCurves.strongOvershoot
CustomCurves.anticipate
CustomCurves.anticipateOvershoot
CustomCurves.smoothDecelerate
CustomCurves.smoothAccelerate
CustomCurves.wobble
CustomCurves.rubberBand
```

### Animation Controller Extensions

Enhanced functionality for AnimationController:

```dart
// In your StatefulWidget with TickerProviderStateMixin
late AnimationController controller;

@override
void initState() {
  super.initState();
  controller = AnimationController(
    duration: Duration(milliseconds: 500),
    vsync: this,
  );
}

// Use extensions
await controller.playForward(delay: Duration(milliseconds: 200));
await controller.playForwardThenReverse();
await controller.bounce(intensity: 0.3);
await controller.shake(shakeCount: 3);
await controller.pulse(scale: 1.2);

// Check animation state
if (controller.isAnimating) {
  print('Animation is running');
}

// Create animations easily
final fadeAnimation = controller.tween(0.0, 1.0);
final colorAnimation = controller.colorTween(Colors.red, Colors.blue);
final offsetAnimation = controller.offsetTween(Offset.zero, Offset(1, 0));
```

## ⚙️ Configuration

### AnimationConfig

Centralized configuration for all animations:

```dart
const config = AnimationConfig(
  duration: Duration(milliseconds: 800),
  curve: Curves.elasticOut,
  delay: Duration(milliseconds: 100),
  autoPlay: true,
  autoReverse: false,
  repeat: true,
  repeatCount: 3,
);

// Use with any animation widget
FadeAnimation(
  config: config,
  child: YourWidget(),
)
```

### Animation Triggers

Control when animations start:

```dart
FadeAnimation(
  trigger: AnimationTrigger.automatic, // Start immediately
  // trigger: AnimationTrigger.onVisible, // Start when visible
  // trigger: AnimationTrigger.manual, // Start manually
  child: YourWidget(),
)
```

## 🎯 Performance Tips

1. **Use `const` constructors** when possible to avoid unnecessary rebuilds
2. **Dispose controllers** properly to prevent memory leaks
3. **Use `RepaintBoundary`** for complex animations to isolate repaints
4. **Prefer `Transform` widgets** over changing widget properties for better performance
5. **Use `AnimatedBuilder`** for custom animations to minimize rebuilds

```dart
// Good: Using const constructor
const FadeAnimationPresets.quickFadeIn(
  Text('Hello'), // const widget
)

// Good: Proper disposal
@override
void dispose() {
  animationController.dispose();
  super.dispose();
}

// Good: Using RepaintBoundary
RepaintBoundary(
  child: ComplexAnimatedWidget(),
)
```

## 📱 Example App

Check out the comprehensive example app in the `/example` folder that demonstrates all animation widgets and utilities. Run it with:

```bash
cd example
flutter run
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by popular animation libraries from other frameworks
- Built with Flutter's powerful animation system
- Thanks to the Flutter community for feedback and suggestions


