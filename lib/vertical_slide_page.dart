import 'package:flutter/material.dart';

// 縦スライドのアニメーションを定義するカスタムページルート
class VerticalSlideRoute extends PageRouteBuilder {
  final Widget page;

  VerticalSlideRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Tween を使ってオフセットを定義 (Y軸方向にスライド)
          const begin = Offset(0.0, 1.0); // 画面の下から出現
          const end = Offset.zero; // 画面の中央へ
          const curve = Curves.ease; // アニメーションのカーブ

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          // SlideTransition ウィジェットを使ってアニメーションを適用
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400), // アニメーションの時間を調整
      );
}
