import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 流动 blob：一个有机变形的色块，边缘随时间起伏。
/// 适合 AI 生成中、图片处理中、品牌感强的全屏等待背景。
class MorphBlob extends StatefulWidget {
  const MorphBlob({
    super.key,
    this.size = 96,
    this.color,
    this.secondColor,
    this.duration = const Duration(milliseconds: 2600),
    this.child,
  });

  final double size;
  final Color? color;
  final Color? secondColor;
  final Duration duration;
  final Widget? child;

  @override
  State<MorphBlob> createState() => _MorphBlobState();
}

class _MorphBlobState extends State<MorphBlob>
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
                painter: _BlobPainter(
                  t: _controller.value,
                  color: color,
                  secondColor: second,
                ),
              ),
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({
    required this.t,
    required this.color,
    required this.secondColor,
  });

  final double t;
  final Color color;
  final Color secondColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 * 0.82;
    final path = Path();
    const points = 64;
    for (int i = 0; i <= points; i++) {
      final angle = i / points * math.pi * 2;
      // 两层正弦叠加出有机起伏，幅度控制在 12% 以内，不至于失真
      final r = baseRadius *
          (1 +
              0.08 * math.sin(angle * 3 + t * math.pi * 2) +
              0.04 * math.sin(angle * 5 - t * math.pi * 2));
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color, secondColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.t != t;
}
