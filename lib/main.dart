import 'package:flutter/material.dart';
import 'package:miecal/couse.dart';

import 'package:miecal/questionnaire.dart';
import 'package:miecal/suffer_level.dart';
import 'package:miecal/symptom.dart';
import 'package:miecal/top_page.dart';
import 'affected_area.dart';
import 'package:miecal/table_calendar.dart';
import 'package:miecal/other_information.dart';

// ignore: avoid_web_libraries_in_flutter
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miecal/login_page.dart';
import 'package:miecal/firebase_options.dart';
import 'package:miecal/registar_page.dart';
import 'package:miecal/personal_information_page.dart';
import 'package:miecal/menu_page.dart';
// ignore: deprecated_member_use, unused_import, avoid_web_libraries_in_flutter
import 'dart:html' as html;  // Web向けの場合。モバイル向けなら削除またはPlatform.isWebで分岐
import 'package:miecal/l10n/app_localizations.dart';
import 'package:miecal/user_input_model.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserInputModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      title: 'MIECAL',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/',
      //home: const AuthGate(),
      routes: {
        '/': (context) => const TopPage(),
        '/LoginPage': (context) => const LoginScreen(),
        '/RegisterPage': (context) => const RegisterPage(),
         '/PersonalInformationPage': (context) => const PersonalInformationPage(),
        '/Menupage': (context) => const MenuPage(),
        '/SymptomPage': (context) => const SymptomPage(),
        '/AffectedAreaPage': (context) => const AffectedAreaPage(),
        '/DatePage': (context) => const DatePage(),
        '/SufferLevelPage': (context) => const SufferLevelPage(),
        '/CousePage': (context) => const CousePage(),
        '/OtherInformationPage': (context) => const OtherInformationPage(),
        '/QuestionnairePage': (context) {
          // Navigator.push で渡された arguments を取得
          // 想定される引数は Map<String, dynamic> です
          final Map<String, dynamic>? args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;

          return QuestionnairePage(
            selectedOnsetDay: args?['selectedOnsetDay'] as DateTime?, // 発症日
            symptom: args?['symptom'] as String?, // 症状
            affectedArea: args?['affectedArea'] as String?, // 患部
            sufferLevel: args?['sufferLevel'] as String?, // 程度
            cause: args?['cause'] as String?, // 原因
            otherInformation: args?['otherInformation'] as String?, // その他情報
          );
        },
        
      },
      // 必要に応じてテーマを設定
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        // その他のテーマ設定
      ),

      
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // 🔐ログイン済み → 次の画面へ
      return const SymptomPage(); // または MyHomePage
    } else {
      // 🔓未ログイン → ログイン画面へ
      return const LoginScreen();
    }
  }
}