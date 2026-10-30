import 'package:flutter/material.dart';

import 'shimmer_skeleton.dart';

/// 玻璃骨架卡：内容没回来时不留白板，给一张半透明卡 + 微光扫过。
/// 比纯灰骨架更像“正在加载的真实界面”。
class GlassSkeletonCard extends StatelessWidget {
  const GlassSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: (isDark ? Colors.white : Colors.white).withOpacity(0.5),
        border: Border.all(
          color: Colors.white.withOpacity(isDark ? 0.2 : 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ShimmerSkeleton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 10,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
