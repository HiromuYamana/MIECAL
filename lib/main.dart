import 'package:flutter/material.dart';
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
        '/': (context) => const MyHomePage(title: 'MIECAL'),
        '/PersonalInfomationPage':(context) => const PersonalInfomationPage(),
        '/LoginPage': (context) => const LoginPage(),
        '/SymptomPage': (context) => const SymptomPage(),
        '/AffectedAreaPage': (context) => const AffectedAreaPage(),
        '/DatePage': (context) => const DatePage(),
        '/SufferLevelPage': (context) => const SufferLevelPage(),
        '/CousePage': (context) => const CousePage(),
        '/OtherInfomationPage': (context) => const OtherInfomationPage(),
        '/QuestionnairePage': (context) => const QuestionnairePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

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

class PersonalInfomationPage extends StatelessWidget {
  const PersonalInfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('個人情報入力')),
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
              }
              else if (value == 'profile') {
                Navigator.pushNamed(context,'/PersonalInfomationPage');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
        child:ElevatedButton(
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
        child:ElevatedButton(
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
    return Scaffold(
      appBar: AppBar(title: const Text('日付')),
      body: Center(
        child:ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/SufferLevelPage'),
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
        child:ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/CousePage'),
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
        child:ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/OtherInfomationPage'),
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class OtherInfomationPage extends StatelessWidget {
  const OtherInfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('その他情報入力')),
      body: Center(
        child:ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/QuestionnairePage'),
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class QuestionnairePage extends StatelessWidget {
  const QuestionnairePage({super.key});

  void _showQrCodePage(BuildContext context) {
    final currentUrl = html.window.location.href;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrPage(data: currentUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('問診表')),
      body: Center(
        child:ElevatedButton(
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
              child:Center(
                child: QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 200.0,
                ),
              )
            ),
            Expanded(
                child: Text('ご記入ありがとうございました。',style: TextStyle(fontSize: 30))
            ),
          ],
        ),
      ),
    );
  }
}
