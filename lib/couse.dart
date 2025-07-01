import 'package:flutter/material.dart';
import 'package:miecal/other_information.dart';
import 'package:miecal/vertical_slide_page.dart';

class CousePage extends StatefulWidget {
  const CousePage({super.key});
 
  @override
  State<CousePage> createState() => _CousePageState();
}
 
class _CousePageState extends State<CousePage> {
  final List<String> imagesCouse = [
  'assets/images/ziko.png',
  'assets/images/tennraku.png',
  'assets/images/fukutuu.png',
  'assets/images/kossetu.png',
  'assets/images/metabo.png',
];
 
  late List<bool> isSelected;
 
  @override
  void initState() {
    super.initState();
    isSelected = List.filled(imagesCouse.length, false);
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
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: imagesCouse.length,
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
                        margin: EdgeInsets.all(8),
                        width: 1050,
                        height: 1050,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected[index] ? Colors.orange : Colors.transparent,
                            width: isSelected[index] ? 4 : 1,
                           
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            imagesCouse[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (isSelected[index])
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 252, 166, 7).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
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
                      VerticalSlideRoute(page: const  OtherInformationPage()),
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
 