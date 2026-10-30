import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 波形条：5 根圆角竖条依次起伏，像柔和的声波。
/// 适合音频加载、AI 思考中、语音输入等待。
class WaveBars extends StatefulWidget {
  const WaveBars({
    super.key,
    this.size = 48,
    this.color,
    this.duration = const Duration(milliseconds: 1000),
    this.barCount = 5,
  });

  final double size;
  final Color? color;
  final Duration duration;
  final int barCount;

  @override
  State<WaveBars> createState() => _WaveBarsState();
}

class _WaveBarsState extends State<WaveBars>
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
    final barWidth = widget.size / (widget.barCount * 2.2);
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.6,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.barCount, (i) {
              // 每根条错相，形成波浪
              final phase = _controller.value * math.pi * 2 + i * 0.7;
              final t = (0.5 + 0.5 * math.sin(phase));
              final height = widget.size * 0.6 * (0.25 + 0.75 * t);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: barWidth * 0.3),
                width: barWidth,
                height: height,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.5 + 0.5 * t),
                  borderRadius: BorderRadius.circular(barWidth / 2),
                ),
              );
            }),
          );
        },
      ),
    );
  }

}
