import 'package:flutter/material.dart';
import 'package:miecal/couse.dart';
import 'package:miecal/vertical_slide_page.dart';

class SufferLevelPage extends StatelessWidget {
  const SufferLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('程度選択')),
      body: Center(
        child: ElevatedButton(
          onPressed:
              () => Navigator.push(
                context,
                VerticalSlideRoute(page: const CousePage()),
              ),
          child: const Text('Next'),
        ),
      ),
    );
  }
}
