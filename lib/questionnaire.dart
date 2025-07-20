import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth を使うために追加
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore を使うために追加
import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/qr.dart';
import 'package:miecal/l10n/app_localizations.dart';
import 'package:intl/intl.dart'; // 多言語日付フォーマット用

class QuestionnairePage extends StatefulWidget {
  // 修正点: isFromQrScanner フラグを追加
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
    this.isFromQrScanner = false, // <-- 追加: デフォルトは false
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

  Future<void> _loadQuestionnaireDataById(String id) async {
    print('QuestionnairePage: _loadQuestionnaireDataById START. ID: $id');
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
        print('QuestionnairePage: Firestore Doc Exists: ${doc.exists}');
        print('QuestionnairePage: Raw Firestore Data: $data');

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('問診票データをロードしました。')));
      } else {
        setState(() {
          _loadError = '指定された問診票データが見つかりません。';
          _isLoadingData = false;
        });
        print('QuestionnairePage: Document not found for ID: $id');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('指定された問診票データが見つかりません。')));
      }
    } on FirebaseException catch (e) {
      setState(() {
        _loadError = 'Firestoreエラー: ${e.code} - ${e.message}';
        _isLoadingData = false;
      });
      print('QuestionnairePage: Firestore ERROR: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Firestoreロード失敗: ${e.message}')));
    } catch (e) {
      setState(() {
        _loadError = '問診票データのロードに失敗しました: ${e.toString()}';
        _isLoadingData = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('問診票データのロードに失敗しました: ${e.toString()}')),
      );
      print('QuestionnairePage: UNEXPECTED LOAD ERROR: $e');
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
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  child: Center(
                    child: const Icon(
                      Icons.expand_less,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              loc.questionnaireConfirmTitle,
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
        ],
      ),
    );
  }
}
