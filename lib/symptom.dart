import 'package:flutter/material.dart';
import 'package:miecal/affected_area.dart';
import 'package:miecal/vertical_slide_page.dart';

class SymptomPage extends StatelessWidget {
  const SymptomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('症状入力')),
      body: Center(
        child: ElevatedButton(
          onPressed:
              () => Navigator.push(
                context,
                VerticalSlideRoute(page: const AffectedAreaPage()),
              ),
          child: const Text('Next'),
        ),
      ),
    );
  }
}
