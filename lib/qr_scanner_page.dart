import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:miecal/questionnaire.dart';
import 'package:miecal/vertical_slide_page.dart';
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

    final String? rawData = barcode.rawValue;

    if (rawData == null || rawData.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('QRコードからデータが読み取れませんでした。')));
      return;
    }

    _isScanning = true;
    cameraController.stop(); // カメラを一時停止

    final Map<String, dynamic> parsedData = _parseQrDataString(rawData);

    if (mounted) {
      // 修正点: Navigator.pushReplacement から Navigator.push に変更
      Navigator.push(
        // <-- ここを修正
        context,
        VerticalSlideRoute(
          page: QuestionnairePage(
            isFromQrScanner: true, // フラグはそのまま渡す
            userName: parsedData['氏名'] as String?,
            userDateOfBirth:
                parsedData['生年月日'] != null
                    ? DateTime.tryParse(parsedData['生年月日'])
                    : null,
            userHome: parsedData['住所'] as String?,
            userGender: parsedData['性別'] as String?,
            userTelNum: parsedData['電話番号'] as String?,
            selectedOnsetDay:
                parsedData['発症日'] != null
                    ? DateTime.tryParse(parsedData['発症日'])
                    : null,
            symptom: parsedData['症状'] as String?,
            affectedArea: parsedData['患部'] as String?,
            sufferLevel: parsedData['程度'] as String?,
            cause: parsedData['原因'] as String?,
            otherInformation: parsedData['その他'] as String?,
          ),
        ),
      ).then((_) {
        // QuestionnairePageから戻ってきたら再度スキャンを有効にする
        _isScanning = false;
        cameraController.start();
      });
    }
  }

  Map<String, dynamic> _parseQrDataString(String qrData) {
    final Map<String, dynamic> data = {};
    final List<String> lines = qrData.split('\n');

    for (final line in lines) {
      final parts = line.split(': ');
      if (parts.length >= 2) {
        final key = parts[0];
        final value = parts.sublist(1).join(': ');
        data[key] = value;
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRコードスキャン'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 前の画面に戻る
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
