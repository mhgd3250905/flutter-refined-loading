import 'package:flutter/material.dart';

/// 网格波 Grid Wave —— Precision 系列之一。
/// 5×5 的小点阵，一道波从左上斜着扫到右下，
/// 波经过的点变深、变大一点，波过去又恢复。
/// 像信号在网格里走过去，不是一堆点在乱闪。
class GridWave extends StatefulWidget {
  const GridWave({
    super.key,
    this.size = 96,
    this.color,
    this.duration = const Duration(milliseconds: 1800),
  });

  final double size;
  final Color? color;
  final Duration duration;

  @override
  State<GridWave> createState() => _GridWaveState();
}

class _GridWaveState extends State<GridWave>
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
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (col) {
                  // 波前位置：0 -> 1.4，点在 (row+col)/8 处被扫到
                  final phase = (row + col) / 8;
                  final dist =
                      (_controller.value * 1.4 - phase).abs();
                  final strength =
                      (1 - dist * 2).clamp(0.0, 1.0);
                  return Container(
                    width: 4 + 3 * strength,
                    height: 4 + 3 * strength,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.20 + 0.65 * strength),
                    ),
                  );
                }),
              );
            }),
          ),
        );
      },
    );
  }
}
