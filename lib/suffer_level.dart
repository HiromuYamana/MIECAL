import 'package:flutter/material.dart';
import 'package:miecal/couse.dart';
import 'package:miecal/vertical_slide_page.dart';

class SufferLevelPage extends StatefulWidget {
  // これまでのページから受け取る問診票データを定義します
  final DateTime? selectedOnsetDay; // DatePageから受け取る発症日
  final String? symptom; // SymptomPageから受け取る症状
  final String? affectedArea; // AffectedAreaPageから受け取る患部

  const SufferLevelPage({
    super.key,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SufferLevelPageState createState() => _SufferLevelPageState();
}

class _SufferLevelPageState extends State<SufferLevelPage> {
  double severity = 0; // スライダーの現在値

  // スライダーの値に基づいて表情画像のインデックスを計算
  int getSeverityIndex(double value) {
    return ((value) / 2).floor().clamp(
      0,
      5,
    ); // 0-10の範囲を6つの表情にマッピング (0-1.99 -> 0, 2-3.99 -> 1, ...)
  }

  // 表情画像のパスリスト
  final List<String> faceImages = [
    'assets/images/face_very_happy.png', // 0: 0.0-1.99
    'assets/images/face_happy.png', // 1: 2.0-3.99
    'assets/images/face_neutral.png', // 2: 4.0-5.99
    'assets/images/face_sad.png', // 3: 6.0-7.99
    'assets/images/face_very_sad.png', // 4: 8.0-9.99
    'assets/images/face_danger.png', // 5: 10.0
  ];

  // 選択された程度を文字列としてまとめるヘルパー関数
  // スライダーのseverity値を直接文字列化
  String _getSufferLevelSummary() {
    // 例: "程度: 5.0" のように文字列で渡す
    return severity.toStringAsFixed(0); // 小数点以下を切り捨てて整数として渡す
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = getSeverityIndex(severity); // 現在のスライダー値に対応する表情インデックス

    // 画面の安全な領域の上部パディングを取得 (ノッチなど)
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1, // 上部のヘッダー部分の割合
            child: Container(
              color: const Color.fromARGB(255, 207, 227, 230), // 背景色
              padding: EdgeInsets.only(top: topPadding), // 上部パディング
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 子要素のサイズに合わせる
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
                      '程度の選択',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // タイトル追加
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7, // スライダーと表情画像の領域の割合
            child: Container(
              decoration:
                  LinearGradient(
                    // 背景グラデーション
                    colors: [Colors.lightBlue.shade100, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).asBoxDecoration(), // LinearGradientをBoxDecorationとして使うヘルパー
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      faceImages[selectedIndex], // スライダー値に応じて表情画像を表示
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 30), // 画像とスライダーの間のスペース
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 8.0, // トラックの高さ
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 14.0, // 親指の半径
                        ),
                        trackShape: GradientSliderTrackShape(
                          // カスタムトラックシェイプ
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.yellow, Colors.red],
                          ),
                        ),
                      ),
                      child: Slider(
                        value: severity, // スライダーの現在値
                        min: 0, // 最小値
                        max: 10, // 最大値
                        divisions: 10, // 分割数 (0から10まで11段階)
                        label: severity.toStringAsFixed(0), // スライダーの上に表示されるラベル
                        onChanged: (value) {
                          setState(() {
                            severity = value; // スライダー値が変更されたら状態を更新
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1, // 下部のナビゲーションボタン部分の割合
            child: Container(
              color: Colors.blueGrey, // 背景色
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_downward,
                    size: 50,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final String sufferLevelSummary =
                        _getSufferLevelSummary(); // 選択された程度を取得

                    // Nextボタンが押されたら、これまでのデータとこのページで選択したデータを
                    // CousePageへ渡す
                    Navigator.push(
                      context,
                      VerticalSlideRoute(
                        page: CousePage(
                          selectedOnsetDay:
                              widget.selectedOnsetDay, // DatePageから
                          symptom: widget.symptom, // SymptomPageから
                          affectedArea:
                              widget.affectedArea, // AffectedAreaPageから
                          sufferLevel:
                              sufferLevelSummary, // このSufferLevelPageから
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

// LinearGradient を BoxDecoration に直接渡せるようにする拡張機能 (Option)
extension _LinearGradientAsBoxDecoration on LinearGradient {
  BoxDecoration asBoxDecoration() {
    return BoxDecoration(gradient: this);
  }
}

// GradientSliderTrackShape は変更なし (以前のコードからそのまま)
class GradientSliderTrackShape extends SliderTrackShape {
  final LinearGradient gradient;

  GradientSliderTrackShape({required this.gradient});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final double trackLeft =
        offset.dx +
        sliderTheme.overlayShape!
                .getPreferredSize(isEnabled, isDiscrete)
                .width /
            2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth =
        parentBox.size.width -
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint paint =
        Paint()
          ..shader = gradient.createShader(trackRect)
          ..style = PaintingStyle.fill;

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(4)), // const を追加
      paint,
    );
  }
}
