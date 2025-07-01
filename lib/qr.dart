import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
