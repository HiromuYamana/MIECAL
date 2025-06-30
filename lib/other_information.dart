import 'package:flutter/material.dart';
import 'package:miecal/main.dart';
import 'package:miecal/vertical_slide_page.dart';

class OtherInformationPage extends StatefulWidget {
  const OtherInformationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
                              ),
                            ],
                          ),
                          child: Row(
                            children: List.generate(2, (colIndex) {
                              int index = rowIndex * 2 + colIndex;
                              bool isSelected =
                                  selectedInRow[rowIndex] == colIndex;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(100, 100),
                                    backgroundColor:
                                        isSelected
                                            ? const Color.fromARGB(
                                              255,
                                              225,
                                              171,
                                              85,
                                            )
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
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  VerticalSlideRoute(page: const QuestionnairePage()),
                );
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}
