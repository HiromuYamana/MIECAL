import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth を使うために追加
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore を使うために追加
import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/qr.dart';
import 'package:miecal/l10n/app_localizations.dart'; 
import 'package:intl/intl.dart'; // 多言語日付フォーマット用

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

  // 画面表示用：人間が読む日付フォーマット
String _formatDateHumanReadable(BuildContext context, DateTime? date) {
  final loc = AppLocalizations.of(context)!;
  if (date == null) {
    return loc.notSelected; // ← l10n 対応
  }

  // ローカライズされた日付フォーマット（例: ja -> "2025年7月5日", en -> "July 5, 2025"）
  return DateFormat.yMMMMd(loc.localeName).format(date);
}

// QRコード用：固定フォーマットだけど「未選択」は翻訳される
String _formatDateForQr(BuildContext context, DateTime? date) {
  final loc = AppLocalizations.of(context)!;
  if (date == null) {
    return loc.notSelected; // ← QRでも多言語化された "未選択" を使う
  }

  // 固定フォーマットでシンプルに（例: "2025-07-05"）
  return DateFormat('yyyy-MM-dd').format(date);
}

  // 修正点: 問診票データをFirestoreに保存するメソッドを追加
  Future<void> _saveQuestionnaireDataToFirestore(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.notLoggedIn)));
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
      ).showSnackBar(SnackBar(content: Text(loc.qrSaveSuccess)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${loc.qrSaveFailed} ${e.toString()}')),
      );
      print('Firestore save error: $e');
    }
  }

  void _showQrCodePage(BuildContext context) async {
    await _saveQuestionnaireDataToFirestore(context);
    final loc = AppLocalizations.of(context)!;
    final Map<String, dynamic> questionnaireData = {
      loc.name: userName ?? loc.notEntered,
      loc.address: userHome ?? loc.notEntered,
      loc.birthdate: _formatDateForQr(context, userDateOfBirth),
      loc.gender: userGender ?? loc.notEntered,
      loc.phone: userTelNum ?? loc.notEntered,
      loc.onsetDate: _formatDateForQr(context, selectedOnsetDay),
      loc.symptom: symptom ?? loc.notEntered,
      loc.affectedArea: affectedArea ?? loc.notEntered,
      loc.severity: sufferLevel ?? loc.notEntered,
      loc.cause: cause ?? loc.notEntered,
      loc.otherInfo: otherInformation ?? loc.notEntered,
    };

    List<String> qrDataLines = [];
    questionnaireData.forEach((key, value) {
      if (value != null &&
          value.toString().isNotEmpty &&
          value.toString() != loc.notEntered &&
          value.toString() != loc.notSelected) {
        qrDataLines.add('$key: $value');
      }
    });

    String qrData = qrDataLines.join('\n');

    Navigator.push(context, VerticalSlideRoute(page: QrPage(data: qrData)));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    String displayUserName = userName ?? loc.notSelected;
    String displayUserHome = userHome ?? loc.notSelected;
    String displayUserGender = userGender ?? loc.notSelected;
    String displayUserTelNum = userTelNum ?? loc.notSelected;
    String displayUserDateOfBirth = _formatDateHumanReadable(context, userDateOfBirth);
    String displayOnsetDay = _formatDateHumanReadable(context, selectedOnsetDay);

    String displaySymptom = symptom ?? loc.notSelected;
    String displayAffectedArea = affectedArea ?? loc.notSelected;
    String displaySufferLevel = sufferLevel ?? loc.notSelected;
    String displayCause = cause ?? loc.notSelected;

    List<String> displayOtherInfoItems = otherInformation?.split('; ') ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MIECAL",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true, 
        backgroundColor: const Color.fromARGB(255, 75, 170, 248),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Material(
              color: const Color.fromARGB(255, 207, 227, 230),
              child: InkWell(
                onTap:(){
                  Navigator.pop(context);
                },
                child: SizedBox(
                  child:Center(
                  child: const Icon(
                    Icons.expand_less,
                    color: Colors.white,
                    size: 36,
                  ),
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(loc.questionnaireConfirmTitle, style: const TextStyle(color: Colors.black, fontSize: 22)), 
          ),
          Expanded(
            flex: 14,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                          Text(
                            loc.basicInformation,
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
                            title: Text(loc.name),
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
                            title: Text(loc.birthdate),
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
                            title: Text(loc.address),
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
                            title: Text(loc.gender),
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
                            title: Text(loc.phone),
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
                            title: Text(loc.onsetDate),
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
                          Text(
                            loc.symptomsCauseDetails,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.sick, color: Colors.blueGrey),
                            title: Text(loc.symptom),
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
                            title: Text(loc.affectedArea),
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
                            title: Text(loc.severity),
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
                            title: Text(loc.cause),
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
                          Text(
                            loc.otherInfo,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const Divider(),
                          if (displayOtherInfoItems.isEmpty)
                            Row(
                              children: [
                                const Icon(Icons.notes, color: Colors.blueGrey),
                                const SizedBox(width: 16),
                                Text(loc.detailsNotEntered, style: const TextStyle(fontSize: 16)),
                              ],
                            )
                          else // 項目がある場合
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  displayOtherInfoItems.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                        child: Text(loc.createQrCode),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ]
      )
    );
  }
}
