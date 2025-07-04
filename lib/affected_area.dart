import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img; // image パッケージを img としてインポート
import 'package:miecal/table_calendar.dart'; // DatePage が定義されているファイル
import 'package:miecal/vertical_slide_page.dart'; // VerticalSlideRoute の定義があるファイル

class AffectedAreaPage extends StatefulWidget {
  final String? symptom; // SymptomPageから受け取る症状
  const AffectedAreaPage({super.key, this.symptom});
  @override
  State<AffectedAreaPage> createState() => _AffectedAreaPageState();
}
 
class _AffectedAreaPageState extends State<AffectedAreaPage> {
  ui.Image? _maskImage; // UI用 (ui.Imageは描画用)
  img.Image? _rawMaskImage; // ピクセル取得用 (image.Imageはピクセルデータ操作用)
  Offset? _selectedPosition; // タップした位置
  bool _showMaskOverlay = false; // デバッグ用: マスク画像を表示するかどうか

  final GlobalKey _imageKey = GlobalKey(); // 画像のRenderBoxを取得するためのキー
  // カラーコードと患部のマッピング
  final Map<Color, String> colorToPart = {
    const Color.fromARGB(255, 255, 0, 0): '顔',
    const Color.fromARGB(255, 0, 255, 0): '首',
    const Color.fromARGB(255, 0, 0, 255): '胸',
    const Color.fromARGB(255, 255, 255, 0): '腹',
    const Color.fromARGB(255, 255, 0, 255): '股',
    const Color.fromARGB(255, 0, 255, 255): '右腿',
    const Color.fromARGB(255, 128, 255, 255): '右ふくらはぎ',
    const Color.fromARGB(255, 128, 128, 255): '右足',
    const Color.fromARGB(255, 128, 0, 255): '左腿',
    const Color.fromARGB(255, 128, 255, 128): '左ふくらはぎ',
    const Color.fromARGB(255, 128, 255, 0): '左足',
    const Color.fromARGB(255, 128, 0, 0): '右肩',
    const Color.fromARGB(255, 255, 128, 255): '右上腕',
    const Color.fromARGB(255, 255, 128, 128): '右前腕',
    const Color.fromARGB(255, 255, 128, 0): '右手',    
    const Color.fromARGB(255, 0, 128, 255): '左肩',
    const Color.fromARGB(255, 0, 128, 128): '左上腕',
    const Color.fromARGB(255, 0, 128, 0): '左前腕',
    const Color.fromARGB(255, 0, 0, 128): '左手',
    const Color.fromARGB(255, 64, 255, 255): '頭',
    const Color.fromARGB(255, 255, 64, 255): '首',
    const Color.fromARGB(255, 255, 255, 64): '背中',
    const Color.fromARGB(255, 255, 64, 64): '臀部',
    const Color.fromARGB(255, 64, 255, 64): '右腿',
    const Color.fromARGB(255, 64, 64, 255): '右ふくらはぎ',
    const Color.fromARGB(255, 255, 128, 64): '右足',
    const Color.fromARGB(255, 255, 64, 128): '左腿',
    const Color.fromARGB(255, 128, 255, 64): '左ふくらはぎ',
    const Color.fromARGB(255, 128, 64, 255): '左足',
    const Color.fromARGB(255, 64, 255, 128): '左肩',
    const Color.fromARGB(255, 64, 128, 255): '左上腕',
    const Color.fromARGB(255, 255, 64, 0): '左前腕',
    const Color.fromARGB(255, 255, 0, 64): '左手',
    const Color.fromARGB(255, 64, 255, 0): '右肩',
    const Color.fromARGB(255, 64, 0, 255): '右上腕',
    const Color.fromARGB(255, 0, 255, 64): '右前腕',
    const Color.fromARGB(255, 0, 64, 255): '右手',
  };
 
  String? selectedPart; // 選択された患部を保持
 
  @override
  void initState() {
    super.initState();
    _loadMaskImage(); // マスク画像を読み込む
  }
  // マスク画像をアセットから読み込む非同期関数

  Future<void> _loadMaskImage() async {
    try {
      final byteData = await rootBundle.load('assets/body_mask.png'); // マスク画像のパス
      final buffer = byteData.buffer;
      final rawImage = img.decodeImage(buffer.asUint8List())!; // ピクセル取得用の画像データ
      final codec = await ui.instantiateImageCodec(buffer.asUint8List());
      final frame = await codec.getNextFrame();
      setState(() {
        _rawMaskImage = rawImage;
        _maskImage = frame.image;
      });
    } catch (e) {
      print("マスク画像のロードに失敗しました: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('マスク画像のロードに失敗しました: $e')),
      );
    }
  }
  // 画像がタップされた時の処理
  void _onTap(TapUpDetails details) {
    if (_maskImage == null || _rawMaskImage == null) {
      print("マスク画像がまだロードされていません。");
      return;
    }
    final RenderBox box = _imageKey.currentContext!.findRenderObject() as RenderBox;
    final Size imageSize = box.size;
    final double widgetAspectRatio = imageSize.width / imageSize.height;
    final double imageAspectRatio = _maskImage!.width / _maskImage!.height;

    // 実際に表示されている画像のサイズを計算
    double displayedWidth, displayedHeight;
    if (widgetAspectRatio > imageAspectRatio) {
      // 高さに合わせてスケーリング
      displayedHeight = imageSize.height;
      displayedWidth = displayedHeight * imageAspectRatio;
    } else {
      // 幅に合わせてスケーリング
      displayedWidth = imageSize.width;
      displayedHeight = displayedWidth / imageAspectRatio;
    }

    // 左上のオフセット
    final double dx = (imageSize.width - displayedWidth) / 2;
    final double dy = (imageSize.height - displayedHeight) / 2;

    // タップ座標を補正
    final Offset localPos = box.globalToLocal(details.globalPosition);
    final double xInImage = ((localPos.dx - dx) / displayedWidth) * _maskImage!.width;
    final double yInImage = ((localPos.dy - dy) / displayedHeight) * _maskImage!.height;

    final int x = xInImage.toInt();
    final int y = yInImage.toInt();

    final pixel = _rawMaskImage!.getPixel(x, y);
    final int a = pixel.a.toInt(); // アルファ
    final int r = pixel.r.toInt(); // 赤
    final int g = pixel.g.toInt(); // 緑
    final int b = pixel.b.toInt(); // 青
    final pixelColor = Color.fromARGB(a, r, g, b); // アルファ値も考慮
    final part = colorToPart[pixelColor];
    setState(() {
      _selectedPosition = localPos; // タップ位置を更新してハイライト表示を更新
      if (part != null) {
        selectedPart = part; // 選択された患部名を更新
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$part が選ばれました')), // スナックバーで通知
        );
      }
      else {
        selectedPart = null; // マッピングにない色の場合、選択解除
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('対応する患部が見つかりませんでした。透明な部分をタップした可能性があります。')),
        );
      }
    });
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
              padding: EdgeInsets.only(top: topPadding), // 上部パディング
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

                    const Text('患部選択', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)), 
                    if (selectedPart != null) // 選択された患部を表示
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '選択中: $selectedPart',
                          style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7, // 画像表示領域の割合
            child: _maskImage == null // マスク画像が読み込み中か確認
                ? const Center(child: CircularProgressIndicator()) // 読み込み中はローディング表示
                : Container( // 画像を囲むコンテナを追加 (fit: BoxFit.containがStack内で正しく機能するよう)
                    color: Colors.transparent, // 必要であれば背景色設定
                    child: LayoutBuilder( // タップ位置計算のためLayoutBuilderを維持
                      builder: (context, constraints) {
                        return GestureDetector(
                          onTapUp: _onTap, // onTapUp の引数を修正
                          child: Stack( // 画像とハイライトを重ねる
                            children: [
                              Positioned.fill( // 画像を親のサイズに合わせる
                                child: Image.asset(
                                  'assets/human_outline.png', // 人体のアウトライン画像
                                  key: _imageKey, // <-- ここにGlobalKeyを設定
                                  fit: BoxFit.contain, // コンテナに合わせて画像をフィット
                                ),
                              ),

                              if (_showMaskOverlay)
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: RawImage(
                                      image: _maskImage,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),

                              if (_selectedPosition != null) // タップ位置が選択されていればハイライト表示
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: HighlightPainter(
                                      position: _selectedPosition!,
                                      color: Colors.yellow.withValues(alpha: 0.3), // 半透明の黄色でハイライト
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
          // 下部のナビゲーションボタン部分
          Expanded(
            flex: 1, // 下部のボタン領域の割合
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
                    if (selectedPart != null) {
                      // 選択された患部と、これまでのページから受け取ったデータを
                      // DatePageへ渡す
                      Navigator.push(
                        context,
                        VerticalSlideRoute(
                          page: DatePage(
                            symptom: widget.symptom,    // SymptomPageから受け取った症状
                            affectedArea: selectedPart, // このAffectedAreaPageで選択した患部
                          ),
                        ),
                      );
                    }
                    else {
                      // 患部が選択されていない場合の警告
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('患部を選択してください．'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
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
// HighlightPainter クラスは変更なし (以前のコードからそのまま)
class HighlightPainter extends CustomPainter {
  final Offset position;
  final Color color;
  HighlightPainter({required this.position, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawCircle(position, 30, paint); // ハイライト半径
  }
 
  @override
  bool shouldRepaint(covariant HighlightPainter oldDelegate) {
    return oldDelegate.position != position || oldDelegate.color != color;
  }
}
 