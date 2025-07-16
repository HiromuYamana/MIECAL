// lib/questionnaire.dart (全体を置き換えてください)
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

class QuestionnairePage extends StatefulWidget {
  final bool isFromQrScanner;
  final String? questionnaireRecordId;

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
    this.isFromQrScanner = false,
    this.questionnaireRecordId,
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

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  String? _displayUserName;
  DateTime? _displayUserDateOfBirth;
  String? _displayUserHome;
  String? _displayUserGender;
  String? _displayUserTelNum;
  DateTime? _displaySelectedOnsetDay;
  String? _displaySymptom;
  String? _displayAffectedArea;
  String? _displaySufferLevel;
  String? _displayCause;
  String? _displayOtherInformation;

  bool _isLoadingData = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    print('QuestionnairePage: initState called.');
    if (widget.questionnaireRecordId != null) {
      print(
        'QuestionnairePage: Loading data by ID: ${widget.questionnaireRecordId}',
      );
      _loadQuestionnaireDataById(widget.questionnaireRecordId!);
    } else {
      _initializeFromWidgetData();
      setState(() {
        _isLoadingData = false;
        print('QuestionnairePage: Initial data set, isLoadingData = false.');
      });
    }
  }

  void _initializeFromWidgetData() {
    _displayUserName = widget.userName;
    _displayUserDateOfBirth = widget.userDateOfBirth;
    _displayUserHome = widget.userHome;
    _displayUserGender = widget.userGender;
    _displayUserTelNum = widget.userTelNum;
    _displaySelectedOnsetDay = widget.selectedOnsetDay;
    _displaySymptom = widget.symptom;
    _displayAffectedArea = widget.affectedArea;
    _displaySufferLevel = widget.sufferLevel;
    _displayCause = widget.cause;
    _displayOtherInformation = widget.otherInformation;
  }

  String _formatDateHumanReadable(DateTime? date) {
    if (date == null) {
      return '未選択';
    }
    return '${date.year}年${date.month}月${date.day}日';
  }

  String _formatDateForQr(DateTime? date) {
    if (date == null) {
      return '未選択';
    }
    return '${date.year}年${date.month}月${date.day}日';
  }

  Future<String?> _saveQuestionnaireDataToFirestore(
    BuildContext context,
  ) async {
    print('Firestore: _saveQuestionnaireDataToFirestore called.');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Firestore: User not logged in. Cannot save data.');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ログインしていません。データを保存できません。')));
      return null;
    }

    final Map<String, dynamic> dataToSave = {
      'userId': user.uid,
      'userName': _displayUserName,
      'userDateOfBirth': _displayUserDateOfBirth?.toIso8601String(),
      'userHome': _displayUserHome,
      'userGender': _displayUserGender,
      'userTelNum': _displayUserTelNum,

      'selectedOnsetDay': _displaySelectedOnsetDay?.toIso8601String(),
      'symptom': _displaySymptom,
      'affectedArea': _displayAffectedArea,
      'sufferLevel': _displaySufferLevel,
      'cause': _displayCause,
      'otherInformation': _displayOtherInformation,
      'submissionDate': FieldValue.serverTimestamp(),
    };

    try {
      print(
        'Firestore: Attempting to save data for user ${user.uid} to questionnaire_records.',
      );
      final DocumentReference docRef = await FirebaseFirestore.instance
          .collection('questionnaire_records')
          .add(dataToSave);

      print('Firestore: Data saved SUCCESSFULLY! Record ID: ${docRef.id}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('問診票データを保存しました！')));
      return docRef.id;
    } catch (e) {
      print('Firestore: SAVE FAILED (Unexpected Error): ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('問診票データの保存に失敗しました: ${e.toString()}')),
      );
      return null;
    }
  }

  // lib/questionnaire.dart (抜粋)

  // ... (_QuestionnairePageState クラス内) ...

  // ドキュメントIDに基づいてFirestoreからデータをロードするメソッド (QRスキャン時用)
  Future<void> _loadQuestionnaireDataById(String id) async {
    print(
      'QuestionnairePage: _loadQuestionnaireDataById START. ID: $id',
    ); // <-- 呼び出し開始とIDを確認
    setState(() {
      _isLoadingData = true;
      _loadError = null;
    });
    try {
      // Firestore操作の直前に認証状態をログ出力 (重要)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print(
          'QuestionnairePage: DEBUG - User is NOT logged in when trying to load data for ID: $id',
        );
      } else {
        print(
          'QuestionnairePage: DEBUG - User IS logged in (UID: ${user.uid}) when trying to load data for ID: $id',
        );
      }

      final doc =
          await FirebaseFirestore.instance
              .collection('questionnaire_records')
              .doc(id)
              .get();

      print(
        'QuestionnairePage: Firestore document fetch complete. doc.exists: ${doc.exists}',
      ); // <-- ドキュメントの存在を確認

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        print(
          'QuestionnairePage: Raw Firestore Data: $data',
        ); // <-- 取得した生データ全体を確認

        setState(() {
          // ロードしたデータをState変数にセット (型キャストも問題ないか確認)
          _displayUserName = data['userName'] as String?;
          _displayUserDateOfBirth =
              data['userDateOfBirth'] is String
                  ? DateTime.tryParse(data['userDateOfBirth'] as String)
                  : null;
          _displayUserHome = data['userHome'] as String?;
          _displayUserGender = data['userGender'] as String?;
          _displayUserTelNum = data['userTelNum'] as String?;
          _displaySelectedOnsetDay =
              data['selectedOnsetDay'] is String
                  ? DateTime.tryParse(data['selectedOnsetDay'] as String)
                  : null;
          _displaySymptom = data['symptom'] as String?;
          _displayAffectedArea = data['affectedArea'] as String?;
          _displaySufferLevel = data['sufferLevel'] as String?;
          _displayCause = data['cause'] as String?;
          _displayOtherInformation = data['otherInformation'] as String?;
          _isLoadingData = false;
          print(
            'QuestionnairePage: Data set to State. isLoadingData = false.',
          ); // ロード成功ログ
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('問診票データをロードしました。')));
      } else {
        setState(() {
          _loadError = '指定された問診票データが見つかりません。';
          _isLoadingData = false;
        });
        print(
          'QuestionnairePage: Document not found for ID: $id. Or data is null.',
        ); // <-- データ見つからないログ
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('指定された問診票データが見つかりません。')));
      }
    } on FirebaseException catch (e) {
      setState(() {
        _loadError = 'Firestoreエラー: ${e.code} - ${e.message}';
        _isLoadingData = false;
      });
      print(
        'QuestionnairePage: Firestore ERROR: ${e.code} - ${e.message}',
      ); // <-- Firebaseエラー詳細ログ
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Firestoreロード失敗: ${e.message}')));
    } catch (e) {
      setState(() {
        _loadError = '問診票データのロードに失敗しました: ${e.toString()}';
        _isLoadingData = false;
      });
      print('QuestionnairePage: UNEXPECTED LOAD ERROR: $e'); // <-- 予期せぬエラーログ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('問診票データのロードに失敗しました: ${e.toString()}')),
      );
    }
  }

  void _showQrCodePage(BuildContext context) async {
    final String? recordId = await _saveQuestionnaireDataToFirestore(context);

    if (recordId == null) {
      return;
    }

    final Uri qrCodeUri = Uri(
      scheme: 'https',
      host: 'miecal-7190e.web.app', // あなたのWebアプリがデプロイされているドメイン
      path: '/questionnaire_records/$recordId',
    );

    final String qrCodeUrl = qrCodeUri.toString();
    print('Generated QR Code URL: $qrCodeUrl');

    Navigator.push(context, VerticalSlideRoute(page: QrPage(data: qrCodeUrl)));
  }

  @override
  Widget build(BuildContext context) {
    print(
      'QuestionnairePage: build method called. isLoadingData: $_isLoadingData, loadError: $_loadError',
    );

    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('問診票')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('問診票')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _loadError!,
              style: const TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // 各データを表示用に整形 (Stateのデータを使用)
    String displayUserName = _displayUserName ?? '未入力';
    String displayUserHome = _displayUserHome ?? '未入力';
    String displayUserGender = _displayUserGender ?? '未入力';
    String displayUserTelNum = _displayUserTelNum ?? '未入力';
    String displayUserDateOfBirth = _formatDateHumanReadable(
      _displayUserDateOfBirth,
    );
    String displayOnsetDay = _formatDateHumanReadable(_displaySelectedOnsetDay);

    String displaySymptom = _displaySymptom ?? '未入力';
    String displayAffectedArea = _displayAffectedArea ?? '未入力';
    String displaySufferLevel = _displaySufferLevel ?? '未入力';
    String displayCause = _displayCause ?? '未入力';

    List<String> displayOtherInfoItems =
        _displayOtherInformation?.split('; ') ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('問診票'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.isFromQrScanner) {
              Navigator.pushReplacement(
                context,
                VerticalSlideRoute(page: const QrScannerPage()),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
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
                    _buildInfoListTile(Icons.person, '氏名', displayUserName),
                    _buildInfoListTile(
                      Icons.cake,
                      '生年月日',
                      displayUserDateOfBirth,
                    ),
                    _buildInfoListTile(Icons.home, '住所', displayUserHome),
                    _buildInfoListTile(Icons.wc, '性別', displayUserGender),
                    _buildInfoListTile(Icons.phone, '電話番号', displayUserTelNum),
                    _buildInfoListTile(Icons.event, '発症日', displayOnsetDay),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                    _buildInfoListTile(Icons.sick, '症状', displaySymptom),
                    _buildInfoListTile(
                      Icons.healing,
                      '患部',
                      displayAffectedArea,
                    ),
                    _buildInfoListTile(
                      Icons.sentiment_neutral,
                      '程度',
                      displaySufferLevel,
                    ),
                    _buildInfoListTile(Icons.info_outline, '原因', displayCause),
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
                      _buildInfoListTile(Icons.notes, '詳細', '未入力')
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
            Center(
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

  // ListTile を生成するヘルパー関数
  Widget _buildInfoListTile(
    IconData icon,
    String title,
    String value, {
    bool isLongText = false,
    bool isTitleOnly = false,
  }) {
    //isTitleOnly はこの実装では使われていない
    if (isTitleOnly) {
      return ListTile(
        leading: Icon(icon, color: Colors.blueGrey),
        title: Text(title),
      );
    }
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      trailing:
          isLongText
              ? Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 16),
                ),
              )
              : Text(value, style: const TextStyle(fontSize: 16)),
    );
  }
}
