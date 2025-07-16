// lib/other_information.dart の全体をこれで置き換える
import 'package:flutter/material.dart';
import 'package:miecal/questionnaire.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:go_router/go_router.dart'; // context.push のために必要

class OtherInformationPage extends StatefulWidget {
  // これまでのページから受け取る問診票データを定義します
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
  // 修正点: otherInformation フィールドの宣言を追加
  final String? otherInformation; // <-- この行が必須です

  const OtherInformationPage({
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
    this.otherInformation, // <-- コンストラクタ引数にも追加
  });

  @override
  // ignore: library_private_types_in_public_api
  State<OtherInformationPage> createState() => _OtherInformationPageState();
}

class _OtherInformationPageState extends State<OtherInformationPage> {
  // 各行で選択された項目のインデックスを保持 (0または1、未選択はnull)
  List<int?> selectedInRow = [null, null, null, null]; // 4項目に対応

  final List<Map<String, String>> imagePaths = [
    {'path': 'assets/images/sample_image1.png', 'name': '飲む'},
    {'path': 'assets/images/sample_image2.png', 'name': '飲まない'},
    {'path': 'assets/images/sample_image3.png', 'name': '吸う'},
    {'path': 'assets/images/sample_image4.png', 'name': '吸わない'},
    {'path': 'assets/images/sample_image5.png', 'name': 'あり'},
    {'path': 'assets/images/sample_image6.png', 'name': 'なし'},
    {'path': 'assets/images/sample_image7.png', 'name': 'はい'},
    {'path': 'assets/images/sample_image8.png', 'name': 'いいえ'},
  ];

  final List<String> labels = ['飲酒', '喫煙', 'お薬', '妊娠']; // <- 妊娠中 に修正済みを想定

  @override
  void initState() {
    super.initState();
    // 既存のotherInformationがあれば、selectedInRow を初期化するロジックをここに追加できる
    if (widget.otherInformation != null && widget.otherInformation != '未選択') {
      List<String> existingParts = widget.otherInformation!.split('; ');
      for (int i = 0; i < labels.length; i++) {
        String labelPrefix = '${labels[i]}: ';
        for (int j = 0; j < existingParts.length; j++) {
          if (existingParts[j].startsWith(labelPrefix)) {
            String value = existingParts[j].substring(labelPrefix.length);
            // value に基づいて colIndex を特定し selectedInRow[i] を設定
            // 例: (value == '飲む' || value == 'はい' など) ? 0 : ((value == '飲まない' || value == 'いいえ') ? 1 : null);
            break;
          }
        }
      }
    }
  }

  // 選択された情報を文字列としてまとめるヘルパー関数
  String _getOtherInformationSummary() {
    List<String> selectedSummaryParts = [];
    final loc = AppLocalizations.of(context)!;
    for (int i = 0; i < selectedInRow.length; i++) {
      if (selectedInRow[i] != null) {
        int imageIndex = i * 2 + selectedInRow[i]!;
        String selectedOptionName = imagePaths[imageIndex]['name']!;
        selectedSummaryParts.add('${labels[i]}: $selectedOptionName');
      } else {
        // 未選択の場合も情報として含める
        selectedSummaryParts.add('${labels[i]}:${loc.notSelected}');
      }
    }
    return selectedSummaryParts.join('; ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
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
            flex:1,
            child:Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Center(
                child:Text(
                  'その他情報',
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 22
                  ),
                ),
              ) 
            ),
          ),

          Expanded(
            flex: 12,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (rowIndex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 120, 120, 120),
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: List.generate(2, (colIndex) {
                              int index = rowIndex * 2 + colIndex;
                              bool isSelected =
                                  selectedInRow[rowIndex] == colIndex;
                              if (index >= imagePaths.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(100, 100),
                                    backgroundColor:
                                        isSelected
                                            ? const Color.fromARGB(
                                              255,
                                              225,
                                              171,
                                              85,
                                            ) // 選択時
                                            : const Color.fromARGB(255, 255, 255, 255), // 未選択時
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedInRow[rowIndex] =
                                          isSelected ? null : colIndex;
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Image.asset(
                                          imagePaths[index]['path']!,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          labels[rowIndex],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Material(
              color: Colors.blueGrey,
              child: InkWell(
                onTap: () {
                  print(
                    'OtherInformationPage: Next button tapped. Preparing to navigate.',
                  );
                  final String otherInformationSummary =
                      _getOtherInformationSummary();
                  final Map<String, dynamic> dataToPass = {
                    'userName': widget.userName,
                    'userDateOfBirth': widget.userDateOfBirth,
                    'userHome': widget.userHome,
                    'userGender': widget.userGender,
                    'userTelNum': widget.userTelNum,
                    'selectedOnsetDay': widget.selectedOnsetDay,
                    'symptom': widget.symptom,
                    'affectedArea': widget.affectedArea,
                    'sufferLevel': widget.sufferLevel,
                    'cause': widget.cause,
                    'otherInformation': otherInformationSummary,
                  };
                  print(
                    'OtherInformationPage: Passing extra data: $dataToPass',
                  ); // これを確認
                  context.push('/QuestionnairePage', extra: dataToPass);
                },
                child: SizedBox(
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
