import 'package:flutter/material.dart';
import 'package:miecal/questionnaire.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/l10n/app_localizations.dart';

class OtherInformationPage extends StatefulWidget {
  final String? userName;
  final DateTime? userDateOfBirth;
  final String? userHome;
  final String? userGender;
  final String? userTelNum;
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea;
  final String? sufferLevel;
  final String? cause;
  final String? otherInformation;

  const OtherInformationPage({
    super.key,
    this.userName,
    this.userDateOfBirth,
    this.userHome,
    this.userGender,
    this.userTelNum,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea,
    this.sufferLevel,
    this.cause,
    this.otherInformation,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OtherInformationPageState createState() => _OtherInformationPageState();
}

class _OtherInformationPageState extends State<OtherInformationPage> {
  List<bool> toggleValues = [false, false, false, false];
  final List<String> imagePaths = [
  'assets/images/other_information/drink.png',
  'assets/images/other_information/smoke.png',
  'assets/images/other_information/medicine.png',
  'assets/images/other_information/pregnancy.png',
];

  @override
  void initState() {
    super.initState();
    // ここで必要であれば、初期選択状態を復元することも可能
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<String> labels2 = [
      loc.alcohol,
      loc.smoke,
      loc.medication,
      loc.pregnancy,
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
      appBar: AppBar(
        title: const Text(
          "MIECAL",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true, 
        backgroundColor: const Color.fromARGB(255, 75, 170, 248),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Material(
              color: const Color.fromARGB(255, 207, 227, 230),
              child: InkWell(
                onTap:(){
                  Navigator.pop(context);
                },
                child: SizedBox(
                  child:Center(
                  child: const Icon(
                    Icons.expand_less,
                    color: Colors.white,
                    size: 36,
                  ),
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex:1,
            child:Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Center(
                child:Text(
                  loc.otherInfo,
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 22
                  ),
                ),
              ) 
            ),
          ),

          Expanded(
            flex: 12,
            child: ListView.builder(
              itemCount: labels2.length,
              itemBuilder: (context, index) {
                final toggleValue = toggleValues[index];

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        children: [
                          // 左のアイコン
                          Image.asset(
                            imagePaths[index],
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(width: 12),
                              Icon(
                                toggleValues[index] ? Icons.check_circle : Icons.cancel,
                                color: toggleValues[index] ? Colors.green : Colors.red,
                                size: 24,
                              ),
                              const SizedBox(width: 8),

                          // ラベル
                          Expanded(
                            child: Text(
                              labels2[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),

                          Text(
                            loc.no,
                            style: const TextStyle(fontSize: 14),
                          ),

                          const SizedBox(width: 4),

                          // トグルスイッチ
                          Switch(
                            value: toggleValue,
                            onChanged: (value) {
                              setState(() {
                                toggleValues[index] = value;
                              });
                            },
                          ),

                          const SizedBox(width: 4),

                          Text(
                            loc.yes,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Material(
              color: Colors.blueGrey,
              child: InkWell(
                onTap: () {
                  final String otherInformationSummary =
                      _getOtherInformationSummary();

                  // これまでのページから受け取ったデータと、このページで選択した情報をまとめて渡す
                  Navigator.push(
                    context,
                    VerticalSlideRoute(
                      page: QuestionnairePage(
                        userName: widget.userName,
                        userDateOfBirth: widget.userDateOfBirth,
                        userHome: widget.userHome,
                        userGender: widget.userGender,
                        userTelNum: widget.userTelNum,
                        selectedOnsetDay: widget.selectedOnsetDay,
                        symptom: widget.symptom,
                        affectedArea: widget.affectedArea,
                        sufferLevel: widget.sufferLevel,
                        cause: widget.cause,
                        otherInformation: otherInformationSummary,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  child: Center(
                    child: const Icon(
                      Icons.expand_more,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  String _getOtherInformationSummary() {
    final loc = AppLocalizations.of(context)!;
    final List<String> labels = [loc.alcohol, loc.smoke, loc.medication, loc.pregnancy];
    List<String> summary = [];

    for (int i = 0; i < toggleValues.length; i++) {
      final value = toggleValues[i];
      String label = labels[i];
      String result = value
          ? loc.notSelected
          : value
              ? loc.yes // ← "はい"
              : loc.no; // ← "いいえ"
      summary.add('$label: $result');
    }

    return summary.join('; ');
  }
}