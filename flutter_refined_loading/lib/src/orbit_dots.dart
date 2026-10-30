import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 轨道三点：三个点沿圆轨道追逐，带拖尾渐隐。
/// 适合“正在连接 / 正在同步”这种需要一点动感、又不吵的场景。
class OrbitDots extends StatefulWidget {
  const OrbitDots({
    super.key,
    this.size = 56,
    this.dotSize = 10,
    this.color,
    this.duration = const Duration(milliseconds: 1400),
  });

  final double size;
  final double dotSize;
  final Color? color;
  final Duration duration;

  @override
  State<OrbitDots> createState() => _OrbitDotsState();
}

class _OrbitDotsState extends State<OrbitDots>
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
        final radius = (widget.size - widget.dotSize) / 2;
        final center = widget.size / 2;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              // 淡淡的轨道底环，定住画面重心
              Center(
                child: Container(
                  width: widget.size - widget.dotSize,
                  height: widget.size - widget.dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                ),
              ),
              for (int i = 0; i < 3; i++)
                Positioned(
                  left: center +
                      radius *
                          math.cos(
                            _controller.value * math.pi * 2 -
                                i * math.pi * 2 / 3,
                          ) -
                      widget.dotSize / 2,
                  top: center +
                      radius *
                          math.sin(
                            _controller.value * math.pi * 2 -
                                i * math.pi * 2 / 3,
                          ) -
                      widget.dotSize / 2,
                  child: Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(i == 0 ? 1 : 0.45),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
