import 'package:flutter/material.dart';
import 'package:miecal/affected_area.dart'; // AffectedAreaPage の定義があるファイル
import 'package:miecal/vertical_slide_page.dart'; // VerticalSlideRoute は GoRouter への移行で不要になる可能性あり
import 'package:go_router/go_router.dart'; // <-- 修正点: GoRouter をインポート

class SymptomPage extends StatefulWidget {
  final String? userName;
  final DateTime? userDateOfBirth;
  final String? userHome;
  final String? userGender;
  final String? userTelNum;
  final DateTime? selectedOnsetDay;
  final String? symptom; // このSymptomPageで選択される症状なので、ここはnull許容型
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
  // 修正点: 画像のパスを 'assets/assets/images/' で始めるように変更
  final List<Map<String, String>> symptomItems = const [
    {'path': 'assets/images/bienn.png', 'name': '鼻炎'},
    {'path': 'assets/images/fukutuu.png', 'name': '腹痛'},
    {'path': 'assets/images/gaishou.png', 'name': '外傷'},
    {'path': 'assets/images/kossetu.png', 'name': '骨折'},
    {'path': 'assets/images/metabo.png', 'name': 'メタボ'},
    {'path': 'assets/images/seki.png', 'name': '咳'},
    {'path': 'assets/images/youtuu.png', 'name': '腰痛'},

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
          // 修正点: 上部ヘッダー部分を Material + Column に再構築
          Expanded(
            flex: 2, // flex 値は必要に応じて調整
            child: Material(
              color: const Color.fromARGB(255, 207, 227, 230),
              child: Stack(
                // IconButton を左上、Text を中央に配置するため Stack を使用
                children: [
                  Padding(
                    // 安全領域のパディング
                    padding: EdgeInsets.only(top: topPadding, left: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 36,
                        ),
                        onPressed: () {
                          context.pop(); // GoRouter の pop を使用
                        },
                      ),
                    ),
                  ),
                  Center(
                    // タイトルを中央に
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '症状選択',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (widget.userName != null && widget.userName != '未入力')
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'ようこそ、${widget.userName}さん！',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 15, // 比率調整
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
                          // 修正点: width, height を削除
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
                              // 修正点: .withValues(alpha: 0.3) を .withOpacity(0.3) に変更
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
            flex: 2, // 比率調整
            child: Material(
              color: Colors.blueGrey,
              child: InkWell(
                onTap: () {
                  final String selectedSymptom =
                      _getSelectedSymptomSummary(); // 選択された症状を取得

                  // Nextボタンが押されたら、これまでのデータとこのページで選択した症状を
                  // AffectedAreaPageへ渡す
                  // 修正点: GoRouter の context.push を使用
                  context.push(
                    '/AffectedAreaPage', // main.dart で定義されたパス
                    extra: {
                      // GoRouter の extra プロパティでデータを渡す
                      'userName': widget.userName,
                      'userDateOfBirth': widget.userDateOfBirth,
                      'userHome': widget.userHome,
                      'userGender': widget.userGender,
                      'userTelNum': widget.userTelNum,
                      'selectedOnsetDay': widget.selectedOnsetDay,
                      'symptom': selectedSymptom, // このページで選択した症状
                      'affectedArea': widget.affectedArea,
                      'sufferLevel': widget.sufferLevel,
                      'cause': widget.cause,
                      'otherInformation': widget.otherInformation,
                    },
                  );
                },
                child: const SizedBox.expand(
                  child: Center(
                    child: Icon(
                      Icons.arrow_downward,
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
