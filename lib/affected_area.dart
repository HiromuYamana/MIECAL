import 'package:flutter/material.dart';
import 'dart:ui' as ui; // ui.Image, ui.Codec など
import 'package:flutter/services.dart'; // rootBundle
import 'package:image/image.dart' as img; // img.Image, img.decodeImage など
import 'package:miecal/table_calendar.dart'; // DatePage のインポート
import 'package:miecal/vertical_slide_page.dart'; // VerticalSlideRoute のインポート
import 'package:miecal/l10n/app_localizations.dart'; // AppLocalizations のため
import 'package:go_router/go_router.dart'; // context.pop/push のため
import 'dart:async'; // Completer のため
import 'package:flutter/foundation.dart'; // compute のため
import 'dart:typed_data'; // Uint8List のため

class AffectedAreaPage extends StatefulWidget {
  final String? userName;
  final DateTime? userDateOfBirth;
  final String? userHome;
  final String? userGender;
  final String? userTelNum;
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea; // ここは AffectedAreaPage で選択される
  final String? sufferLevel;
  final String? cause;
  final String? otherInformation;

  const AffectedAreaPage({
    super.key,
    this.userName,
    this.userDateOfBirth,
    this.userHome,
    this.userGender,
    this.userTelNum,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea, // 既存データも受け取りたい場合のみ、このページで変更
    this.sufferLevel,
    this.cause,
    this.otherInformation,
  });

  @override
  State<AffectedAreaPage> createState() => _AffectedAreaPageState();
}

class _AffectedAreaPageState extends State<AffectedAreaPage> {
  ui.Image? _maskImage; // 背景の人間アウトライン画像のui.Image版（ロード用）
  img.Image? _rawMaskImage; // 背景の人間アウトライン画像のimg.Image版（ピクセル処理用）
  final GlobalKey _imageKey = GlobalKey(); // 人体アウトライン画像のキー

  // colorToPart マッピング
  final Map<Color, String> _colorToPartMap = {
    const Color.fromARGB(255, 255, 0, 0): '顔',
    const Color.fromARGB(255, 0, 255, 0): '首(前)',
    const Color.fromARGB(255, 0, 0, 255): '胸',
    const Color.fromARGB(255, 255, 255, 0): '腹',
    const Color.fromARGB(255, 255, 0, 255): '股',
    const Color.fromARGB(255, 0, 255, 255): '右太もも(前)',
    const Color.fromARGB(255, 128, 255, 255): '右ふくらはぎ(前)',
    const Color.fromARGB(255, 128, 128, 255): '右足',
    const Color.fromARGB(255, 128, 0, 255): '左太もも(前)',
    const Color.fromARGB(255, 128, 255, 128): '左ふくらはぎ(前)',
    const Color.fromARGB(255, 128, 255, 0): '左足',
    const Color.fromARGB(255, 128, 0, 0): '右肩(前)',
    const Color.fromARGB(255, 255, 128, 255): '右上腕(前)',
    const Color.fromARGB(255, 255, 128, 128): '右前腕(前)',
    const Color.fromARGB(255, 255, 128, 0): '右手',
    const Color.fromARGB(255, 0, 128, 255): '左肩(前)',
    const Color.fromARGB(255, 0, 128, 128): '左上腕(前)',
    const Color.fromARGB(255, 0, 128, 0): '左前腕(前)',
    const Color.fromARGB(255, 0, 0, 128): '左手',
    const Color.fromARGB(255, 64, 255, 255): '頭頂部',
    const Color.fromARGB(255, 255, 64, 255): '首(後)',
    const Color.fromARGB(255, 255, 255, 64): '背中',
    const Color.fromARGB(255, 255, 64, 64): '臀部',
    const Color.fromARGB(255, 64, 255, 64): '右太もも(後)',
    const Color.fromARGB(255, 64, 64, 255): '右ふくらはぎ(後)',
    const Color.fromARGB(255, 255, 128, 64): '右足裏',
    const Color.fromARGB(255, 255, 64, 128): '左太もも(後)',
    const Color.fromARGB(255, 128, 255, 64): '左ふくらはぎ(後)',
    const Color.fromARGB(255, 128, 64, 255): '左足裏',
    const Color.fromARGB(255, 64, 255, 128): '左肩(後)',
    const Color.fromARGB(255, 64, 128, 255): '左上腕(後)',
    const Color.fromARGB(255, 255, 64, 0): '左前腕(後)',
    const Color.fromARGB(255, 255, 0, 64): '左手甲',
    const Color.fromARGB(255, 64, 255, 0): '右肩(後)',
    const Color.fromARGB(255, 64, 0, 255): '右上腕(後)',
    const Color.fromARGB(255, 0, 255, 64): '右前腕(後)',
    const Color.fromARGB(255, 0, 64, 255): '右手甲',
  };

  final Set<Color> _selectedColors = {}; // 選択されたピクセルカラーのセット
  ui.Image? _highlightedOverlayImage; // 生成されたハイライトオーバーレイ画像 (ui.Image)
  Completer<void>? _imageGenerationCompleter; // 画像生成処理の重複を防ぐためのCompleter
  bool _isLoadingData = true; // <-- 修正点: この変数を正しく宣言
  String? _loadError; // <-- 修正点: この変数を正しく宣言

  @override
  void initState() {
    super.initState();
    _loadMaskImage()
        .then((_) {
          _generateHighlightedImage(); // 画像ロード後に初期ハイライト画像を生成
          setState(() {
            _isLoadingData = false; // 初期ロード完了
          });
        })
        .catchError((e) {
          setState(() {
            _isLoadingData = false;
            _loadError = '初期画像のロードに失敗しました: ${e.toString()}';
          });
          print("初期画像ロードエラー: $e");
        });
  }

  // アセットからマスク画像をロード
  Future<void> _loadMaskImage() async {
    try {
      // 修正点: 画像パスを 'assets/assets/' で始めるように変更
      final byteData = await rootBundle.load('assets/body_mask.png');
      final buffer = byteData.buffer.asUint8List();
      final rawImage = img.decodeImage(buffer)!;

      final codec = await ui.instantiateImageCodec(buffer);
      final frame = await codec.getNextFrame();

    setState(() {
      _rawMaskImage = rawImage;
      _maskImage = frame.image;
    });

    for (int y = 0; y < _rawMaskImage!.height; y++) {
      for (int x = 0; x < _rawMaskImage!.width; x++) {
        final pixel = _rawMaskImage!.getPixel(x, y);
        final color = Color.fromARGB(pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
        if (localizedColorToPart.containsKey(color)) {
          _colorPixelCache
              .putIfAbsent(color, () => [])
              .add(Offset(x.toDouble(), y.toDouble()));
        }
      }
    }
  }

  // 画像がタップされた時の処理
  void _onTap(TapUpDetails details) {
    if (_maskImage == null || _rawMaskImage == null) return;

    final RenderBox box =
        _imageKey.currentContext!.findRenderObject() as RenderBox;
    final Size widgetSize = box.size;
    final Offset localPos = box.globalToLocal(details.globalPosition);

    final double imageAspect = _rawMaskImage!.width / _rawMaskImage!.height;
    final double widgetAspect = widgetSize.width / widgetSize.height;

    double displayWidth, displayHeight;
    if (widgetAspect > imageAspect) {
      displayHeight = widgetSize.height;
      displayWidth = displayHeight * imageAspect;
    } else {
      displayWidth = widgetSize.width;
      displayHeight = displayWidth / imageAspect;
    }

    final double dx = (widgetSize.width - displayWidth) / 2;
    final double dy = (widgetSize.height - displayHeight) / 2;

    final double xInImage =
        ((localPos.dx - dx) / displayWidth) * _rawMaskImage!.width;
    final double yInImage =
        ((localPos.dy - dy) / displayHeight) * _rawMaskImage!.height;

    final int x = xInImage.toInt();
    final int y = yInImage.toInt();

    if (x < 0 ||
        y < 0 ||
        x >= _rawMaskImage!.width ||
        y >= _rawMaskImage!.height) {
      return;
    }

    final pixel = _rawMaskImage!.getPixel(x, y);
    final pixelColor = Color.fromARGB(pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());

    if (_colorToPartMap.containsKey(pixelColor)) {
      setState(() {
        if (_selectedColors.contains(pixelColor)) {
          _selectedColors.remove(pixelColor);
        } else {
          _selectedColors.add(pixelColor);
        }
        _generateHighlightedImage();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('選択中の患部: ${getSelectedPartsSummary()}'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('対応する患部が見つかりません。透明な部分をタップした可能性があります。'),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  // 選択された患部名をカンマ区切りの文字列で取得
  String getSelectedPartsSummary() {
    if (_selectedColors.isEmpty) {
      return AppLocalizations.of(context)!.notSelected;
    }
    final List<String> parts = [];
    for (final color in _selectedColors) {
      final partName = _colorToPartMap[color];
      if (partName != null) {
        parts.add(partName);
      }
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // 背景色
        appBar: AppBar(
        title: const Text(
          "MIECAL",
          style: TextStyle(
            color: Colors.white, // 白文字
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
          // 上部ヘッダー部分を Material + Column に再構築
          Expanded(
            flex: 1,
            child: Material(
              color: const Color.fromARGB(255, 207, 227, 230),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: topPadding, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 36,
                        ),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                  ),
                  Text(
                    loc.affectedAreaSelection,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '選択中: ${getSelectedPartsSummary()}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child:
                _maskImage == null ||
                        _isLoadingData // ロード中または画像がない場合はインジケーター
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                      color: Colors.transparent,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return GestureDetector(
                            onTapUp: _onTap,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    'assets/human_outline.png', // <-- 修正: パスを二重にする
                                    key: _imageKey,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                if (_highlightedOverlayImage != null)
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: SimpleImagePainter(
                                        image: _highlightedOverlayImage!,
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
                  final String selectedAffectedArea = getSelectedPartsSummary();

                  if (_selectedColors.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('患部を選択してください．'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }

                  context.push(
                    '/DatePage',
                    extra: {
                      'userName': widget.userName,
                      'userDateOfBirth': widget.userDateOfBirth,
                      'userHome': widget.userHome,
                      'userGender': widget.userGender,
                      'userTelNum': widget.userTelNum,
                      'selectedOnsetDay': widget.selectedOnsetDay,
                      'symptom': widget.symptom,
                      'affectedArea': selectedAffectedArea,
                      'sufferLevel': widget.sufferLevel,
                      'cause': widget.cause,
                      'otherInformation': widget.otherInformation,
                    },
                  );
                },
                child: const SizedBox.expand(
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

// SimpleImagePainter の定義 (AffectedAreaPageと同じファイルにある想定)
class SimpleImagePainter extends CustomPainter {
  final ui.Image image; // 描画する ui.Image (事前に生成されたハイライト画像)

  SimpleImagePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    // 描画元の画像全体を表すRect (ui.Image の全範囲)
    final Rect src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    // BoxFit.contain を使って、描画元の画像サイズと描画先のキャンバスサイズから、
    // 画像がキャンバス内でどのようにフィットするかを計算します。
    final FittedSizes fittedSizes = applyBoxFit(
      BoxFit.contain,
      Size(image.width.toDouble(), image.height.toDouble()),
      size,
    );

    // 描画先のサイズ（BoxFitによって計算された画像の表示サイズ）は destination に入っています
    final Size destinationSize = fittedSizes.destination;

    // 画像がキャンバス内で中央揃えされる場合のオフセット (左上隅の位置) を計算
    // size.width は親のキャンバスの幅、destinationSize.width は画像表示の幅
    final double offsetX = (size.width - destinationSize.width) / 2;
    final double offsetY = (size.height - destinationSize.height) / 2;

    // 描画先のRectを構築 (位置とサイズ)
    // Rect.fromLTWH(left, top, width, height)
    final Rect outputRect = Rect.fromLTWH(
      offsetX, // <-- ここを修正
      offsetY, // <-- ここを修正
      destinationSize.width, // BoxFitが計算した幅
      destinationSize.height, // BoxFitが計算した高さ
    );

    // 画像を指定されたRectに描画
    canvas.drawImageRect(image, src, outputRect, Paint());
  }

  @override
  bool shouldRepaint(covariant SimpleImagePainter oldDelegate) {
    return oldDelegate.image != image;
  }
}

// _generateImageInIsolate の定義 (AffectedAreaPageと同じファイルにある想定)
// この関数はクラスの外（トップレベル）に定義する必要があります
Uint8List _generateImageInIsolate(Map<String, dynamic> args) {
  final img.Image rawMaskImage = args['rawMaskImage'];
  final List<Color> selectedColorsList =
      (args['selectedColors'] as List).cast<Color>();
  final int highlightColorARGB = args['highlightColorARGB'];

  final Set<Color> selectedColors = selectedColorsList.toSet();

  final img.Image outputImage = img.Image(
    width: rawMaskImage.width,
    height: rawMaskImage.height,
    numChannels: 4,
  );

  final img.Color highlightPixelColor = img.ColorRgba8(
    (highlightColorARGB >> 16) & 0xFF,
    (highlightColorARGB >> 8) & 0xFF,
    (highlightColorARGB >> 0) & 0xFF,
    (highlightColorARGB >> 24) & 0xFF,
  );

  final img.Color transparentPixelColor = img.ColorRgba8(0, 0, 0, 0);

  for (int y = 0; y < rawMaskImage.height; y++) {
    for (int x = 0; x < rawMaskImage.width; x++) {
      final pixel = rawMaskImage.getPixel(x, y);
      final pixelColor = Color.fromARGB(
        pixel.a.toInt(),
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
      );

      if (selectedColors.contains(pixelColor)) {
        outputImage.setPixel(x, y, highlightPixelColor);
      } else {
        outputImage.setPixel(x, y, transparentPixelColor);
      }
    }
  }

  final pngBytes = img.encodePng(outputImage);
  return Uint8List.fromList(pngBytes);
}
