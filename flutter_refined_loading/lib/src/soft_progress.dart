import 'package:flutter/material.dart';

/// 柔光进度条：只有 4px 粗，渐变 + 尾端光点在跑。
/// 定量传 progress，不定量就一段光自己滑过去，适合顶部加载、上传、AI 生成进度。
class SoftProgress extends StatefulWidget {
  const SoftProgress({
    super.key,
    this.width = 220,
    this.height = 4,
    this.color,
    this.secondColor,
    this.duration = const Duration(milliseconds: 1500),
    this.progress,
  });

  final double width;
  final double height;
  final Color? color;
  final Color? secondColor;
  final Duration duration;

  /// 为空 = 不定量；0~1 = 定量
  final double? progress;

  @override
  State<SoftProgress> createState() => _SoftProgressState();
}

class _SoftProgressState extends State<SoftProgress>
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
    final determinate = widget.progress != null;
    return SizedBox(
      width: widget.width,
      height: widget.height + 8,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final segWidth = determinate
                  ? widget.width * widget.progress!.clamp(0, 1)
                  : widget.width * 0.38;
              final left = determinate
                  ? 0.0
                  : widget.width * 0.62 * _controller.value;
              return Positioned(
                left: left,
                child: Container(
                  width: segWidth,
                  height: widget.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [second, color]),
                    borderRadius:
                        BorderRadius.circular(widget.height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.45),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
