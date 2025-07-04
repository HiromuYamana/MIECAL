import 'package:flutter/material.dart';
import 'package:miecal/personal_information_page.dart';
import 'package:miecal/symptom.dart';
import 'package:miecal/vertical_slide_page.dart';

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
                Navigator.push(
                  context,
                  VerticalSlideRoute(page: const PersonalInformationPage()),
                );
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
          onPressed:
              () => Navigator.push(
                context,
                VerticalSlideRoute(page: const SymptomPage()),
              ),
          child: const Text('Next'),
        ),
      ),
    );
  }
}
