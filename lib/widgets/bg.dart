import 'dart:math';
import 'package:flutter/material.dart';

class StarryBackground extends StatefulWidget {
  final Widget child;
  final int starCount;
  
  const StarryBackground({
    super.key,
    required this.child,
    this.starCount = 100,
  });

  @override
  State<StarryBackground> createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeStars();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  void _initializeStars() {
    _stars.clear();
    for (int i = 0; i < widget.starCount; i++) {
      _stars.add(Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: _random.nextDouble() * 1.5 + 0.5,
        speed: _random.nextDouble() * 0.5 + 0.1,
        alpha: _random.nextInt(155) + 100,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarPainter(stars: _stars, animationValue: _controller.value),
          child: widget.child,
        );
      },
    );
  }
}

class Star {
  double x;
  double y;
  final double radius;
  final double speed;
  final int alpha;

  Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.alpha,
  });
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarPainter({
    required this.stars,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = const Color(0xFF0A0E21)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    for (final star in stars) {
      // Calculate parallax effect
      final offsetX = (star.x - 0.5) * 50 * (1 - star.speed);
      final offsetY = (star.y - 0.5) * 50 * (1 - star.speed);
      
      final x = (star.x * size.width + offsetX * animationValue) % size.width;
      final y = (star.y * size.height + offsetY * animationValue) % size.height;
      
      final starPaint = Paint()
        ..color = Colors.white.withAlpha(star.alpha)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), star.radius, starPaint);
      
      // Draw star glow
      if (star.radius > 1.2) {
        final glowPaint = Paint()
          ..color = Colors.white.withAlpha(star.alpha ~/ 3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
        
        canvas.drawCircle(Offset(x, y), star.radius * 1.5, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}