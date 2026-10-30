import 'dart:ui';

import 'package:flutter/material.dart';

/// 清透玻璃卡片：把任何 loader 包起来立刻变高级。
/// 做法是 1px 渐变边框 + 毛玻璃 + 柔和大阴影 + 顶部一道高光，
/// 质感来自“透”和“光”，不是堆颜色。
class GlassLoader extends StatelessWidget {
  const GlassLoader({
    super.key,
    required this.child,
    this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
    this.borderRadius = 24,
    this.blur = 18,
  });

  final Widget child;
  final String? label;
  final EdgeInsets padding;
  final double borderRadius;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = isDark ? Colors.white : Colors.white;
    return Container(
      // 1px 渐变边框：左上亮、右下淡，模拟玻璃边缘反光
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [
            tint.withOpacity(0.85),
            tint.withOpacity(0.25),
            tint.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.12),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            color: (isDark ? const Color(0xFF1E2433) : Colors.white)
                .withOpacity(0.55),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 顶部高光线
                Container(
                  height: 1,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        tint.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                child,
                if (label != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.75),
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
