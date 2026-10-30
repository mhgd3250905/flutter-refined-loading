import 'package:flutter/material.dart';

/// 呼吸三点：最常用、最克制的等待动画。
/// 三个圆点依次放大 + 变亮，用舒缓的 easeInOut，避免生硬闪烁。
class BreathingDots extends StatefulWidget {
  const BreathingDots({
    super.key,
    this.size = 48,
    this.dotSize = 9,
    this.color,
    this.duration = const Duration(milliseconds: 1200),
    this.gap = 8,
  });

  final double size;
  final double dotSize;
  final Color? color;
  final Duration duration;
  final double gap;

  @override
  State<BreathingDots> createState() => _BreathingDotsState();
}

class _BreathingDotsState extends State<BreathingDots>
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
    return SizedBox(
      width: widget.size,
      height: widget.dotSize * 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          // 每个点错开 1/3 周期，形成依次呼吸的节奏。
          final begin = i * 0.22;
          final animation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(begin, begin + 0.56, curve: Curves.easeInOut),
            ),
          );
          return AnimatedBuilder(
            animation: animation,
            builder: (_, __) {
              // 0 -> 1 -> 0 的呼吸曲线
              final t = animation.value <= 0.5
                  ? animation.value * 2
                  : (1 - animation.value) * 2;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: widget.gap / 2),
                width: widget.dotSize,
                height: widget.dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.35 + 0.65 * t),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.25 * t),
                      blurRadius: 8 * t,
                      spreadRadius: 1 * t,
                    ),
                  ],
                ),
                transform: Matrix4.identity()..scale(0.7 + 0.3 * t),
              );
            },
          );
        }),
      ),
    );
  }
}
