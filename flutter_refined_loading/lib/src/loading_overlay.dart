import 'dart:ui';

import 'package:flutter/material.dart';

import 'gradient_ring.dart';

/// 全屏等待遮罩：毛玻璃 + 卡片 + 文案 + 可选取消。
/// 直接包在页面最外层，[isLoading] 一开即用，不用自己搭 Stack。
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message = '正在处理…',
    this.loader,
    this.onCancel,
    this.cancelLabel = '取消',
  });

  final Widget child;
  final bool isLoading;
  final String message;
  final Widget? loader;
  final VoidCallback? onCancel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withOpacity(0.55),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      loader ?? const GradientRing(size: 44),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (onCancel != null) ...[
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: onCancel,
                          child: Text(cancelLabel),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
