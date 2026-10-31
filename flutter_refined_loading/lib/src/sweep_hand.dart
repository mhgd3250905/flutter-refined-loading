import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 扫针 Sweep Hand —— Precision 系列之一。
/// 像手表的秒针：一条细线，一圈 1.2 秒，匀速，
/// 身后拖着一段极淡的尾迹，前面没有圆头、没有光晕。
/// 精密感来自匀速和细线，不是来自发光。
class SweepHand extends StatefulWidget {
  const SweepHand({
    super.key,
    this.size = 96,
    this.color,
    this.duration = const Duration(milliseconds: 1200),
  });

  final double size;
  final Color? color;
  final Duration duration;

  @override
  State<SweepHand> createState() => _SweepHandState();
}

class _SweepHandState extends State<SweepHand>
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
    final color = widget.color ?? Theme.of(context).colorScheme.onSurface;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _SweepPainter(
              t: _controller.value,
              color: color.withOpacity(0.85),
            ),
          ),
        );
      },
    );
  }
}

class _SweepPainter extends CustomPainter {
  _SweepPainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    // 刻度盘：极淡的圆 + 12 个小刻度
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    for (int i = 0; i < 12; i++) {
      final a = i / 12 * math.pi * 2;
      canvas.drawLine(
        Offset(
          center.dx + (radius - 4) * math.cos(a),
          center.dy + (radius - 4) * math.sin(a),
        ),
        Offset(
          center.dx + radius * math.cos(a),
          center.dy + radius * math.sin(a),
        ),
        Paint()
          ..color = color.withOpacity(0.30)
          ..strokeWidth = 1,
      );
    }
    // 尾迹：针身后 70 度的一段淡弧
    final angle = t * math.pi * 2 - math.pi / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.82),
      angle - 1.2,
      1.2,
      false,
      Paint()
        ..color = color.withOpacity(0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
    // 针：一条 1.5px 的线，匀速
    final tip = Offset(
      center.dx + radius * 0.82 * math.cos(angle),
      center.dy + radius * 0.82 * math.sin(angle),
    );
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SweepPainter old) => old.t != t;
}
