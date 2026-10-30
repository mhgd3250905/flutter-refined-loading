# flutter-refined-loading

精致、有质感的 Flutter loading / 等待 / 过渡动画组件，零第三方依赖。

## 结构

- `flutter_refined_loading/` — Flutter package 本体 + 示例 App（`example/`）
  - 呼吸三点、轨道三点、涟漪、渐变圆环、波形、流动色块、骨架屏、全屏遮罩、加载按钮、页面/内容过渡
  - 统一用法：`size` 定尺寸，`color` 为空跟随主题主色，`duration` 越大越舒缓
- `web-demo/index.html` — 网页版同款预览（CSS 动效，节奏/颜色与 Flutter 版一致）

## 快速上手

```yaml
dependencies:
  flutter_refined_loading:
    path: ./flutter_refined_loading
```

```dart
import 'package:flutter_refined_loading/refined_loading.dart';

const BreathingDots();
const GradientRing(progress: 0.68, showLabel: true);
Navigator.push(context, fadeSlideRoute(const DetailPage()));
```

详见 `flutter_refined_loading/README.md`。

注意：本机首次提交时未跑 `flutter analyze`（VM 无 Flutter/Dart 工具链），请在本地跑 `example/` 验证。
