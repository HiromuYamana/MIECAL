// lib/questionnaire.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use, unused_import
import 'dart:html' as html;
import 'dart:convert'; // jsonEncode を使うために追加
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth を使うために追加
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore を使うために追加

import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/qr.dart';
import 'package:miecal/qr_scanner_page.dart';

class QuestionnairePage extends StatelessWidget {
  // 修正点: isFromQrScanner フラグを追加
  final bool isFromQrScanner;

  // 個人情報フィールド
  final String? userName;
  final DateTime? userDateOfBirth;
  final String? userHome;
  final String? userGender;
  final String? userTelNum;

  // 問診票データフィールド
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea;
  final String? sufferLevel;
  final String? cause;
  final String? otherInformation;

  const QuestionnairePage({
    super.key,
    this.isFromQrScanner = false, // <-- 追加: デフォルトは false
    this.userName,
    this.userDateOfBirth,
    this.userHome,
    this.userGender,
    this.userTelNum,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea,
    this.sufferLevel,
    this.cause,
    this.otherInformation,
  });

  // 日付を「YYYY年MM月DD日」形式に整形するヘルパー関数 (画面表示用)
  String _formatDateHumanReadable(DateTime? date) {
    if (date == null) {
      return '未選択';
    }
    return '${date.year}年${date.month}月${date.day}日';
  }

  // QRコードのテキストデータ用に日付を整形するヘルパー関数
  String _formatDateForQr(DateTime? date) {
    if (date == null) {
      return '未選択'; // QRコード内で未選択と表示
    }
    return '${date.year}年${date.month}月${date.day}日';
  }

  // 修正点: 問診票データをFirestoreに保存するメソッドを追加
  Future<void> _saveQuestionnaireDataToFirestore(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ログインしていません。データを保存できません。')));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'lastQuestionnaireData': {
          'selectedOnsetDay': selectedOnsetDay?.toIso8601String(),
          'symptom': symptom,
          'affectedArea': affectedArea,
          'sufferLevel': sufferLevel,
          'cause': cause,
          'otherInformation': otherInformation,
          'submissionDate': FieldValue.serverTimestamp(),
        },
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('問診票データを保存しました！')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('問診票データの保存に失敗しました: ${e.toString()}')),
      );
      print('Firestore save error: $e');
    }
  }

  void _showQrCodePage(BuildContext context) async {
    await _saveQuestionnaireDataToFirestore(context);

    final Map<String, dynamic> questionnaireData = {
      '氏名': userName ?? '未入力',
      '住所': userHome ?? '未入力',
      '生年月日': _formatDateForQr(userDateOfBirth),
      '性別': userGender ?? '未入力',
      '電話番号': userTelNum ?? '未入力',
      '発症日': _formatDateForQr(selectedOnsetDay),
      '症状': symptom ?? '未入力',
      '患部': affectedArea ?? '未入力',
      '程度': sufferLevel ?? '未入力',
      '原因': cause ?? '未入力',
      'その他': otherInformation ?? '未入力',
    };

    List<String> qrDataLines = [];
    questionnaireData.forEach((key, value) {
      if (value != null &&
          value.toString().isNotEmpty &&
          value.toString() != '未入力' &&
          value.toString() != '未選択') {
        qrDataLines.add('$key: $value');
      }
    });

    String qrData = qrDataLines.join('\n');

    Navigator.push(context, VerticalSlideRoute(page: QrPage(data: qrData)));
  }

  @override
  Widget build(BuildContext context) {
    // 各データを表示用に整形
    String displayUserName = userName ?? '未入力';
    String displayUserHome = userHome ?? '未入力';
    String displayUserGender = userGender ?? '未入力';
    String displayUserTelNum = userTelNum ?? '未入力';
    String displayUserDateOfBirth = _formatDateHumanReadable(userDateOfBirth);
    String displayOnsetDay = _formatDateHumanReadable(selectedOnsetDay);

    String displaySymptom = symptom ?? '未入力';
    String displayAffectedArea = affectedArea ?? '未入力';
    String displaySufferLevel = sufferLevel ?? '未入力';
    String displayCause = cause ?? '未入力';

    List<String> displayOtherInfoItems = otherInformation?.split('; ') ?? [];

    return Scaffold(
      appBar: AppBar(
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_upward),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // 修正点: body の SingleChildScrollView を Expanded で囲む
      body: Expanded(
        // <-- ここを追加
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '問診票の内容確認',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // 基本情報セクション
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
                        '基本情報',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.blueGrey,
                        ),
                        title: const Text('氏名'),
                        trailing: Text(
                          displayUserName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.cake, // 誕生日アイコン
                          color: Colors.blueGrey,
                        ),
                        title: const Text('生年月日'),
                        trailing: Text(
                          displayUserDateOfBirth,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.home, // 住所アイコン
                          color: Colors.blueGrey,
                        ),
                        title: const Text('住所'),
                        trailing: Text(
                          displayUserHome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.wc, // 性別アイコン
                          color: Colors.blueGrey,
                        ),
                        title: const Text('性別'),
                        trailing: Text(
                          displayUserGender,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.phone, // 電話アイコン
                          color: Colors.blueGrey,
                        ),
                        title: const Text('電話番号'),
                        trailing: Text(
                          displayUserTelNum,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.event, // イベントアイコンなど
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
                        ),
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
                      if (displayOtherInfoItems.isEmpty)
                        const Row(
                          children: [
                            Icon(Icons.notes, color: Colors.blueGrey),
                            SizedBox(width: 16),
                            Text('詳細: 未入力', style: TextStyle(fontSize: 16)),
                          ],
                        )
                      else // 項目がある場合
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              displayOtherInfoItems.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.notes,
                                        color: Colors.blueGrey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // QRコード発行ボタンの表示を条件付きにする
              if (!isFromQrScanner) // QrScannerPageから来ていなければ表示
                Center(
                  child: ElevatedButton(
                    onPressed: () => _showQrCodePage(context),
                    child: const Text('QRコード作成 Create QRcode'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
