import 'package:flutter/material.dart';
import 'package:miecal/other_information.dart';
import 'package:miecal/vertical_slide_page.dart';

class CousePage extends StatefulWidget {
  // これまでのページから受け取る問診票データを定義します
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea;
  final String? sufferLevel;

  const CousePage({
    super.key,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea,
    this.sufferLevel,
  });

  @override
  State<CousePage> createState() => _CousePageState();
}

class _CousePageState extends State<CousePage> {
  // 画像のパスと対応する日本語名をペアで保持するリスト
  // Mapのキーが画像パス、値が日本語名
  final List<Map<String, String>> couseItems = const [
    {'path': 'assets/images/ziko.png', 'name': '事故'},
    {'path': 'assets/images/tennraku.png', 'name': '転落'},
    {'path': 'assets/images/fukutuu.png', 'name': '腹痛'},
    {'path': 'assets/images/kossetu.png', 'name': '骨折'},
    {'path': 'assets/images/metabo.png', 'name': 'メタボ'}, 
    // 他の原因があればここに追加
  ];

  // 選択状態
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    // couseItems の数に合わせて、全て未選択 (false) で初期化
    isSelected = List.filled(couseItems.length, false);
  }

  // 選択された原因を日本語名でまとめるヘルパー関数
  String _getSelectedCauseSummary() {
    List<String> selectedCauseNames = [];
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        selectedCauseNames.add(couseItems[i]['name']!); // 日本語名を取得
      }
    }
    return selectedCauseNames.isEmpty ? '未選択' : selectedCauseNames.join(', ');
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
                        Navigator.pop(context);
                      },
                    ),
                    const Text('原因', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              color: const Color.fromARGB(255, 218, 246, 250),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: couseItems.length, // couseItemsの数を使用
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected[index] = !isSelected[index];
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          // width, heightはGridViewが自動調整するため削除または調整
                          width: 1050,
                          // height: 1050,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected[index]
                                      ? Colors.orange
                                      : Colors.transparent,
                              width: isSelected[index] ? 4 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              couseItems[index]['path']!, // 画像パスを使用
                              fit: BoxFit.cover,
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
                              ).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
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
                              couseItems[index]['name']!, // 日本語名を表示
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
            child: Material(
              color: Colors.blueGrey,
              child: InkWell(
                onTap:(){
                  final String selectedCause =
                        _getSelectedCauseSummary(); // 日本語名で原因を取得

                  Navigator.push(
                    context,
                    VerticalSlideRoute(
                      page: OtherInformationPage(
                        selectedOnsetDay: widget.selectedOnsetDay,
                        symptom: widget.symptom,
                        affectedArea: widget.affectedArea,
                        sufferLevel: widget.sufferLevel,
                        cause: selectedCause, // ここで日本語名を渡す
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  child:Center(
                    child: const Icon(
                    Icons.arrow_downward,
                    size: 50,
                    color: Colors.white,
                  ),)
                  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
