import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 极光背景 loader：三个柔焦色块在玻璃后缓慢流动，中间放主 loader。
/// 放在页面背景或卡片里，整个等待画面立刻有“高级 App”的感觉。
class AuroraLoader extends StatefulWidget {
  const AuroraLoader({
    super.key,
    required this.child,
    this.size = 180,
    this.duration = const Duration(milliseconds: 6000),
  });

  final Widget child;
  final double size;
  final Duration duration;

  @override
  State<AuroraLoader> createState() => _AuroraLoaderState();
}

class _AuroraLoaderState extends State<AuroraLoader>
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
    final blobs = [
      (scheme.primary, 0.0),
      (scheme.tertiary, 2.1),
      (scheme.secondary, 4.2),
    ];
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = _controller.value * math.pi * 2;
          return Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 0; i < blobs.length; i++)
                Positioned(
                  left: widget.size * 0.5 +
                      math.cos(t + blobs[i].$2) * widget.size * 0.22 -
                      widget.size * 0.3,
                  top: widget.size * 0.5 +
                      math.sin(t + blobs[i].$2) * widget.size * 0.22 -
                      widget.size * 0.3,
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                    child: Container(
                      width: widget.size * 0.6,
                      height: widget.size * 0.6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: blobs[i].$1.withOpacity(0.55),
                      ),
                    ),
                  ),
                ),
              // 玻璃罩：把极光压成柔光，不刺眼
              Container(
                width: widget.size * 0.72,
                height: widget.size * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withOpacity(0.45),
                ),
              ),
              widget.child,
            ],
          );
        },
      ),
    );
  }
}
