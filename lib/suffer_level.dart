import 'package:flutter/material.dart';
import 'package:miecal/couse.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart'; // context.pop/push のために追加

class SufferLevelPage extends StatefulWidget {
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
  final String? otherInformation;

  const SufferLevelPage({
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

  // 修正点: 表情画像のパスを 'assets/assets/images/' で始めるように変更
  final List<String> faceImages = [
    'assets/images/face_very_happy.png', // 0: 0.0-1.99
    'assets/images/face_happy.png', // 1: 2.0-3.99
    'assets/images/face_neutral.png', // 2: 4.0-5.99
    'assets/images/face_sad.png', // 3: 6.0-7.99
    'assets/images/face_very_sad.png', // 4: 8.0-9.99
    'assets/images/face_danger.png', // 5: 10.0
  ];

  // 選択された程度を文字列としてまとめるヘルパー関数
  String _getSufferLevelSummary() {
    return severity.toStringAsFixed(0); // 小数点以下を切り捨てて整数として渡す
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = getSeverityIndex(severity); // 現在のスライダー値に対応する表情インデックス

    final double topPadding = MediaQuery.of(context).padding.top;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3, // 上部のヘッダー部分の割合
            child: Container(
              color: const Color.fromARGB(255, 218, 246, 250), // 背景色
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
                        context.pop(); // GoRouter の pop を使用
                      },
                    ),
                    Text(
                      loc.choosingTheLevelOfPain,
                      style: const TextStyle(
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
            flex: 15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  faceImages[selectedIndex], // スライダー値に応じて表情画像を表示
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 30), // 画像とスライダーの間のスペース
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 8.0, // トラックの高さ
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 14.0, // 親指の半径
                    ),
                    trackShape: GradientSliderTrackShape(
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.yellow, Colors.red],
                      ),
                    ),
                  ),
                  child: Slider(
                    value: severity,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: severity.toStringAsFixed(0),
                    onChanged: (value) {
                      setState(() {
                        severity = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2, // 下部のナビゲーションボタン部分の割合
            child: Material(
              color: Colors.blueGrey, // 背景色
              child: InkWell(
                onTap: () {
                  final String sufferLevelSummary =
                      _getSufferLevelSummary(); // 選択された程度を取得

                  // 修正点: GoRouter の context.push を使用
                  context.push(
                    '/CousePage', // main.dart で定義されたパス
                    extra: {
                      // GoRouter の extra プロパティでデータを渡す
                      'userName': widget.userName,
                      'userDateOfBirth': widget.userDateOfBirth,
                      'userHome': widget.userHome,
                      'userGender': widget.userGender,
                      'userTelNum': widget.userTelNum,
                      'selectedOnsetDay': widget.selectedOnsetDay,
                      'symptom': widget.symptom,
                      'affectedArea': widget.affectedArea,
                      'sufferLevel': sufferLevelSummary, // このページで選択した程度
                      'cause': widget.cause,
                      'otherInformation': widget.otherInformation,
                    },
                  );
                },
                child: const SizedBox.expand(
                  // SizedBox.expand で InkWell のタップ領域を広げる
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

// 修正点: 不要な _LinearGradientAsBoxDecoration 拡張を削除
// extension _LinearGradientAsBoxDecoration on LinearGradient {} // <- この拡張が使われていないため削除

// GradientSliderTrackShape は変更なし
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
      RRect.fromRectAndRadius(trackRect, const Radius.circular(4)),
      paint,
    );
  }
}
