import 'package:flutter/material.dart';
import 'package:miecal/affected_area.dart';
import 'package:miecal/vertical_slide_page.dart';

// SymptomPage を StatefulWidget に変更
class SymptomPage extends StatefulWidget {
  const SymptomPage({super.key});

  @override
  // createState() メソッドを正しくオーバーライド
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  // 画像のパス
  final List<String> images_Couse = [
    'assets/images/bienn.png',
    'assets/images/fukutuu.png',
    'assets/images/gaishou.png',
    'assets/images/kossetu.png',
    'assets/images/metabo.png',
    'assets/images/seki.png',
    'assets/images/youtuu.png',

    'assets/images/metabo.png',
    'assets/images/metabo.png',
    'assets/images/metabo.png',
    'assets/images/metabo.png',

    'assets/images/metabo.png',
    'assets/images/metabo.png',

    'assets/images/metabo.png',
    'assets/images/metabo.png',
    'assets/images/metabo.png',
  ];

  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = List.filled(images_Couse.length, false);
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
              padding: EdgeInsets.only(top: topPadding),
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
                    const Text('症状選択', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              color: Color.fromARGB(255, 218, 246, 250),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: images_Couse.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected[index] = !isSelected[index];
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          width: 1050,
                          height: 1050,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected[index]
                                      ? Colors.orange
                                      : Colors.transparent,
                              width: isSelected[index] ? 4 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              images_Couse[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (isSelected[index])
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                255,
                                252,
                                166,
                                7,
                              ).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
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
                      VerticalSlideRoute(page: const AffectedAreaPage()),
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
