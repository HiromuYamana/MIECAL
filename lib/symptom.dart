import 'package:flutter/material.dart';
import 'package:miecal/affected_area.dart'; // AffectedAreaPage の定義があるファイル
import 'package:miecal/vertical_slide_page.dart'; // VerticalSlideRoute の定義があるファイル
import 'package:miecal/l10n/app_localizations.dart';

class SymptomPage extends StatefulWidget {
  final String? userName;
  final DateTime? userDateOfBirth;
  final String? userHome;
  final String? userGender;
  final String? userTelNum;
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea;
  final String? sufferLevel;
  final String? cause;
  final String? otherInformation;

  const SymptomPage({
    super.key,
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
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  final List<Map<String, String>> symptomItems = const [
    {'path': 'assets/images/symptom/bienn.png', 'key': 'symptomAllergy'},
    {'path': 'assets/images/symptom/fukutuu.png', 'key': 'symptomStomachache'},
    {'path': 'assets/images/symptom/gaishou.png', 'key': 'symptomWound'},
    {'path': 'assets/images/symptom/kossetu.png', 'key': 'symptomFracture'},
    {'path': 'assets/images/symptom/metabo.png', 'key': 'symptomMetabolic'},
    {'path': 'assets/images/symptom/seki.png', 'key': 'symptomCough'},
    {'path': 'assets/images/symptom/youtuu.png', 'key': 'symptomBackpain'},
    {'path': 'assets/images/symptom/darusa.png', 'key': 'symptomFatigue'},
    {'path': 'assets/images/symptom/netu.png', 'key': 'symptomFever'},
    {'path': 'assets/images/symptom/metabo.png', 'key': 'symptomSoreThroat'},
    {'path': 'assets/images/symptom/metabo.png', 'key': 'symptomNausea'},
    {'path': 'assets/images/symptom/metabo.png', 'key': 'symptomDizziness'},
    {'path': 'assets/images/symptom/metabo.png', 'key': 'symptomNumbness'},
    {'path': 'assets/images/symptom/metabo.png', 'key': 'symptomRash'},
    {'path': 'assets/images/symptom/metabo.png', 'key': 'symptomJointPain'},
    {'path': 'assets/images/symptom/metabo.png', 'key': 'symptomOther'},
  ];


  // 選択状態
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    // symptomItems の数に合わせて、全て未選択 (false) で初期化
    isSelected = List.filled(symptomItems.length, false);
  }

  String _getLocalizedSymptom(AppLocalizations loc, String key) {
    switch (key) {
      case 'symptomAllergy':
        return loc.symptomAllergy;
      case 'symptomStomachache':
        return loc.symptomStomachache;
      case 'symptomWound':
        return loc.symptomWound;
      case 'symptomFracture':
        return loc.symptomFracture;
      case 'symptomMetabolic':
        return loc.symptomMetabolic;
      case 'symptomCough':
        return loc.symptomCough;
      case 'symptomBackpain':
        return loc.symptomBackpain;
      case 'symptomFatigue':
        return loc.symptomFatigue;
      case 'symptomFever':
        return loc.symptomFever;
      case 'symptomSoreThroat':
        return loc.symptomSoreThroat;
      case 'symptomNausea':
        return loc.symptomNausea;
      case 'symptomDizziness':
        return loc.symptomDizziness;
      case 'symptomNumbness':
        return loc.symptomNumbness;
      case 'symptomRash':
        return loc.symptomRash;
      case 'symptomJointPain':
        return loc.symptomJointPain;
      case 'symptomOther':
        return loc.symptomOther;
      default:
        return '';
    }
  }

  // 選択された症状を日本語名でまとめるヘルパー関数
  String _getSelectedSymptomSummary() {
    final loc = AppLocalizations.of(context)!;
    List<String> selectedSymptoms = [];
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        final key = symptomItems[i]['key']!;
        selectedSymptoms.add(_getLocalizedSymptom(loc, key));
      }
    }
    return selectedSymptoms.isEmpty ? loc.notSelected : selectedSymptoms.join(', ');
  }


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MIECAL",
          style: TextStyle(
            color: Colors.white,        // 白文字
            fontWeight: FontWeight.bold, // 太字
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
            child:Container( 
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Center(
                child: Text(loc.symptomSelection, style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
              )
            ),
          ),
          Expanded(
            flex: 12,
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255), // グリッドの背景色
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: symptomItems.length, // symptomItemsの数を使用
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected[index] = !isSelected[index]; // 選択状態をトグル
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8), // 画像コンテナの余白
                          // width, heightはGridViewが自動調整するため削除
                          width: 1050,
                          // height: 1050,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected[index] // 選択状態に応じて枠線の色と太さを変更
                                      ? Colors.orange
                                      : Colors.transparent, // 未選択時は透明
                              width: isSelected[index] ? 4 : 1, // 未選択時は細い（見えない）
                            ),
                            borderRadius: BorderRadius.circular(8), // 角丸
                          ),
                          child: ClipRRect(
                            // 画像を角丸にクリップ
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              symptomItems[index]['path']!, // 画像パスを使用
                              fit: BoxFit.cover, // コンテナに合わせて画像をカバー表示
                            ),
                          ),
                        ),
                        if (isSelected[index])
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 252, 166, 7,).withValues(alpha: 0.3), 
                              borderRadius: BorderRadius.circular(8), // 角丸
                            ),
                          ),
                        // 画像の下に日本語名をテキストで表示
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black54, // テキストの背景を半透明にする
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: Text(
                              _getLocalizedSymptom(loc, symptomItems[index]['key']!), // ← 修正済み
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Material(
              color: Colors.blueGrey,
              child: InkWell(
                onTap: () {
                  final String selectedSymptom = _getSelectedSymptomSummary();
                  Navigator.push(
                    context,
                    VerticalSlideRoute(
                      page: AffectedAreaPage(
                        userName: widget.userName,
                        userDateOfBirth: widget.userDateOfBirth,
                        userHome: widget.userHome,
                        userGender: widget.userGender,
                        userTelNum: widget.userTelNum,
                        selectedOnsetDay: widget.selectedOnsetDay,
                        symptom: selectedSymptom,
                        affectedArea: widget.affectedArea,
                        sufferLevel: widget.sufferLevel,
                        cause: widget.cause,
                        otherInformation: widget.otherInformation,
                      ),
                    ),
                  );
                },
                child: SizedBox.expand(
                  child: Center(
                    child: const Icon(
                      Icons.expand_more,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
