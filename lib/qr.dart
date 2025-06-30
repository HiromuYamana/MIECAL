import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

class QuestionnairePage extends StatelessWidget {
  const QuestionnairePage({super.key});

  void _showQrCodePage(BuildContext context) {
    final currentUrl = html.window.location.href;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrPage(data: currentUrl)),
    );
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

class QrPage extends StatelessWidget {
  final String data;
  const QrPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRコード表示 Showing QR')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: QrImageView(
                  data: data,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
            Expanded(
              child: Text('ご記入ありがとうございました。', style: TextStyle(fontSize: 30)),
            ),
          ],
        ),
      ),
    );
  }
}
