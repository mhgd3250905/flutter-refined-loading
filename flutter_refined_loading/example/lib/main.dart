import 'package:flutter/material.dart';
import 'package:flutter_refined_loading/refined_loading.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});
  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool dark = false;
  bool overlayLoading = false;
  bool buttonLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B6CFF)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: LoadingOverlay(
        isLoading: overlayLoading,
        message: '正在处理，请稍候…',
        onCancel: () => setState(() => overlayLoading = false),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Refined Loading · 演示'),
            actions: [
              IconButton(
                icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => setState(() => dark = !dark),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _card('BreathingDots · 呼吸三点', const BreathingDots()),
              _card('OrbitDots · 轨道三点', const OrbitDots()),
              _card('RipplePulse · 涟漪', const RipplePulse(child: Icon(Icons.mic))),
              _card('GradientRing · 渐变圆环',
                  const GradientRing(showLabel: false)),
              _card('GradientRing · 定量 68%',
                  const GradientRing(progress: 0.68, showLabel: true)),
              _card('WaveBars · 波形', const WaveBars()),
              _card('MorphBlob · 流动色块',
                  const MorphBlob(child: Icon(Icons.auto_awesome, color: Colors.white))),
              _card('骨架屏', ShimmerSkeleton.listItem()),
              const SizedBox(height: 8),
              LoadingButton(
                label: '提交',
                isLoading: buttonLoading,
                onPressed: () async {
                  setState(() => buttonLoading = true);
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) setState(() => buttonLoading = false);
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () =>
                    setState(() => overlayLoading = true),
                child: const Text('打开全屏遮罩（可取消）'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  fadeSlideRoute(const Scaffold(
                    body: Center(child: Text('淡入 + 上滑进入的页面')),
                  )),
                ),
                child: const Text('试试淡入上滑页面过渡'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Center(child: child),
          ],
        ),
      ),
    );
  }
}
