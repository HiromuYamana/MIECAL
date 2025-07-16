// lib/qr_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:miecal/questionnaire.dart'; // QuestionnairePage をインポート
import 'package:miecal/vertical_slide_page.dart';
import 'dart:async';
import 'package:collection/collection.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanning) return;

    final Barcode? barcode = capture.barcodes.firstOrNull;

    if (barcode == null) {
      return;
    }

    final String? rawData = barcode.rawValue; // QRコードの生データ（URL文字列）

    if (rawData == null || rawData.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('QRコードからデータが読み取れませんでした。')));
      return;
    }

    _isScanning = true;
    cameraController.stop();

    // 修正点: QRコードデータをURLとして解析し、IDを抽出
    Uri? scannedUri;
    try {
      scannedUri = Uri.parse(rawData);
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('無効なQRコード形式です。')));
      _isScanning = false;
      cameraController.start();
      return;
    }

    // ディープリンクのスキームとホスト、パスが一致するか確認
    // 例: miecalapp://review/questionnaire_record?id=xxxx
    if (scannedUri!.scheme == 'miecalapp' &&
        scannedUri.host == 'review' &&
        scannedUri.path == '/questionnaire_record' &&
        scannedUri.queryParameters.containsKey('id')) {
      final String? recordId = scannedUri.queryParameters['id'];

      if (recordId != null && recordId.isNotEmpty) {
        // 修正点: main.dart で定義した新しいルート '/questionnaire_review_by_id' へ遷移
        // そして、IDとisFromQrScannerフラグをargumentsとして渡す
        if (mounted) {
          Navigator.pushReplacementNamed(
            // pushReplacementNamed に変更
            context,
            '/questionnaire_review_by_id', // 新しいルートパス
            arguments: {
              'id': recordId, // ドキュメントIDを渡す
              'isFromQrScanner': true, // QrScannerからの遷移であることを示すフラグ
            },
          ).then((_) {
            _isScanning = false;
            cameraController.start();
          });
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('QRコードに有効なIDが含まれていません。')));
        _isScanning = false;
        cameraController.start();
      }
    } else {
      // 予期しないURL形式の場合 (例: 古いQRコードデータ、または別のURL)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('このQRコードは問診票データではありません。')));
      _isScanning = false;
      cameraController.start();
    }
  }

  // _parseQrDataString はもはやURLを解析しないため、不要になる可能性が高い
  // または、レガシーなQRコードデータ形式もサポートする場合は残す
  Map<String, dynamic> _parseQrDataString(String qrData) {
    // 古いQRコードデータ形式を解析する場合、このロジックをここに維持
    // しかし、これからはQRはURL形式になるため、このメソッドは使われないはず
    return {}; // 例として空のMapを返す
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRコードスキャン'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return Center(
                child: Text(
                  'カメラにアクセスできません: ${error.errorDetails}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'QRコードを中央に合わせてください',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
