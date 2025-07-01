import 'package:flutter/material.dart';
import 'package:miecal/table_calendar.dart';
import 'package:miecal/vertical_slide_page.dart';

class AffectedAreaPage extends StatelessWidget {
  const AffectedAreaPage({super.key});

  void _onAreaTapped(BuildContext context, String area) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$area が選ばれました')));
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
            flex: 7,
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double imageWidth = constraints.maxWidth;
                    final double imageHeight = constraints.maxHeight;
                    return Stack(
                      children: [
                        Image.asset(
                          'assets/human_outline.png',
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.contain,
                          
                        ),
                      ]
                    );
                  }
                )
              ]
            )
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
                      VerticalSlideRoute(page: const DatePage()),
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
