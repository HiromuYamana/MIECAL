// lib/questionnaire.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use, unused_import
import 'dart:html' as html;

import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/qr.dart';

class QuestionnairePage extends StatelessWidget {
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea;
  final String? sufferLevel;
  final String? cause;
  final String? otherInformation;

  const QuestionnairePage({
    super.key,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea,
    this.sufferLevel,
    this.cause,
    this.otherInformation,
  });

  // 日付を「YYYY年MM月DD日」形式に整形するヘルパー関数
  String _formatDate(DateTime? date) {
    if (date == null) {
      return '未選択';
    }
    return '${date.year}年${date.month}月${date.day}日';
  }

  void _showQrCodePage(BuildContext context) {
    // QRコードに含めるデータ文字列を生成
    String qrData = '問診票データ:\n';
    qrData += '発症日: ${_formatDate(selectedOnsetDay)}\n'; // <-- ここを修正
    qrData += '症状: ${symptom ?? '未入力'}\n';
    qrData += '患部: ${affectedArea ?? '未入力'}\n';
    qrData += '程度: ${sufferLevel ?? '未入力'}\n';
    qrData += '原因: ${cause ?? '未入力'}\n';
    qrData += 'その他: ${otherInformation ?? '未入力'}\n';

    Navigator.push(context, VerticalSlideRoute(page: QrPage(data: qrData)));
  }

  @override
  Widget build(BuildContext context) {
    // 各データを表示用に整形
    String displayOnsetDay =
        selectedOnsetDay != null
            ? '${selectedOnsetDay!.year}年${selectedOnsetDay!.month}月${selectedOnsetDay!.day}日'
            : '未選択';
    String displaySymptom = symptom ?? '未入力';
    String displayAffectedArea = affectedArea ?? '未入力';
    String displaySufferLevel = sufferLevel ?? '未入力';
    String displayCause = cause ?? '未入力';
    String displayOtherInfo = otherInformation ?? '未入力';

    return Scaffold(
      appBar: AppBar(title: const Text('問診票')),
      body: SingleChildScrollView(
        // 画面全体をスクロール可能に
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 子要素を横幅いっぱいに広げる
          children: [
            const Text(
              '問診票の内容確認',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // タイトルを中央寄せ
            ),
            const SizedBox(height: 20),

            // 発症日セクション
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4, // 影の深さ
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '基本情報',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Divider(), // 区切り線
                    ListTile(
                      leading: const Icon(
                        Icons.calendar_today,
                        color: Colors.blueGrey,
                      ),
                      title: const Text('発症日'),
                      trailing: Text(
                        displayOnsetDay,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // 他の基本情報があればここに追加
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 症状・原因セクション
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '症状・原因詳細',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.sick, color: Colors.blueGrey),
                      title: const Text('症状'),
                      trailing: Expanded(
                        child: Text(
                          displaySymptom,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ), // 長文対応
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.healing,
                        color: Colors.blueGrey,
                      ),
                      title: const Text('患部'),
                      trailing: Expanded(
                        child: Text(
                          displayAffectedArea,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.sentiment_neutral,
                        color: Colors.blueGrey,
                      ),
                      title: const Text('程度'),
                      trailing: Text(
                        displaySufferLevel,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline,
                        color: Colors.blueGrey,
                      ),
                      title: const Text('原因'),
                      trailing: Expanded(
                        child: Text(
                          displayCause,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // その他情報セクション
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'その他の情報',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.notes, color: Colors.blueGrey),
                      title: const Text('詳細'),
                      trailing: Expanded(
                        child: Text(
                          displayOtherInfo,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            Center(
              // ボタンを中央に配置
              child: ElevatedButton(
                onPressed: () => _showQrCodePage(context),
                child: const Text('QRコード作成 Create QRcode'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
