import 'package:flutter/material.dart';
import 'package:miecal/questionnaire.dart';
import 'package:miecal/vertical_slide_page.dart';

class OtherInformationPage extends StatefulWidget {
  // これまでのページから受け取る問診票データを定義します
  // 例: 発症日、症状、患部、程度、原因など
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea;
  final String? sufferLevel;
  final String? cause;

  const OtherInformationPage({
    super.key,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea,
    this.sufferLevel,
    this.cause,
  });

  @override
  _OtherInformationPageState createState() => _OtherInformationPageState();
}

class _OtherInformationPageState extends State<OtherInformationPage> {
  // 各行で選択された項目のインデックスを保持 (0または1、未選択はnull)
  List<int?> selectedInRow = [null, null, null, null];

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

  final List<String> labels = ['飲酒', '喫煙', 'お薬', '妊娠中']; // 各行のラベル

  @override
  void initState() {
    super.initState();
    // ここで必要であれば、初期選択状態を復元することも可能
  }

  // 選択された情報を文字列としてまとめるヘルパー関数
  String _getOtherInformationSummary() {
    List<String> selectedLabels = [];
    for (int i = 0; i < selectedInRow.length; i++) {
      if (selectedInRow[i] != null) {
        // 例: 「a: sample_image1」のような形式で追加
        int imageIndex = i * 2 + selectedInRow[i]!;
        // images_Couseには画像パスが入っているため、適宜表示名を調整
        String selectedImageName = imagePaths[imageIndex]['name']!;
        selectedLabels.add('${labels[i]}: $selectedImageName');
      }
    }
    return selectedLabels.isEmpty ? 'なし' : selectedLabels.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 246, 250), // 背景色
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 207, 227, 230),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // 前の画面に戻る
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Center(
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
                            color: Colors.white,
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
                              int index =
                                  rowIndex * 2 + colIndex; // imagePaths のインデックス
                              bool isSelected =
                                  selectedInRow[rowIndex] == colIndex;

                              // 画像パスの範囲チェック
                              if (index >= imagePaths.length) {
                                // 存在しないインデックスの場合のハンドリング
                                return const SizedBox.shrink(); // 何も表示しない
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
                                            : Colors.grey[300], // 未選択時
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        16,
                                      ), // ボタンの角丸
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      // 同じボタンをもう一度押すと選択解除
                                      selectedInRow[rowIndex] =
                                          isSelected ? null : colIndex;
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80, // 画像サイズを少し小さく
                                        height: 80, // 画像サイズを少し小さく
                                        child: Image.asset(
                                          imagePaths[index]['path']!,
                                          fit: BoxFit.contain, // 画像のフィット方法
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
                          labels[rowIndex], // 各行のラベル
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          // 次へボタン
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blueGrey,
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_downward,
                    size: 50,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final String otherInformationSummary =
                        _getOtherInformationSummary();

                    // これまでのページから受け取ったデータと、このページで選択した情報をまとめて渡す
                    Navigator.push(
                      context,
                      VerticalSlideRoute(
                        page: QuestionnairePage(
                          selectedOnsetDay:
                              widget.selectedOnsetDay, // DatePageから
                          symptom: widget.symptom, // SymptomPageから
                          affectedArea:
                              widget.affectedArea, // AffectedAreaPageから
                          sufferLevel: widget.sufferLevel, // SufferLevelPageから
                          cause: widget.cause, // CousePageから
                          otherInformation:
                              otherInformationSummary, // このOtherInformationPageから
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
