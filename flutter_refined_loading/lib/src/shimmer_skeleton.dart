import 'package:flutter/material.dart';

/// 骨架屏 + 微光扫过：内容还没回来时先给结构，不留白屏。
/// 用法：列表占位用 [ShimmerSkeleton.list]，单卡片用 [ShimmerSkeleton.card]，
/// 也可以直接用 [ShimmerSkeleton] 包任意灰块。
class ShimmerSkeleton extends StatefulWidget {
  const ShimmerSkeleton({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1600),
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  /// 常见的“头像 + 两行文字”占位
  factory ShimmerSkeleton.listItem({Key? key}) {
    return ShimmerSkeleton(
      key: key,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = widget.baseColor ??
        (isDark ? Colors.white10 : Colors.black12);
    final highlight = widget.highlightColor ??
        (isDark ? Colors.white24 : Colors.white70);
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        // 微光从左扫到右
        final x = -1.5 + _controller.value * 3.0;
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
              begin: Alignment(x - 0.6, 0),
              end: Alignment(x + 0.6, 0),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
