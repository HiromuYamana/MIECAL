import 'package:flutter/material.dart';
import 'package:miecal/affected_area.dart'; // AffectedAreaPage の定義があるファイル
import 'package:miecal/vertical_slide_page.dart'; // VerticalSlideRoute の定義があるファイル

// SymptomPage は StatefulWidget に変更済みのはずです
class SymptomPage extends StatefulWidget {
  // SymptomPage は問診票データの最初の方のページなので、
  // 現時点では前のページから受け取るデータは特にないはずです。
  const SymptomPage({super.key});

  @override
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  // 画像のパスと対応する日本語名をペアで保持するリスト
  final List<Map<String, String>> symptomItems = const [
    {'path': 'assets/images/bienn.png', 'name': '鼻炎'},
    {'path': 'assets/images/fukutuu.png', 'name': '腹痛'},
    {'path': 'assets/images/gaishou.png', 'name': '外傷'},
    {'path': 'assets/images/kossetu.png', 'name': '骨折'},
    {'path': 'assets/images/metabo.png', 'name': 'メタボ'},
    {'path': 'assets/images/seki.png', 'name': '咳'},
    {'path': 'assets/images/youtuu.png', 'name': '腰痛'},

    // 以下はダミー画像と仮定し、対応する日本語名を追加
    {'path': 'assets/images/metabo.png', 'name': 'だるさ'},
    {'path': 'assets/images/metabo.png', 'name': '熱'},
    {'path': 'assets/images/metabo.png', 'name': 'のどの痛み'},
    {'path': 'assets/images/metabo.png', 'name': '吐き気'},

    {'path': 'assets/images/metabo.png', 'name': 'めまい'},
    {'path': 'assets/images/metabo.png', 'name': 'しびれ'},

    {'path': 'assets/images/metabo.png', 'name': '湿疹'},
    {'path': 'assets/images/metabo.png', 'name': '関節痛'},
    {'path': 'assets/images/metabo.png', 'name': 'その他'},
  ];

  // 選択状態
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    // symptomItems の数に合わせて、全て未選択 (false) で初期化
    isSelected = List.filled(symptomItems.length, false);
  }

  // 選択された症状を日本語名でまとめるヘルパー関数
  String _getSelectedSymptomSummary() {
    List<String> selectedSymptoms = [];
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        selectedSymptoms.add(symptomItems[i]['name']!); // 日本語名を取得
      }
    }
    return selectedSymptoms.isEmpty ? '未選択' : selectedSymptoms.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 207, 227, 230),
              padding: EdgeInsets.only(top: topPadding),
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
                    const Text(
                      '症状選択',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // タイトルを大きく
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              color: const Color.fromARGB(255, 218, 246, 250), // グリッドの背景色
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
                          // width: 1050,
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
                              color: const Color.fromARGB(
                                255,
                                252,
                                166,
                                7,
                              ).withOpacity(0.3), // 半透明のオーバーレイ
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
                              symptomItems[index]['name']!, // 日本語名を表示
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis, // 長すぎる場合は省略
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
                    final String selectedSymptom =
                        _getSelectedSymptomSummary(); // 選択された症状を取得

                    // Nextボタンが押されたら、このページで選択した症状を
                    // AffectedAreaPageへ渡す
                    Navigator.push(
                      context,
                      VerticalSlideRoute(
                        page: AffectedAreaPage(
                          symptom: selectedSymptom, // このSymptomPageで選択した症状
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
