import 'package:flutter/material.dart';

class other_pageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ExclusiveRowButtonsPage());
  }
}

class ExclusiveRowButtonsPage extends StatefulWidget {
  @override
  _ExclusiveRowButtonsPageState createState() =>
      _ExclusiveRowButtonsPageState();
}

class _ExclusiveRowButtonsPageState extends State<ExclusiveRowButtonsPage> {
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
      appBar: AppBar(title: Text('選択とラベル')),
      backgroundColor: Color.fromARGB(255, 182, 210, 237), // ←背景色変更
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (rowIndex) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🔲 ボタン2つを囲う枠
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
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
                              bool isSelected =
                                  selectedInRow[rowIndex] == colIndex;

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(100, 100),
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
                                        height:100,
                                        child: Image.asset(
                                          imagePaths[index],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(height: 0),
                                      //Text('選択${index + 1}'),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        // 📝 ラベルテキスト
                        SizedBox(width: 16),
                        Text(
                          labels[rowIndex],
                          style: TextStyle(fontSize: 18),
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
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResultPage(selected: selectedInRow),
                  ),
                );
              },
              child: Text('⇩'),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final List<int?> selected;

  ResultPage({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('選択結果')),
      body: Center(
        child: Text(
          '選択状態: $selected',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}