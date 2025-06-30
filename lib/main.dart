import 'package:flutter/material.dart';
import 'affected_area.dart';
import 'package:miecal/table_calendar.dart';
import 'package:miecal/other_information.dart';
import 'package:miecal/qr.dart';
import 'package:miecal/vertical_slide_page.dart';

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
        '/': (context) => const TopPage(),
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

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  void _goToLoginPage() {
    Navigator.push(context, VerticalSlideRoute(page: const LoginPage()));
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

class SymptomPage extends StatelessWidget {
  const SymptomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('症状入力')),
      body: Center(
        child: ElevatedButton(
          onPressed:
              () => Navigator.push(
                context,
                VerticalSlideRoute(page: const AffectedAreaPage()),
              ),
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
          onPressed:
              () => Navigator.push(
                context,
                VerticalSlideRoute(page: const DatePage()),
              ),
          child: const Text('Next'),
        ),
      ),
    );
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
          onPressed:
              () => Navigator.push(
                context,
                VerticalSlideRoute(page: const CousePage()),
              ),
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class CousePage extends StatelessWidget {
  const CousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('原因')),
      body: Center(
        child: ElevatedButton(
          onPressed:
              () => Navigator.push(
                context,
                VerticalSlideRoute(page: const OtherInformationPage()),
              ),
          child: const Text('Next'),
        ),
      ),
    );
  }
}
