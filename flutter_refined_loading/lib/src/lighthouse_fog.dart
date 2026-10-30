import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 雾中灯塔 Lighthouse in Fog —— “安静的光”系列之一。
/// 雾很浓，塔很小，光束转得很慢，一圈要 8 秒。
/// 光束扫过去的地方，雾才短暂地亮一下，然后又暗回去。
/// 这是我对“等待”最直接的比喻：不是催你，是在雾里给你指方向。
class LighthouseFog extends StatefulWidget {
  const LighthouseFog({
    super.key,
    this.size = 140,
    this.color,
    this.duration = const Duration(milliseconds: 8000),
  });

  final double size;
  final Color? color;
  final Duration duration;

  @override
  State<LighthouseFog> createState() => _LighthouseFogState();
}

class _LighthouseFogState extends State<LighthouseFog>
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
              painter: _LighthousePainter(
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

class _LighthousePainter extends CustomPainter {
  _LighthousePainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.52);
    // 雾：三团毛边圆，位置固定，只亮度极轻微地呼吸
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(
          size.width * (0.28 + i * 0.22),
          size.height * (0.42 + i * 0.10),
        ),
        size.width * 0.22,
        Paint()
          ..color = color.withOpacity(0.06 + 0.02 * math.sin(t * math.pi * 2 + i))
          ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 18),
      );
    }
    // 光束：从塔顶出发的楔形，转一圈 8 秒，匀速，不加速
    final angle = t * math.pi * 2 - math.pi / 2;
    final beamLength = size.width * 0.48;
    final beam = Path()
      ..moveTo(center.dx, center.dy - size.height * 0.18)
      ..lineTo(
        center.dx + beamLength * math.cos(angle - 0.22),
        center.dy - size.height * 0.18 + beamLength * math.sin(angle - 0.22),
      )
      ..lineTo(
        center.dx + beamLength * math.cos(angle + 0.22),
        center.dy - size.height * 0.18 + beamLength * math.sin(angle + 0.22),
      )
      ..close();
    canvas.drawPath(
      beam,
      Paint()..color = color.withOpacity(0.10),
    );
    // 塔：极简，一根竖线 + 顶上的光点，塔本身不动
    canvas.drawLine(
      Offset(center.dx, center.dy - size.height * 0.18),
      Offset(center.dx, center.dy + size.height * 0.28),
      Paint()
        ..color = color.withOpacity(0.75)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy - size.height * 0.18),
      size.width * 0.035,
      Paint()..color = color,
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy - size.height * 0.18),
      size.width * 0.08,
      Paint()..color = color.withOpacity(0.18),
    );
    // 海面线
    canvas.drawLine(
      Offset(size.width * 0.20, center.dy + size.height * 0.28),
      Offset(size.width * 0.80, center.dy + size.height * 0.28),
      Paint()
        ..color = color.withOpacity(0.30)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_LighthousePainter old) => old.t != t;
}
