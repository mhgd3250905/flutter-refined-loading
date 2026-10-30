import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 星尘归位 Stardust Assembly —— “安静的光”系列之一。
/// 二十多颗星尘一开始是散的，慢慢向中间聚成一个圆，
/// 聚满一刻，星尘又轻轻散开。等待不是转圈，是“东西正在聚拢”。
/// 散点位置用黄金角固定算出，每次循环都一样，不会乱闪。
class StardustAssembly extends StatefulWidget {
  const StardustAssembly({
    super.key,
    this.size = 120,
    this.color,
    this.duration = const Duration(milliseconds: 3800),
    this.count = 26,
  });

  final double size;
  final Color? color;
  final Duration duration;
  final int count;

  @override
  State<StardustAssembly> createState() => _StardustAssemblyState();
}

class _StardustAssemblyState extends State<StardustAssembly>
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
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _StardustPainter(
              t: _controller.value,
              color: color,
              count: widget.count,
            ),
          ),
        );
      },
    );
  }
}

class _StardustPainter extends CustomPainter {
  _StardustPainter({
    required this.t,
    required this.color,
    required this.count,
  });

  final double t;
  final Color color;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // 聚拢因子：0 -> 1 -> 0，用正弦保证两端都不硬切
    final assemble = math.sin(math.pi * t);
    // 聚满时中间的光晕
    canvas.drawCircle(
      center,
      size.width * 0.10 * assemble,
      Paint()..color = color.withOpacity(0.12 * assemble),
    );
    for (int i = 0; i < count; i++) {
      // 散点：黄金角 + 固定伪随机半径，保证每次都一样
      final golden = i * 2.399963;
      final scatterR = size.width * 0.42 * (0.45 + 0.55 * ((i * 37) % 100) / 100);
      final scatter = Offset(
        center.dx + scatterR * math.cos(golden),
        center.dy + scatterR * math.sin(golden),
      );
      // 目标：一个正圆
      final targetAngle = i / count * math.pi * 2;
      final target = Offset(
        center.dx + size.width * 0.30 * math.cos(targetAngle),
        center.dy + size.width * 0.30 * math.sin(targetAngle),
      );
      final pos = Offset(
        scatter.dx + (target.dx - scatter.dx) * assemble,
        scatter.dy + (target.dy - scatter.dy) * assemble,
      );
      final radius = 1.2 + 1.6 * assemble + ((i % 3) * 0.4);
      canvas.drawCircle(
        pos,
        radius,
        Paint()..color = color.withOpacity(0.35 + 0.55 * assemble),
      );
    }
  }

  @override
  bool shouldRepaint(_StardustPainter old) => old.t != t;
}
