import 'package:flutter/material.dart';

/// 加载态按钮：点击后按钮内变成小圆环，宽度不变，不会把布局撑跳。
/// [isLoading] 为 true 时自动禁用点击，防止重复提交。
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.height = 48,
    this.borderRadius = 14,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = color ?? scheme.primary;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: scheme.onPrimary,
                ),
              )
            : Text(label),
      ),
    );
  }
}
