import 'package:flutter/material.dart';
import 'package:miecal/other_information.dart';
import 'package:miecal/vertical_slide_page.dart';

class CousePage extends StatelessWidget {
  const CousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('原因')),
      body: Center(
        child: ElevatedButton(
          onPressed:
              () => Navigator.push(
                context,
                VerticalSlideRoute(page: const OtherInformationPage()),
              ),
          child: const Text('Next'),
        ),
      ),
    );
  }
}
