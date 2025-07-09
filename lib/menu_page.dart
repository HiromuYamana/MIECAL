import 'package:flutter/material.dart';
import 'package:miecal/symptom.dart';
import 'package:miecal/top_page.dart';
import 'package:miecal/personal_information_page.dart';
import 'package:miecal/l10n/app_localizations.dart'; 

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!; 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(local.menuTitle), 
        backgroundColor: Colors.teal,
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
                    MaterialPageRoute(builder: (context) => const SymptomPage()),
                  );
                },
              ),
              _MenuIconButton(
                imagePath: 'assets/icons/profile_edit.png',
                label: local.profileEdit,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PersonalInformationPage()),
                  );
                },
              ),
            ],
          ),

          // ログアウト
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TopPage()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, size: 18, color: Colors.grey),
              label: Text(
                local.logout,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
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
