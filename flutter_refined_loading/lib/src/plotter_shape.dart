import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 绘图仪 Plotter —— Precision 系列之一。
/// 一支笔，沿着一个六边形的边，一笔一笔地画出来，
/// 画完一圈，笔抬起来，线淡出，再画下一圈。
/// 没有圆点、没有圆环、没有闪烁，只有线在走。
/// 精密感来自：线只有 1.5px 粗，角是直的，速度是匀的。
class PlotterShape extends StatefulWidget {
  const PlotterShape({
    super.key,
    this.size = 96,
    this.color,
    this.duration = const Duration(milliseconds: 2400),
  });

  final double size;
  final Color? color;
  final Duration duration;

  @override
  State<PlotterShape> createState() => _PlotterShapeState();
}

class _PlotterShapeState extends State<PlotterShape>
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
        final fade = _controller.value > 0.88
            ? (1 - _controller.value) / 0.12
            : 1.0;
        return Opacity(
          opacity: fade.clamp(0.0, 1.0),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _PlotterPainter(
                t: _controller.value,
                color: color.withOpacity(0.85),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PlotterPainter extends CustomPainter {
  _PlotterPainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;
    // 六边形，顶角朝上
    final points = List.generate(6, (i) {
      final a = -math.pi / 2 + i * math.pi / 3;
      return Offset(
        center.dx + radius * math.cos(a),
        center.dy + radius * math.sin(a),
      );
    });
    final full = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i <= 6; i++) {
      final p = points[i % 6];
      full.lineTo(p.dx, p.dy);
    }
    // 已画好的轨迹：极淡的底线，告诉眼睛这条线要去哪
    canvas.drawPath(
      full,
      Paint()
        ..color = color.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // 正在画的部分：按路径长度截取，匀速，不加速不减速
    final metric = full.computeMetrics().first;
    final drawn = metric.extractPath(0, metric.length * t.clamp(0.0, 1.0));
    canvas.drawPath(
      drawn,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    // 笔尖：一个小圆点，始终在线的最前端
    final tangent = metric.getTangentForOffset(metric.length * t);
    if (tangent != null) {
      canvas.drawCircle(
        tangent.position,
        3,
        Paint()..color = color,
      );
    }
    // 画布四个角的微小刻度，精密仪器的味道就来自这些不抢眼的细节
    final paint = Paint()
      ..color = color.withOpacity(0.35)
      ..strokeWidth = 1;
    const tick = 6.0;
    canvas.drawLine(const Offset(0, 0), const Offset(tick, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, tick), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - tick, 0), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, tick), paint);
  }

  @override
  bool shouldRepaint(_PlotterPainter old) => old.t != t;
}
