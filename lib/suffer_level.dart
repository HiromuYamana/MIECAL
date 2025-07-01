import 'package:flutter/material.dart';
import 'package:miecal/couse.dart';
import 'package:miecal/vertical_slide_page.dart';

class SufferLevelPage extends StatefulWidget {
    const SufferLevelPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SufferLevelPageState createState() => _SufferLevelPageState();
}

class _SufferLevelPageState extends State<SufferLevelPage> {
  double severity = 0;

  int getSeverityIndex(double value) {
    return ((value - 1) / 1.666).floor().clamp(0, 5);
  }
 
  final List<String> faceImages = [
    'assets/images/face_very_happy.png',
    'assets/images/face_happy.png',
    'assets/images/face_neutral.png',
    'assets/images/face_sad.png',
    'assets/images/face_very_sad.png',
    'assets/images/face_danger.png',
  ];

 
  @override
  Widget build(BuildContext context) {
    int selectedIndex = getSeverityIndex(severity);
    return Scaffold(
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
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue.shade100, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      faceImages[selectedIndex],
                      width: 100,
                      height: 100,
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 8.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14.0),
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
                      VerticalSlideRoute(page: const CousePage()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

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
    final double trackLeft = offset.dx + sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width / 2;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;

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
    Offset? secondaryOffset, // ← 追加された！
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

    final Paint paint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..style = PaintingStyle.fill;

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(4)),
      paint,
    );
  }
}