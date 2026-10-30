import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 一线生机 Sprout Line —— “安静的光”系列之一。
/// 只有一根线：从地面长出来，先是一根茎，到顶端才展开一片叶，
/// 然后整株在原地静止一会儿、淡出、再长一次。
/// 不用任何圆点圆环，生长本身就是等待的形状。
class SproutLine extends StatefulWidget {
  const SproutLine({
    super.key,
    this.size = 120,
    this.color,
    this.duration = const Duration(milliseconds: 3000),
  });

  final double size;
  final Color? color;
  final Duration duration;

  @override
  State<SproutLine> createState() => _SproutLineState();
}

class _SproutLineState extends State<SproutLine>
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
        // 最后 15% 淡出，避免循环时硬切
        final fade = _controller.value > 0.85
            ? (1 - _controller.value) / 0.15
            : 1.0;
        return Opacity(
          opacity: fade.clamp(0.0, 1.0),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _SproutPainter(
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

class _SproutPainter extends CustomPainter {
  _SproutPainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bottom = Offset(size.width / 2, size.height * 0.88);
    final top = Offset(size.width / 2, size.height * 0.28);
    // 地面线：一直都在，是生长的参照
    canvas.drawLine(
      Offset(size.width * 0.28, bottom.dy),
      Offset(size.width * 0.72, bottom.dy),
      Paint()
        ..color = color.withOpacity(0.25)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
    // 茎：前 55% 长出来，带一点弯，不是直尺画的
    final stemT = (t / 0.55).clamp(0.0, 1.0);
    final stemEnd = Offset(
      bottom.dx + math.sin(stemT * 0.6) * size.width * 0.06,
      bottom.dy - (bottom.dy - top.dy) * stemT,
    );
    final stemPath = Path()
      ..moveTo(bottom.dx, bottom.dy)
      ..quadraticBezierTo(
        bottom.dx + size.width * 0.08,
        (bottom.dy + stemEnd.dy) / 2,
        stemEnd.dx,
        stemEnd.dy,
      );
    // 用 pathMetric 截取生长的部分，避免整根茎突然出现
    final metric = stemPath.computeMetrics().first;
    final grown = metric.extractPath(0, metric.length * stemT);
    canvas.drawPath(
      grown,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    // 叶：55% 之后才展开，从小到大，不弹
    if (t > 0.55) {
      final leafT = ((t - 0.55) / 0.30).clamp(0.0, 1.0);
      final leafSize = size.width * 0.22 * leafT;
      canvas.save();
      canvas.translate(stemEnd.dx, stemEnd.dy);
      canvas.rotate(-0.7);
      final leafPath = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(leafSize * 0.6, -leafSize * 0.5, leafSize, 0)
        ..quadraticBezierTo(leafSize * 0.6, leafSize * 0.5, 0, 0)
        ..close();
      canvas.drawPath(
        leafPath,
        Paint()..color = color.withOpacity(0.85),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_SproutPainter old) => old.t != t;
}
