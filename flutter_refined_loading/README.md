# flutter_refined_loading

精致、有质感的 Flutter loading / 等待 / 过渡动画组件。零第三方依赖，复制一个文件也能用，整包引入更方便。

## 包含什么（v1）

| 组件 | 适合场景 |
|---|---|
| `BreathingDots` | 最常用、最克制的等待 |
| `OrbitDots` | 正在连接 / 同步 |
| `RipplePulse` | 定位、等待对方、语音等待，可放中心图标 |
| `GradientRing` | 不定量转圈；传 `progress` 即变定量 + 百分比 |
| `WaveBars` | 音频、AI 思考中 |
| `MorphBlob` | AI 生成中、品牌感强的等待 |
| `ShimmerSkeleton` | 列表/卡片还没回来时的骨架屏 |
| `LoadingOverlay` | 全屏毛玻璃遮罩 + 文案 + 取消 |
| `LoadingButton` | 防重复提交的加载按钮 |
| `fadeSlideRoute` / `scaleFadeRoute` / `slideUpRoute` / `TransitionSwitcher` | 页面与内容切换过渡 |

所有组件统一约定：`size` 是整体尺寸，`color` 为空跟随主题主色，`duration` 越大越舒缓。

## 快速上手

```yaml
dependencies:
  flutter_refined_loading:
    path: ../flutter_refined_loading  # 正式发布后改成 pub.dev 版本
```

```dart
import 'package:flutter_refined_loading/refined_loading.dart';

// 最常用
const BreathingDots();

// 定量进度
const GradientRing(progress: 0.68, showLabel: true);

// 全屏等待
LoadingOverlay(
  isLoading: isLoading,
  message: '正在处理…',
  onCancel: () => setState(() => isLoading = false),
  child: Scaffold(...),
);

// 页面过渡
Navigator.push(context, fadeSlideRoute(const DetailPage()));
```

示例 App 在 `example/`，跑起来就能逐个看效果、切深浅色。

## 设计原则

1. 克制：不做弹跳、不做刺眼闪烁，统一 easeInOut / easeOutCubic。
2. 有质感：渐变、阴影、毛玻璃只用在定住画面重心的地方，不堆。
3. 不撑布局：按钮加载时宽度不变，骨架屏先给结构不留白屏。
4. 零依赖：不引入第三方动画库，避免版本冲突，方便你以后直接拷进项目。
