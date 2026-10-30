import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 精致圆环 v2：比 v1 多三处细节 ——
/// 1) 弧尾带一个发光圆头，像光点在跑；
/// 2) 内圈一层极淡的柔光底；
/// 3) 弧用双色渐变，不是单色平涂。
class PremiumRing extends StatefulWidget {
  const PremiumRing({
    super.key,
    this.size = 64,
    this.strokeWidth = 5,
    this.color,
    this.secondColor,
    this.duration = const Duration(milliseconds: 1400),
    this.progress,
    this.showLabel = false,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? secondColor;
  final Duration duration;

  /// 为空 = 不定量；0~1 = 定量
  final double? progress;
  final bool showLabel;

  @override
  State<PremiumRing> createState() => _PremiumRingState();
}

class _PremiumRingState extends State<PremiumRing>
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
    final scheme = Theme.of(context).colorScheme;
    final color = widget.color ?? scheme.primary;
    final second = widget.secondColor ?? scheme.tertiary;
    final determinate = widget.progress != null;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final rotation = determinate ? 0.0 : _controller.value * math.pi * 2;
        final sweep = determinate
            ? widget.progress!.clamp(0, 1) * math.pi * 2
            : math.pi * 1.35;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _PremiumRingPainter(
                  color: color,
                  secondColor: second,
                  strokeWidth: widget.strokeWidth,
                  rotation: rotation,
                  sweep: sweep,
                ),
              ),
              if (determinate && widget.showLabel)
                Text(
                  '${(widget.progress!.clamp(0, 1) * 100).round()}%',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PremiumRingPainter extends CustomPainter {
  _PremiumRingPainter({
    required this.color,
    required this.secondColor,
    required this.strokeWidth,
    required this.rotation,
    required this.sweep,
  });

  final Color color;
  final Color secondColor;
  final double strokeWidth;
  final double rotation;
  final double sweep;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 内圈柔光
    canvas.drawCircle(
      center,
      radius * 0.78,
      Paint()..color = color.withOpacity(0.08),
    );
    // 底环
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
    // 双色渐变主弧
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [secondColor, color],
        startAngle: 0,
        endAngle: sweep,
      ).createShader(rect);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + rotation,
      sweep,
      false,
      paint,
    );
    // 弧尾发光圆头
    final headAngle = -math.pi / 2 + rotation + sweep;
    final head = Offset(
      center.dx + radius * math.cos(headAngle),
      center.dy + radius * math.sin(headAngle),
    );
    canvas.drawCircle(
      head,
      strokeWidth * 1.05,
      Paint()..color = color.withOpacity(0.28),
    );
    canvas.drawCircle(head, strokeWidth * 0.62, Paint()..color = color);
    canvas.drawCircle(
      head,
      strokeWidth * 0.28,
      Paint()..color = Colors.white.withOpacity(0.9),
    );
  }

  @override
  bool shouldRepaint(_PremiumRingPainter old) =>
      old.rotation != rotation || old.sweep != sweep;
}
