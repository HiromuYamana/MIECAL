import 'package:flutter/material.dart';
import 'package:miecal/symptom.dart';
import 'package:miecal/top_page.dart';
import 'package:miecal/personal_information_page.dart';
import 'package:miecal/l10n/app_localizations.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/qr_scanner_page.dart';

class MenuPage extends StatelessWidget {
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

  const MenuPage({
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
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(local.menuTitle),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false, // <-- 修正点: 戻るボタンを非表示にする
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // メイン操作ボタンエリア
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MenuIconButton(
                imagePath: 'assets/icons/medical_form.png',
                label: local.symptomForm,
                onTap: () {
                  Navigator.push(
                    context,
                    VerticalSlideRoute(
                      page: SymptomPage(
                        userName: userName,
                        userDateOfBirth: userDateOfBirth,
                        userHome: userHome,
                        userGender: userGender,
                        userTelNum: userTelNum,
                        selectedOnsetDay: selectedOnsetDay,
                        symptom: symptom,
                        affectedArea: affectedArea,
                        sufferLevel: sufferLevel,
                        cause: cause,
                        otherInformation: otherInformation,
                      ),
                    ),
                  );
                },
              ),
              _MenuIconButton(
                imagePath: 'assets/icons/profile_edit.png',
                label: local.profileEdit,
                onTap: () {
                  Navigator.push(
                    context,
                    VerticalSlideRoute(page: PersonalInformationPage()),
                  );
                },
              ),
            ],
          ),

          _MenuIconButton(
            imagePath: 'assets/icons/qr_scan.png', // <-- 適切なアイコン画像パスに変更
            label: 'QRを読み込む', // local.qrScan などに多言語化可能
            onTap: () {
              Navigator.push(
                context,
                VerticalSlideRoute(
                  page: const QrScannerPage(),
                ), // QrScannerPageへ遷移
              );
            },
          ),

          // ログアウト
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(context, VerticalSlideRoute(page: TopPage()));
              },
              icon: const Icon(Icons.logout, size: 18, color: Colors.grey),
              label: Text(
                local.logout,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/TermsOfServicePage');
            },
            child: const Text('利用規約を見る'),
          ),

        ],
      ),
    );
  }
}

class _MenuIconButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _MenuIconButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
