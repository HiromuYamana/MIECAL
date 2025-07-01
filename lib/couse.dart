import 'package:flutter/material.dart';
import 'package:miecal/suffer_level.dart';
import 'package:miecal/other_information.dart';
import 'package:miecal/vertical_slide_page.dart';

class CousePage extends StatefulWidget {
  const CousePage({super.key});
 
  @override
  State<CousePage> createState() => _CousePageState();
}
 
class _CousePageState extends State<CousePage> {
  // 画像のパス
 
  final List<String> images_Couse = [
  'assets/images/ziko.png',
  'assets/images/tennraku.png',
  'assets/images/fukutuu.png',
  'assets/images/kossetu.png',
  'assets/images/metabo.png',
 
];
 
  // 選択状態
  late List<bool> isSelected;
 
  @override
  void initState() {
    super.initState();
    isSelected = List.filled(images_Couse.length, false); // 全部未選択で初期化
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('原因'),
                     automaticallyImplyLeading: false,), //左上戻るボタン削除
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>SufferLevelPage())
            );
          }, child: Image.asset('assets/images/yazirusi(up).jpg',width: 50,height: 50,)),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 横2列
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
                            images_Couse[index],
                            fit: BoxFit.cover,
                         
                          ),
                        ),
                      ),
                      if (isSelected[index])
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 252, 166, 7).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed:
            () => Navigator.push(
              context,
              VerticalSlideRoute(page: const OtherInformationPage()),
            ),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
 