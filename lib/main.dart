import 'package:flutter/material.dart';
import 'package:miecal/table_calendar.dart';
import 'package:miecal/other_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIECAL',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/PersonalInformationPage':
            (context) => const PersonalInformationPage(),
        '/LoginPage': (context) => const LoginPage(),
        '/SymptomPage': (context) => const SymptomPage(),
        '/AffectedAreaPage': (context) => const AffectedAreaPage(),
        '/DatePage': (context) => const DatePage(),
        '/SufferLevelPage': (context) => const SufferLevelPage(),
        '/CousePage': (context) => const CousePage(),
        '/OtherInformationPage': (context) => const OtherInformationPage(),
        '/QuestionnairePage': (context) => const QuestionnairePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _goToLoginPage() {
    Navigator.pushNamed(context, '/LoginPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _goToLoginPage,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: const Center(
            child: Text(
              'Please Tap the Screen',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール')),
      body: Center(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン・新規登録'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: (value) {
              if (value == 'home') {
                Navigator.pushNamed(context, '/');
              } else if (value == 'profile') {
                Navigator.pushNamed(context, '/PersonalInformationPage');
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'home',
                    child: Text('ホーム'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('プロフィール変更'),
                  ),
                ],
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/SymptomPage'),
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class SymptomPage extends StatelessWidget {
  const SymptomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('症状入力')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/AffectedAreaPage'),
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class AffectedAreaPage extends StatelessWidget {
  const AffectedAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('患部')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/DatePage'),
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class DatePage extends StatelessWidget {
  const DatePage({super.key});

  @override
  Widget build(BuildContext context) {
    //発症日カレンダー
    return Table_Calendar();
  }
}

class SufferLevelPage extends StatelessWidget {
  const SufferLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('程度選択')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/CousePage'),
          child: const Text('Next'),
        ),
      ),
    );
  }
}


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
            onPressed: () {
              Navigator.pushNamed(context, '/OtherInformationPage');
            },
            child: Image.asset('assets/images/yazirusi(under).jpg',width: 50,height: 50,),
          ),
        ],
      ),
    );
  }
}

class OtherInformationPage extends StatefulWidget {
  const OtherInformationPage({super.key});

  @override
  _OtherInformationPageState createState() => _OtherInformationPageState();
}

class _OtherInformationPageState extends State<OtherInformationPage> {
  List<int?> selectedInRow = [null, null, null];
  
  final List<String> imagePaths = [
    'assets/sample_image1.png',
    'assets/sample_image2.png',
    'assets/sample_image3.png',
    'assets/sample_image4.png',
    'assets/sample_image5.png',
    'assets/sample_image6.png',
  ];

  final List<String> labels = ['a', 'b', 'c'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('その他の情報入力')),
      backgroundColor: const Color.fromARGB(255, 182, 210, 237),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (rowIndex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                          child: Row(
                            children: List.generate(2, (colIndex) {
                              int index = rowIndex * 2 + colIndex;
                              bool isSelected = selectedInRow[rowIndex] == colIndex;

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(100, 100),
                                    backgroundColor: isSelected
                                        ? const Color.fromARGB(255, 225, 171, 85)
                                        : Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedInRow[rowIndex] =
                                        isSelected ? null : colIndex;
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Image.asset(
                                          imagePaths[index],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          labels[rowIndex],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),

          // 「次へ」ボタン
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/QuestionnairePage');
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('その他情報入力')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/QuestionnairePage'),
          child: const Text('Next'),
        ),
      ),
    );
  }


class QuestionnairePage extends StatelessWidget {
  const QuestionnairePage({super.key});

  void _showQrCodePage(BuildContext context) {
    final currentUrl = html.window.location.href;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrPage(data: currentUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('問診表')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showQrCodePage(context),
          child: const Text('QRコード作成 Create QRcode'),
        ),
      ),
    );
  }
}

class QrPage extends StatelessWidget {
  final String data;
  const QrPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRコード表示 Showing QR')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: QrImageView(
                  data: data,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
            Expanded(
              child: Text('ご記入ありがとうございました。', style: TextStyle(fontSize: 30)),
            ),
          ],
        ),
      ),
    );
  }
}
