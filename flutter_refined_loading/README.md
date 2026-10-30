# flutter_refined_loading

精致、有质感的 Flutter loading / 等待 / 过渡动画组件。零第三方依赖，复制一个文件也能用，整包引入更方便。

## v3 · Quiet Light · 安静的光（原创，不是通用 loading）

这不是把圆点圆环换个颜色。这一组是我自己的审美：光要安静，动要慢，东西要从无到有、再回到无。

| 作品 | 它在等什么 |
|---|---|
| `TideLight` 潮汐光 | 两层潮水一前一后涌动，光在水面下 |
| `InkBloom` 墨晕 | 一滴墨落入清水，晕开后留一个干净的圆 |
| `SproutLine` 一线生机 | 只有一根线：长出来，展一片叶，淡出，再长 |
| `StardustAssembly` 星尘归位 | 散的星尘慢慢聚成一个圆，聚满又轻轻散开 |
| `LighthouseFog` 雾中灯塔 | 雾很浓，塔很小，光束一圈要 8 秒 |

v1、v2 的通用组件保留在库里，但这一组是主推的作品。

## v2 · 清透玻璃态（新增）

v1 被反馈“太简单、没质感”后，v2 换了一套质感语言：**1px 渐变边框 + 毛玻璃 + 柔焦极光 + 发光圆头 + 柔和大阴影**，透和光做质感，不堆颜色。

| 组件 | 质感点 |
|---|---|
| `GlassLoader` | 包住任何 loader，立刻变玻璃卡片 |
| `AuroraLoader` | 三个柔焦色块缓慢流动，中间放主 loader |
| `PremiumRing` | 双色渐变弧 + 弧尾发光圆头 + 内圈柔光 |
| `GlowDots` | 渐变圆点 + 随呼吸扩大的光晕 |
| `SoftProgress` | 4px 渐变条 + 尾端光点，定量/不定量都行 |
| `GlassSkeletonCard` | 半透明卡 + 微光，比纯灰骨架更像真实界面 |

```dart
GlassLoader(
  label: '正在生成…',
  child: const PremiumRing(size: 52),
);

const AuroraLoader(child: PremiumRing(size: 56));
const SoftProgress(progress: 0.62);
```

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
