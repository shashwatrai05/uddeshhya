import 'dart:math';
import 'package:flutter/material.dart';

class LiquidProgressIndicator extends StatefulWidget {
  final double value;
  final double maxValue;

  LiquidProgressIndicator({required this.value, required this.maxValue});

  @override
  _LiquidProgressIndicatorState createState() => _LiquidProgressIndicatorState();
}

class _LiquidProgressIndicatorState extends State<LiquidProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.maxValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: LiquidPainter(
              _animation.value,
              widget.maxValue,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class LiquidPainter extends CustomPainter {
  final double value;
  final double maxValue;

  LiquidPainter(this.value, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    double diameter = min(size.height, size.width);
    double radius = diameter / 2;

    double pointX = 0;
    double pointY = diameter - ((diameter + 10) * (value / maxValue));

    Path path = Path();
    path.moveTo(pointX, pointY);

    double amplitude = 10;
    double period = value / maxValue;
    double phaseShift = value * pi;

    for (double i = 0; i <= diameter; i++) {
      path.lineTo(
        i + pointX,
        pointY + amplitude * sin((i * 2 * period * pi / diameter) + phaseShift),
      );
    }

    path.lineTo(pointX + diameter, diameter);
    path.lineTo(pointX, diameter);
    path.close();

    Paint paint = Paint()
      ..shader = const SweepGradient(
        colors: [
          Color(0xffFF7A01),
          Color(0xffFF0069),
          Color(0xff7639FB),
        ],
        startAngle: pi / 2,
        endAngle: 5 * pi / 2,
        tileMode: TileMode.clamp,
        stops: [
          0.25,
          0.35,
          0.5,
        ],
      ).createShader(Rect.fromCircle(center: Offset(diameter, diameter), radius: radius))
      ..style = PaintingStyle.fill;

    Path circleClip = Path()
      ..addOval(Rect.fromCenter(center: Offset(radius, radius), width: diameter, height: diameter));
    canvas.clipPath(circleClip, doAntiAlias: true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
