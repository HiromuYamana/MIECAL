// lib/questionnaire.dart
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use, unused_import
import 'dart:html' as html;

import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/qr.dart';

class QuestionnairePage extends StatelessWidget {
  final String? userName;
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea;
  final String? sufferLevel;
  final String? cause;
  final String? otherInformation; // この情報が「飲酒: 飲む; 喫煙: 吸わない; お薬: なし」のような形式で渡される

  const QuestionnairePage({
    super.key,
    this.userName,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea,
    this.sufferLevel,
    this.cause,
    this.otherInformation,
  });

  // 日付を「YYYY年MM月DD日」形式に整形するヘルパー関数
  String _formatDateHumanReadable(DateTime? date) {
    if (date == null) {
      return '未選択';
    }
    return '${date.year}年${date.month}月${date.day}日';
  }

  // 以前の _formatDateForJson は JSON の日付形式を想定していましたが、
  // QRコードのテキスト表示の視認性を優先するなら、こちらも人間が読める形式に
  String? _formatDateForQr(DateTime? date) {
    // 新しい名前を提案
    if (date == null) {
      return null; // または '未選択'、QRコードに含めるデータとしてどちらが良いか
    }
    return '${date.year}年${date.month}月${date.day}日';
  }

  void _showQrCodePage(BuildContext context) {
    // 問診票データをMapとしてまとめる
    final Map<String, dynamic> questionnaireData = {
      '氏名': userName ?? '未入力',
      '発症日': _formatDateForQr(selectedOnsetDay), // ここで整形された日付を使う
      '症状': symptom,
      '患部': affectedArea,
      '程度': sufferLevel,
      '原因': cause,
      'その他': otherInformation, // 他の情報の文字列をそのまま使う
    };

    // Mapを人間が読みやすい形式の文字列に変換
    // ここでJSONではなく、カスタムな整形文字列を生成します
    List<String> qrDataLines = [];
    questionnaireData.forEach((key, value) {
      if (value != null &&
          value.toString().isNotEmpty &&
          value.toString() != '未入力' &&
          value.toString() != '未選択') {
        qrDataLines.add('$key: $value');
      }
    });

    String qrData = qrDataLines.join('\n'); // 各項目を改行で区切る

    Navigator.push(context, VerticalSlideRoute(page: QrPage(data: qrData)));
  }

  @override
  Widget build(BuildContext context) {
    String displayUserName = userName ?? '未入力';
    // 各データを表示用に整形
    String displayOnsetDay = _formatDateHumanReadable(
      selectedOnsetDay,
    ); // ヘルパー関数を使用
    String displaySymptom = symptom ?? '未入力';
    String displayAffectedArea = affectedArea ?? '未入力';
    String displaySufferLevel = sufferLevel ?? '未入力';
    String displayCause = cause ?? '未入力';

    // 'その他'の情報をセミコロンで分割してリストにする
    List<String> displayOtherInfoItems = otherInformation?.split('; ') ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('問診票')),
      body: SingleChildScrollView(
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

            // 基本情報セクション (変更なし)
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
                      leading: const Icon(Icons.person, color: Colors.blueGrey),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 症状・原因セクション (変更なし)
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

            // その他情報セクション (ここを修正)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // lib/questionnaire.dart の 'その他の情報' セクションの Card 内の Padding の子
              // Card の子である Padding の中に Column があり、その Column の children の部分を修正
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // <-- これが Card の Column
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
                  // ここから下の部分が前回の修正で最も重要な変更点です
                  if (displayOtherInfoItems.isEmpty)
                    // 項目がない場合
                    const Row(
                      children: [
                        Icon(Icons.notes, color: Colors.blueGrey),
                        SizedBox(width: 16),
                        Text('詳細: 未入力', style: TextStyle(fontSize: 16)),
                      ],
                    )
                  else // 項目がある場合
                    Row(
                      // <-- アイコンと詳細全体を横並びにするためのRow
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.notes,
                          color: Colors.blueGrey,
                        ), // <-- アイコン
                        const SizedBox(width: 16),
                        Expanded(
                          // <-- 詳細テキストが利用可能なスペースを全て占める
                          child: Column(
                            // <-- 詳細テキストの各行を縦に並べるためのColumn
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '詳細',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ), // <-- 「詳細」というタイトル
                              const SizedBox(height: 4),
                              // ここで map を使って各項目を縦に並べる
                              ...displayOtherInfoItems.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
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
