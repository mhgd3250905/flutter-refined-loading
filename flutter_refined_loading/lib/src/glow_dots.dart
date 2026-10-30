import 'package:flutter/material.dart';

/// 辉光三点：v1 呼吸点的升级版。
/// 每个点外有一圈随呼吸扩大的光晕，点本身是双色渐变，
/// 看起来像在发光，而不是在闪烁。
class GlowDots extends StatefulWidget {
  const GlowDots({
    super.key,
    this.size = 64,
    this.dotSize = 12,
    this.color,
    this.secondColor,
    this.duration = const Duration(milliseconds: 1300),
  });

  final double size;
  final double dotSize;
  final Color? color;
  final Color? secondColor;
  final Duration duration;

  @override
  State<GlowDots> createState() => _GlowDotsState();
}

class _GlowDotsState extends State<GlowDots>
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
    return SizedBox(
      width: widget.size,
      height: widget.dotSize * 2.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final begin = i * 0.2;
          final anim = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(begin, begin + 0.6, curve: Curves.easeInOut),
            ),
          );
          return AnimatedBuilder(
            animation: anim,
            builder: (_, __) {
              final t = anim.value <= 0.5
                  ? anim.value * 2
                  : (1 - anim.value) * 2;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: widget.dotSize * 2,
                height: widget.dotSize * 2,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: widget.dotSize * (1.4 + 0.6 * t),
                      height: widget.dotSize * (1.4 + 0.6 * t),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.18 * t),
                      ),
                    ),
                    Container(
                      width: widget.dotSize * (0.7 + 0.3 * t),
                      height: widget.dotSize * (0.7 + 0.3 * t),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [second, color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.35 * t),
                            blurRadius: 12 * t,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
