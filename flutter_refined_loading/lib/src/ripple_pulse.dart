import 'package:flutter/material.dart';

/// 涟漪脉冲：中心实心点 + 向外扩散的三层涟漪。
/// 适合定位、等待对方、语音通话等待等“正在扩散 / 正在寻找”场景。
class RipplePulse extends StatefulWidget {
  const RipplePulse({
    super.key,
    this.size = 72,
    this.color,
    this.duration = const Duration(milliseconds: 1800),
    this.child,
  });

  final double size;
  final Color? color;
  final Duration duration;

  /// 中心可以放图标，例如 Icons.mic / Icons.location_on
  final Widget? child;

  @override
  State<RipplePulse> createState() => _RipplePulseState();
}

class _RipplePulseState extends State<RipplePulse>
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
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 0; i < 3; i++)
                Builder(
                  builder: (_) {
                    final t = (_controller.value + i / 3) % 1.0;
                    return Container(
                      width: widget.size * (0.3 + 0.7 * t),
                      height: widget.size * (0.3 + 0.7 * t),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withOpacity(0.5 * (1 - t)),
                          width: 1.5,
                        ),
                      ),
                    );
                  },
                ),
              Container(
                width: widget.size * 0.32,
                height: widget.size * 0.32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.35), blurRadius: 16),
                  ],
                ),
                child: widget.child == null
                    ? null
                    : IconTheme(
                        data: IconThemeData(
                          color: Colors.white,
                          size: widget.size * 0.16,
                        ),
                        child: widget.child!,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
