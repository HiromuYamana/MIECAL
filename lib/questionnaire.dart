import 'package:flutter/material.dart';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:miecal/qr.dart';
import 'package:miecal/vertical_slide_page.dart';

class QuestionnairePage extends StatelessWidget {
  const QuestionnairePage({super.key});

  void _showQrCodePage(BuildContext context) {
    final currentUrl = html.window.location.href;
    Navigator.push(context, VerticalSlideRoute(page: QrPage(data: currentUrl)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('問診表')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showQrCodePage(context),
          child: const Text('QRコード作成 Create QRcode'),
        ),
      ),
    );
  }
}
