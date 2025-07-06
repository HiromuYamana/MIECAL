import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:miecal/suffer_level.dart';
import 'package:miecal/table_calendar.dart';
import 'package:miecal/vertical_slide_page.dart';

class AffectedAreaPage extends StatefulWidget {
  final String? symptom;
  final String? sufferLevel;

  const AffectedAreaPage({
    super.key,
    this.symptom,
    this.sufferLevel,
  });

  @override
  State<AffectedAreaPage> createState() => _AffectedAreaPageState();
}

class _AffectedAreaPageState extends State<AffectedAreaPage> {
  ui.Image? _maskImage;
  img.Image? _rawMaskImage;
  final GlobalKey _imageKey = GlobalKey();

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

  final Set<Color> _selectedColors = {};

  @override
  void initState() {
    super.initState();
    _loadMaskImage();
  }

  Future<void> _loadMaskImage() async {
    final byteData = await rootBundle.load('assets/body_mask.png');
    final buffer = byteData.buffer.asUint8List();
    final rawImage = img.decodeImage(buffer)!;

    final codec = await ui.instantiateImageCodec(buffer);
    final frame = await codec.getNextFrame();

    setState(() {
      _rawMaskImage = rawImage;
      _maskImage = frame.image;
    });
  }

  void _onTap(TapUpDetails details) {
    if (_maskImage == null || _rawMaskImage == null) return;

    final RenderBox box = _imageKey.currentContext!.findRenderObject() as RenderBox;
    final Size widgetSize = box.size;
    final Offset localPos = box.globalToLocal(details.globalPosition);

    final double imageAspect = _maskImage!.width / _maskImage!.height;
    final double widgetAspect = widgetSize.width / widgetSize.height;

    double displayWidth, displayHeight;
    if (widgetAspect > imageAspect) {
      displayHeight = widgetSize.height;
      displayWidth = displayHeight * imageAspect;
    } else {
      displayWidth = widgetSize.width;
      displayHeight = displayWidth / imageAspect;
    }

    final dx = (widgetSize.width - displayWidth) / 2;
    final dy = (widgetSize.height - displayHeight) / 2;

    final double xInImage = ((localPos.dx - dx) / displayWidth) * _rawMaskImage!.width;
    final double yInImage = ((localPos.dy - dy) / displayHeight) * _rawMaskImage!.height;

    final int x = xInImage.toInt();
    final int y = yInImage.toInt();

    if (x < 0 || y < 0 || x >= _rawMaskImage!.width || y >= _rawMaskImage!.height) return;

    final pixel = _rawMaskImage!.getPixel(x, y);
    final pixelColor = Color.fromARGB(pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());

    final part = colorToPart[pixelColor];
    if (part != null) {
      setState(() {
        if (_selectedColors.contains(pixelColor)) {
          _selectedColors.remove(pixelColor);
        } else {
          _selectedColors.add(pixelColor);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(255, 207, 227, 230),
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Center(
                  child: IconButton(
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
          Expanded(
            flex: 8,
            child: _maskImage == null
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTapUp: _onTap,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'assets/human_outline.png',
                                key: _imageKey,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned.fill(
                              child: CustomPaint(
                                painter: MaskOverlayPainter(
                                  maskImage: _rawMaskImage!,
                                  selectedColors: _selectedColors,
                                  referenceImage: _maskImage!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
                    Navigator.push(
                      context,
                      VerticalSlideRoute(
                        page: DatePage(
                          symptom: widget.symptom,
                          // sufferLevel: widget.sufferLevel,
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

class MaskOverlayPainter extends CustomPainter {
  final img.Image maskImage;
  final Set<Color> selectedColors;
  final ui.Image referenceImage;

  MaskOverlayPainter({
    required this.maskImage,
    required this.selectedColors,
    required this.referenceImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double imageAspect = referenceImage.width / referenceImage.height;
    final double canvasAspect = size.width / size.height;

    double displayWidth, displayHeight;
    if (canvasAspect > imageAspect) {
      displayHeight = size.height;
      displayWidth = displayHeight * imageAspect;
    } else {
      displayWidth = size.width;
      displayHeight = displayWidth / imageAspect;
    }

    final double offsetX = (size.width - displayWidth) / 2;
    final double offsetY = (size.height - displayHeight) / 2;

    final double scaleX = displayWidth / maskImage.width;
    final double scaleY = displayHeight / maskImage.height;

    final paint = Paint()
      ..color = Colors.red.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    for (int y = 0; y < maskImage.height; y++) {
      for (int x = 0; x < maskImage.width; x++) {
        final pixel = maskImage.getPixel(x, y);
        final pixelColor = Color.fromARGB(pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
        if (selectedColors.contains(pixelColor)) {
          final rect = Rect.fromLTWH(
            offsetX + x * scaleX,
            offsetY + y * scaleY,
            scaleX,
            scaleY,
          );
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MaskOverlayPainter oldDelegate) {
    return oldDelegate.selectedColors != selectedColors;
  }
}