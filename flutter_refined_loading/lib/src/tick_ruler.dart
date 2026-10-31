import 'package:flutter/material.dart';

/// 刻度尺 Tick Ruler —— Precision 系列之一。
/// 一排细刻度，从左到右依次亮起，像尺子在量东西，
/// 亮过的刻度不熄灭，只是变淡，整排亮完才一起重置。
/// 没有弹跳，没有渐变彩虹，只有刻度在走。
class TickRuler extends StatefulWidget {
  const TickRuler({
    super.key,
    this.width = 160,
    this.color,
    this.duration = const Duration(milliseconds: 1600),
    this.tickCount = 16,
  });

  final double width;
  final Color? color;
  final Duration duration;
  final int tickCount;

  @override
  State<TickRuler> createState() => _TickRulerState();
}

class _TickRulerState extends State<TickRuler>
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
        final active = (_controller.value * widget.tickCount).floor();
        return SizedBox(
          width: widget.width,
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(widget.tickCount, (i) {
              final isLong = i % 4 == 0;
              final isActive = i == active;
              final isPast = i < active;
              return Container(
                width: 1.5,
                height: isLong ? 20 : 12,
                color: isActive
                    ? color
                    : isPast
                        ? color.withOpacity(0.45)
                        : color.withOpacity(0.15),
              );
            }),
          ),
        );
      },
    );
  }
}
