import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:miecal/table_calendar.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/l10n/app_localizations.dart';

class AffectedAreaPage extends StatefulWidget {
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

  const AffectedAreaPage({
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
  State<AffectedAreaPage> createState() => _AffectedAreaPageState();
}

class _AffectedAreaPageState extends State<AffectedAreaPage> {
  ui.Image? _maskImage;
  img.Image? _rawMaskImage;
  final GlobalKey _imageKey = GlobalKey();

  late Map<Color, String Function()> localizedColorToPart;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;

    localizedColorToPart = {
      const Color.fromARGB(255, 255, 0, 0): () => loc.partFace,
      const Color.fromARGB(255, 0, 255, 0): () => loc.partNeck,
      const Color.fromARGB(255, 0, 0, 255): () => loc.partChest,
      const Color.fromARGB(255, 255, 255, 0): () => loc.partAbdomen,
      const Color.fromARGB(255, 255, 0, 255): () => loc.partGroin,
      const Color.fromARGB(255, 0, 255, 255): () => loc.partRightThigh,
      const Color.fromARGB(255, 128, 255, 255): () => loc.partRightCalf,
      const Color.fromARGB(255, 128, 128, 255): () => loc.partRightFoot,
      const Color.fromARGB(255, 128, 0, 255): () => loc.partLeftThigh,
      const Color.fromARGB(255, 128, 255, 128): () => loc.partLeftCalf,
      const Color.fromARGB(255, 128, 255, 0): () => loc.partLeftFoot,
      const Color.fromARGB(255, 128, 0, 0): () => loc.partRightShoulder,
      const Color.fromARGB(255, 255, 128, 255): () => loc.partRightUpperArm,
      const Color.fromARGB(255, 255, 128, 128): () => loc.partRightForearm,
      const Color.fromARGB(255, 255, 128, 0): () => loc.partRightHand,
      const Color.fromARGB(255, 0, 128, 255): () => loc.partLeftShoulder,
      const Color.fromARGB(255, 0, 128, 128): () => loc.partLeftUpperArm,
      const Color.fromARGB(255, 0, 128, 0): () => loc.partLeftForearm,
      const Color.fromARGB(255, 0, 0, 128): () => loc.partLeftHand,
      const Color.fromARGB(255, 64, 255, 255): () => loc.partHead,
      const Color.fromARGB(255, 255, 64, 255): () => loc.partNape,
      const Color.fromARGB(255, 255, 255, 64): () => loc.partBack,
      const Color.fromARGB(255, 255, 64, 64): () => loc.partButtocks,
      const Color.fromARGB(255, 64, 255, 64): () => loc.partRightThigh,
      const Color.fromARGB(255, 64, 64, 255): () => loc.partRightCalf,
      const Color.fromARGB(255, 255, 128, 64): () => loc.partRightFoot,
      const Color.fromARGB(255, 255, 64, 128): () => loc.partLeftThigh,
      const Color.fromARGB(255, 128, 255, 64): () => loc.partLeftCalf,
      const Color.fromARGB(255, 128, 64, 255): () => loc.partLeftFoot,
      const Color.fromARGB(255, 64, 255, 128): () => loc.partLeftShoulder,
      const Color.fromARGB(255, 64, 128, 255): () => loc.partLeftUpperArm,
      const Color.fromARGB(255, 255, 64, 0): () => loc.partLeftForearm,
      const Color.fromARGB(255, 255, 0, 64): () => loc.partLeftHand,
      const Color.fromARGB(255, 64, 255, 0): () => loc.partRightShoulder,
      const Color.fromARGB(255, 64, 0, 255): () => loc.partRightUpperArm,
      const Color.fromARGB(255, 0, 255, 64): () => loc.partRightForearm,
      const Color.fromARGB(255, 0, 64, 255): () => loc.partRightHand,
    };
  }

  final Set<Color> _selectedColors = {};
  final Map<Color, List<Offset>> _colorPixelCache = {};

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

  void _onTap(TapUpDetails details) {
    if (_maskImage == null || _rawMaskImage == null) return;

    final RenderBox box =
        _imageKey.currentContext!.findRenderObject() as RenderBox;
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

    if (localizedColorToPart.containsKey(pixelColor)) {
      setState(() {
        if (_selectedColors.contains(pixelColor)) {
          _selectedColors.remove(pixelColor);
        } else {
          _selectedColors.add(pixelColor);
        }
      });
    }
  }

  String getSelectedPartsSummary() {
    if (_selectedColors.isEmpty) {
      return AppLocalizations.of(context)!.notSelected;
    }
    final List<String> parts = [];
    for (final color in _selectedColors) {
      final partFunc = localizedColorToPart[color];
      if (partFunc != null) {
        parts.add(partFunc());
      }
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            flex: 1,
            child: Material(
              color: const Color.fromARGB(255, 207, 227, 230),
              //padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: InkWell(
                onTap:(){
                  Navigator.pop(context); //前の画面に戻る
                },
                child: SizedBox(
                  child: Center(
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
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Center(
                child:Text(
                      loc.affectedAreaSelection,
                      style: const TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ),
            ),
          ),
          Expanded(
            flex: 12,
            child:
                _maskImage == null
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
                                    selectedColors: _selectedColors,
                                    colorPixelCache: _colorPixelCache,
                                    referenceImage: _maskImage!,
                                    imageWidth: _rawMaskImage!.width,
                                    imageHeight: _rawMaskImage!.height,
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
            flex: 2,
            child: Material(
              color: Colors.blueGrey,
              child: InkWell(
                onTap: () {
                  final String selectedAffectedArea = getSelectedPartsSummary();
                  Navigator.push(
                    context,
                    VerticalSlideRoute(
                      page: DatePage(
                        userName: widget.userName,
                        userDateOfBirth: widget.userDateOfBirth,
                        userHome: widget.userHome,
                        userGender: widget.userGender,
                        userTelNum: widget.userTelNum,
                        selectedOnsetDay: widget.selectedOnsetDay,
                        symptom: widget.symptom,
                        affectedArea: selectedAffectedArea,
                        sufferLevel: widget.sufferLevel,
                        cause: widget.cause,
                        otherInformation: widget.otherInformation,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  child: Center(
                    child: const Icon(
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

class MaskOverlayPainter extends CustomPainter {
  final Set<Color> selectedColors;
  final Map<Color, List<Offset>> colorPixelCache;
  final ui.Image referenceImage;
  final int imageWidth;
  final int imageHeight;

  MaskOverlayPainter({
    required this.selectedColors,
    required this.colorPixelCache,
    required this.referenceImage,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final imageAspect = referenceImage.width / referenceImage.height;
    final canvasAspect = size.width / size.height;

    double displayWidth, displayHeight;
    if (canvasAspect > imageAspect) {
      displayHeight = size.height;
      displayWidth = displayHeight * imageAspect;
    } else {
      displayWidth = size.width;
      displayHeight = displayWidth / imageAspect;
    }

    final offsetX = (size.width - displayWidth) / 2;
    final offsetY = (size.height - displayHeight) / 2;

    final scaleX = displayWidth / imageWidth;
    final scaleY = displayHeight / imageHeight;

    final paint =
        Paint()
          ..color = Colors.red.withValues(alpha: 0.5)
          ..style = PaintingStyle.fill;

    for (final color in selectedColors) {
      final pixels = colorPixelCache[color];
      if (pixels == null) continue;

      for (final p in pixels) {
        final rect = Rect.fromLTWH(
          offsetX + p.dx * scaleX,
          offsetY + p.dy * scaleY,
          scaleX,
          scaleY,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MaskOverlayPainter oldDelegate) {
    return oldDelegate.selectedColors != selectedColors;
  }
}
