import 'package:flutter/material.dart';
import 'package:miecal/questionnaire.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/l10n/app_localizations.dart';

class OtherInformationPage extends StatefulWidget {
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
    this.otherInformation,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OtherInformationPageState createState() => _OtherInformationPageState();
}

class _OtherInformationPageState extends State<OtherInformationPage> {
  // 各行で選択された項目のインデックスを保持 (0または1、未選択はnull)
  List<int?> selectedInRow = [null, null, null, null]; // 4項目に対応

  final List<Map<String, String>> imagePaths = [
    {'path': 'assets/sample_image1.png', 'name': '飲む'},
    {'path': 'assets/sample_image2.png', 'name': '飲まない'},
    {'path': 'assets/sample_image3.png', 'name': '吸う'},
    {'path': 'assets/sample_image4.png', 'name': '吸わない'},
    {'path': 'assets/sample_image5.png', 'name': 'あり'},
    {'path': 'assets/sample_image6.png', 'name': 'なし'},
    {'path': 'assets/sample_image7.png', 'name': 'はい'},
    {'path': 'assets/sample_image8.png', 'name': 'いいえ'},
  ];

  final List<String> labels = ['飲酒', '喫煙', 'お薬', '妊娠']; // 各行のラベル

  @override
  void initState() {
    super.initState();
    // ここで必要であれば、初期選択状態を復元することも可能
  }

  // 選択された情報を文字列としてまとめるヘルパー関数
  String _getOtherInformationSummary() {
    List<String> selectedSummaryParts = [];
    final loc = AppLocalizations.of(context)!;
    for (int i = 0; i < selectedInRow.length; i++) {
      if (selectedInRow[i] != null) {
        // 選択された場合
        int imageIndex = i * 2 + selectedInRow[i]!;
        String selectedOptionName = imagePaths[imageIndex]['name']!;
        selectedSummaryParts.add('${labels[i]}: $selectedOptionName');
      } else {
        // 未選択の場合も情報として含める
        selectedSummaryParts.add('${labels[i]}:${loc.notSelected}');
      }
    }
    // 全ての行の情報を含めて結合
    return selectedSummaryParts.join('; '); // 各項目をセミコロンとスペースで区切る
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
                    Icons.arrow_upward,
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
                  // 4行に対応
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
                                    fixedSize: const Size(
                                      100,
                                      100,
                                    ), // ボタンの固定サイズ
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
                                      borderRadius: BorderRadius.circular(
                                        16,
                                      ), // ボタンの角丸
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
                  final String otherInformationSummary =
                      _getOtherInformationSummary();

                  // これまでのページから受け取ったデータと、このページで選択した情報をまとめて渡す
                  Navigator.push(
                    context,
                    VerticalSlideRoute(
                      page: QuestionnairePage(
                        userName: widget.userName,
                        userDateOfBirth: widget.userDateOfBirth,
                        userHome: widget.userHome,
                        userGender: widget.userGender,
                        userTelNum: widget.userTelNum,
                        selectedOnsetDay: widget.selectedOnsetDay,
                        symptom: widget.symptom,
                        affectedArea: widget.affectedArea,
                        sufferLevel: widget.sufferLevel,
                        cause: widget.cause,
                        otherInformation: otherInformationSummary,
                      ),
                    ),
                  );
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
