import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 渐变圆环：可不定（一直转）也可定量（传 progress 0~1）。
/// 圆环用 SweepGradient 做头亮尾淡，比系统 CircularProgressIndicator 更有质感。
class GradientRing extends StatefulWidget {
  const GradientRing({
    super.key,
    this.size = 48,
    this.strokeWidth = 4,
    this.color,
    this.secondColor,
    this.duration = const Duration(milliseconds: 1200),
    this.progress,
    this.showLabel = false,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? secondColor;

  /// 为空 = 不定量加载；0~1 = 定量进度
  final double? progress;
  final Duration duration;
  final bool showLabel;

  @override
  State<GradientRing> createState() => _GradientRingState();
}

class _GradientRingState extends State<GradientRing>
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
    final second = widget.secondColor ?? scheme.primaryContainer;
    final isDeterminate = widget.progress != null;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RingPainter(
                  color: color,
                  secondColor: second,
                  strokeWidth: widget.strokeWidth,
                  rotation: isDeterminate ? 0 : _controller.value * math.pi * 2,
                  sweep: isDeterminate
                      ? (widget.progress!.clamp(0, 1) * math.pi * 2)
                      : math.pi * 1.4,
                ),
              ),
              if (isDeterminate && widget.showLabel)
                Text(
                  '${(widget.progress!.clamp(0, 1) * 100).round()}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
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
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.width - strokeWidth) / 2;

    // 底环
    final base = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, base);

    // 渐变主弧
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: sweep,
        colors: [secondColor.withOpacity(0.1), color],
      ).createShader(rect);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + rotation,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.rotation != rotation || old.sweep != sweep || old.color != color;
}
