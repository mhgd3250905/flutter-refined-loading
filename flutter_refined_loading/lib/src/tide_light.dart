import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 潮汐光 Tide Light —— “安静的光”系列之一。
/// 不是转圈，不是闪烁：两层潮水以极慢的速度一前一后涌动，
/// 光在水面下，不是水面上。等的是潮水，不是进度条。
/// 适合：长等待、夜晚模式、需要让人静下来的页面。
class TideLight extends StatefulWidget {
  const TideLight({
    super.key,
    this.size = 120,
    this.color,
    this.duration = const Duration(milliseconds: 4200),
  });

  final double size;
  final Color? color;
  final Duration duration;

  @override
  State<TideLight> createState() => _TideLightState();
}

class _TideLightState extends State<TideLight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _TidePainter(
                t: _controller.value,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TidePainter extends CustomPainter {
  _TidePainter({required this.t, required this.color});

  final double t;
  final Color color;

  Path _wave(Size size, double phase, double baseY, double amp) {
    final path = Path();
    path.moveTo(0, baseY);
    for (double x = 0; x <= size.width; x += 2) {
      final y = baseY +
          math.sin(x / size.width * math.pi * 2 + phase) * amp +
          math.sin(x / size.width * math.pi * 4 + phase * 1.7) * amp * 0.35;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 水面下的光：一个柔和的圆晕，先画在最底层
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [color.withOpacity(0.45), color.withOpacity(0)],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height * 0.62),
          radius: size.width * 0.5,
        ),
      );
    canvas.drawRect(Offset.zero & size, glow);

    // 后层潮水：慢、淡、幅度小
    canvas.drawPath(
      _wave(size, t * math.pi * 2, size.height * 0.52, size.height * 0.05),
      Paint()..color = color.withOpacity(0.18),
    );
    // 前层潮水：稍快一点、稍浓一点，错开半个周期
    canvas.drawPath(
      _wave(
        size,
        t * math.pi * 2 + math.pi,
        size.height * 0.60,
        size.height * 0.07,
      ),
      Paint()..color = color.withOpacity(0.38),
    );
    // 水面上一颗不动的光点：潮水动，它不动，画面才有定心
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.38),
      size.width * 0.045,
      Paint()..color = color.withOpacity(0.9),
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.38),
      size.width * 0.09,
      Paint()..color = color.withOpacity(0.15),
    );
  }

  @override
  bool shouldRepaint(_TidePainter old) => old.t != t;
}
