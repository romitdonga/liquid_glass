import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Data model for an individual animated circle
///
/// Contains all the properties needed to define a circle's size,
/// position, and orbital movement pattern.
class CircleData {
  /// The radius of the circle in pixels
  final double radius;

  /// The center X position as a percentage of screen width (0.0 to 1.0)
  final double centerX;

  /// The center Y position as a percentage of screen height (0.0 to 1.0)
  final double centerY;

  /// The radius of the orbital movement pattern
  final double orbitRadius;

  /// Creates a new CircleData instance
  ///
  /// All parameters are required to define the circle's behavior
  CircleData({
    required this.radius,
    required this.centerX,
    required this.centerY,
    required this.orbitRadius,
  });
}

/// Custom painter for rendering animated circles with blur effects
///
/// This painter draws multiple circles at their animated positions
/// with a blur effect to create a soft, atmospheric background.
class AnimatedCirclesPainter extends CustomPainter {
  /// List of animation objects controlling each circle's movement
  final List<Animation<double>> animations;

  /// List of circle data defining each circle's properties
  final List<CircleData> circles;

  /// Creates a new AnimatedCirclesPainter
  AnimatedCirclesPainter(this.animations, this.circles);

  @override
  void paint(Canvas canvas, Size size) {
    // Configure paint with blue color, transparency, and blur effect
    final paint = Paint()
      ..color = const Color(0xFF2083A4).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // Draw each circle at its current animated position
    for (int i = 0; i < circles.length; i++) {
      final circle = circles[i];
      final animation = animations[i];

      // Convert relative positions to screen coordinates
      final centerX = size.width * circle.centerX;
      final centerY = size.height * circle.centerY;

      // Calculate current position based on orbital animation
      final x = centerX + circle.orbitRadius * math.cos(animation.value);
      final y = centerY + circle.orbitRadius * math.sin(animation.value);

      canvas.drawCircle(
        Offset(x, y),
        circle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// A widget that provides an animated circular background
///
/// This widget creates multiple circles that orbit around fixed points
/// at different speeds, creating a dynamic background effect that
/// complements the glass morphism UI elements.
class CirclesBackground extends StatefulWidget {
  const CirclesBackground({super.key});

  @override
  State<CirclesBackground> createState() => _CirclesBackgroundState();
}

/// State class managing the animated circles background
class _CirclesBackgroundState extends State<CirclesBackground>
    with TickerProviderStateMixin {
  /// Animation controllers for each circle
  late List<AnimationController> _controllers;

  /// Animation objects for circular motion
  late List<Animation<double>> _animations;

  /// Circle data defining properties for each circle
  final List<CircleData> _circles = [];

  @override
  void initState() {
    super.initState();
    _initializeCircles();
  }

  /// Initializes the animated circles with varying properties
  ///
  /// Creates 8 circles with different sizes, positions, speeds,
  /// and orbital patterns to create visual depth and interest.
  void _initializeCircles() {
    _controllers = [];
    _animations = [];

    // Create 8 animated circles with different properties
    for (int i = 0; i < 8; i++) {
      // Create animation controller with staggered durations (5-40 seconds)
      final controller = AnimationController(
        duration: Duration(seconds: 5 + i * 5),
        vsync: this,
      );

      // Create circular animation (0 to 2π radians)
      final animation = Tween<double>(
        begin: 0,
        end: 2 * math.pi,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ));

      _controllers.add(controller);
      _animations.add(animation);

      // Create circle with progressive sizing and positioning
      _circles.add(CircleData(
        radius: 40.0 + (i * 20), // Sizes from 40 to 180 pixels
        centerX: 0.2 + (i * 0.15), // Spread across screen width
        centerY: 0.3 + (i * 0.1), // Varied vertical positions
        orbitRadius: 50.0 + (i * 30), // Orbital radius from 50 to 260 pixels
      ));

      // Start the animation (infinite loop)
      controller.repeat();
    }
  }

  @override
  void dispose() {
    // Clean up animation controllers to prevent memory leaks
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(_animations),
      builder: (context, child) {
        return CustomPaint(
          painter: AnimatedCirclesPainter(_animations, _circles),
          size: Size.infinite,
        );
      },
    );
  }
}
