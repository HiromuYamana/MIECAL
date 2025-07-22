import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth を使うために追加
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore を使うために追加
import 'package:miecal/l10n/app_localizations.dart';
import 'package:intl/intl.dart'; // 多言語日付フォーマット用

class QuestionnaireDisplayPage extends StatefulWidget {
  final String questionnaireRecordId; // 表示する問診票のIDは必須

  const QuestionnaireDisplayPage({
    super.key,
    required this.questionnaireRecordId,
  });

  @override
  State<QuestionnaireDisplayPage> createState() =>
      _QuestionnaireDisplayPageState();
}

class _QuestionnaireDisplayPageState extends State<QuestionnaireDisplayPage> {
  // 表示用データフィールド
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
    print('QuestionnaireDisplayPage: initState called.');
    if (widget.questionnaireRecordId.isNotEmpty) {
      print(
        'QuestionnaireDisplayPage: Loading data by ID: ${widget.questionnaireRecordId}',
      );
      _loadQuestionnaireDataById(widget.questionnaireRecordId);
    } else {
      setState(() {
        _loadError = '問診票IDが指定されていません。';
        _isLoadingData = false;
      });
      print('QuestionnaireDisplayPage: No questionnaireRecordId provided.');
    }
  }

  String _formatDateHumanReadable(DateTime? date) {
    if (date == null) {
      return '未選択';
    }
    // 日本語のフォーマット
    return DateFormat('yyyy年MM月dd日').format(date);
  }

  Future<void> _loadQuestionnaireDataById(String id) async {
    print(
      'QuestionnaireDisplayPage: _loadQuestionnaireDataById START. ID: $id',
    );
    setState(() {
      _isLoadingData = true;
      _loadError = null;
    });
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('questionnaire_records')
              .doc(id)
              .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        print('QuestionnaireDisplayPage: Firestore Doc Exists: ${doc.exists}');
        print('QuestionnaireDisplayPage: Raw Firestore Data: $data');

        setState(() {
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
        });
        // スナックバーはWebアプリでは常に表示されると邪魔になる可能性があるので、適宜コメントアウト
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('問診票データをロードしました。')));
      } else {
        setState(() {
          _loadError = '指定された問診票データが見つかりません。';
          _isLoadingData = false;
        });
        print('QuestionnaireDisplayPage: Document not found for ID: $id');
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('指定された問診票データが見つかりません。')));
      }
    } on FirebaseException catch (e) {
      setState(() {
        _loadError = 'Firestoreエラー: ${e.code} - ${e.message}';
        _isLoadingData = false;
      });
      print(
        'QuestionnaireDisplayPage: Firestore ERROR: ${e.code} - ${e.message}',
      );
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Firestoreロード失敗: ${e.message}')));
    } catch (e) {
      setState(() {
        _loadError = '問診票データのロードに失敗しました: ${e.toString()}';
        _isLoadingData = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('問診票データのロードに失敗しました: ${e.toString()}')));
      print('QuestionnaireDisplayPage: UNEXPECTED LOAD ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      'QuestionnaireDisplayPage: build method called. isLoadingData: $_isLoadingData, loadError: $_loadError',
    );

    final loc = AppLocalizations.of(context)!;
    String displayUserName = _displayUserName ?? loc.notSelected;
    String displayUserHome = _displayUserHome ?? loc.notSelected;
    String displayUserGender = _displayUserGender ?? loc.notSelected;
    String displayUserTelNum = _displayUserTelNum ?? loc.notSelected;
    String displayUserDateOfBirth = _formatDateHumanReadable(
      _displayUserDateOfBirth,
    );
    String displayOnsetDay = _formatDateHumanReadable(_displaySelectedOnsetDay);

    String displaySymptom = _displaySymptom ?? loc.notSelected;
    String displayAffectedArea = _displayAffectedArea ?? loc.notSelected;
    String displaySufferLevel = _displaySufferLevel ?? loc.notSelected;
    String displayCause = _displayCause ?? loc.notSelected;

    List<String> displayOtherInfoItems =
        _displayOtherInformation?.split('; ') ?? [];

    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("MIECAL", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 75, 170, 248),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("MIECAL", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 75, 170, 248),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'エラー: $_loadError',
              style: const TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

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
        // QRコードから開かれるページなので、戻るボタンは不要な場合が多いですが、
        // 必要に応じて自動で表示させない（false）か、独自のボタンを設置してください。
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // このページにはスライドアップダウンは不要なので削除
          Expanded(
            flex: 1,
            child: Text(
              loc.questionnaireConfirmTitle, // 「問診票データ確認」など
              style: const TextStyle(color: Colors.black, fontSize: 22),
            ),
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
                            leading: const Icon(
                              Icons.sick,
                              color: Colors.blueGrey,
                            ),
                            title: Text(loc.symptom),
                            trailing: Text(
                              displaySymptom,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.healing,
                              color: Colors.blueGrey,
                            ),
                            title: Text(loc.affectedArea),
                            trailing: Text(
                              displayAffectedArea,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16),
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
                            trailing: Text(
                              displayCause,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16),
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
                                Text(
                                  loc.detailsNotEntered,
                                  style: const TextStyle(fontSize: 16),
                                ),
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
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
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
                  // このページにはQRコード作成ボタンは不要
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
