import 'package:flutter/material.dart';
import 'package:miecal/login_page.dart';
import 'package:miecal/other_information.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:vibration/vibration.dart';


class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> with TickerProviderStateMixin {
  late AnimationController _handController;
  late Animation<double> _handAnimation;

  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  bool showRipple = false;

  @override
  void initState() {
    super.initState();

    _handController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _handAnimation = Tween<double>(begin: 0.0, end: 60.0).animate(
      CurvedAnimation(parent: _handController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rippleController.forward(from: 0.0);
        setState(() {
          showRipple = true;
        });
        _handController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _handController.forward();
      }
    });

    _handController.forward();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _rippleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showRipple = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _handController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _goToLoginPage() async {
    // 振動する（デバイスが対応しているか確認）
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    }

    // 画面遷移
    Navigator.of(
      context,
    ).push(VerticalSlideRoute(page: const LoginScreen())); //デバック用に変えた
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _goToLoginPage,
        child: Stack(
          children: [
            // 背景グラデーション
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.5,
                  colors: [Colors.blue, Color(0xFF80D6FF)],
                ),
              ),
            ),

            // アプリのアイコン
            Align(
              alignment: Alignment(0.0, -0.2),
              child: Image.asset(
                'assets/app_icon.png',
                width: 280,
                height: 280,
              ),
            ),

            // 波紋
            if (showRipple)
              AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  return Positioned(
                    bottom: 150, // 波紋を少し上に表示
                    left:
                        MediaQuery.of(context).size.width / 2 -
                        _rippleAnimation.value / 2,
                    child: Container(
                      width: _rippleAnimation.value,
                      height: _rippleAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(
                          alpha: 1.0 - _rippleAnimation.value / 100,
                        ),
                      ),
                    ),
                  );
                },
              ),
            
            // 手のアニメーション
            AnimatedBuilder(
              animation: _handAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 35 + _handAnimation.value, // 手を少し下へ
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: child!,
                );
              },
              child: Image.asset(
                'assets/タッチアイコン.png',
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
