import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 墨晕 Ink Bloom —— “安静的光”系列之一。
/// 一滴墨落入清水，不是扩散成圆环，而是边缘毛茸茸地晕开，
/// 晕到最大时，中间留下一个干净的、未被染到的圆。
/// 等待在这里是一次落墨，不是机器在转。
class InkBloom extends StatefulWidget {
  const InkBloom({
    super.key,
    this.size = 120,
    this.color,
    this.duration = const Duration(milliseconds: 3400),
  });

  final double size;
  final Color? color;
  final Duration duration;

  @override
  State<InkBloom> createState() => _InkBloomState();
}

class _InkBloomState extends State<InkBloom>
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
    final color = widget.color ?? scheme.onSurface;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _InkPainter(t: _controller.value, color: color),
          ),
        );
      },
    );
  }
}

class _InkPainter extends CustomPainter {
  _InkPainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.width * 0.46;
    // 三滴墨错开时间落下，每滴都在变淡、变毛
    for (int i = 0; i < 3; i++) {
      final local = ((t + i / 3) % 1.0);
      // easeOut：落下快，晕开慢
      final eased = 1 - (1 - local) * (1 - local);
      final r = maxR * eased;
      final paint = Paint()
        ..color = color.withOpacity(0.42 * (1 - local))
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 14);
      canvas.drawCircle(center, r, paint);
      // 墨滴核心：小而浓，刚落下时最清楚
      canvas.drawCircle(
        center,
        maxR * 0.12 * (1 - local) + 1,
        Paint()..color = color.withOpacity(0.55 * (1 - local)),
      );
    }
    // 最后留下的干净圆：被晕开包围、却没有被染到
    final clean = (t * 3 % 1.0);
    canvas.drawCircle(
      center,
      maxR * 0.16,
      Paint()
        ..color = color.withOpacity(0.10 + 0.08 * clean)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_InkPainter old) => old.t != t;
}
