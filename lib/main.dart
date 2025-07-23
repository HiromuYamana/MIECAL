import 'package:flutter/material.dart';
import 'package:miecal/couse.dart';

import 'package:miecal/questionnaire.dart';
import 'package:miecal/suffer_level.dart';
import 'package:miecal/symptom.dart';
import 'package:miecal/top_page.dart';
import 'affected_area.dart';
import 'package:miecal/table_calendar.dart';
import 'package:miecal/other_information.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miecal/login_page.dart';
import 'package:miecal/firebase_options.dart';
import 'package:miecal/registar_page.dart';
import 'package:miecal/personal_information_page.dart';
import 'package:miecal/menu_page.dart';
import 'package:miecal/l10n/app_localizations.dart';
import 'package:miecal/user_input_model.dart';
import 'package:provider/provider.dart';
import 'package:miecal/password_reset_page.dart';
import 'package:miecal/terms_of_service_page.dart';
import 'package:miecal/role_provider.dart';
import 'package:miecal/admin_approval_page.dart';
import 'package:miecal/doctor_application_page.dart';

// ↓ 追加: QuestionnaireDisplayPage をインポート
import 'package:miecal/questionnaire_display_page.dart';
// ↓ 追加: Web環境かどうかを判定するためのインポート
import 'package:flutter/foundation.dart' show kIsWeb;
// ↓ 追加: WebのURLを解析するためのインポート
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInputModel()),
        ChangeNotifierProvider(
          create: (_) {
            final p = RoleProvider();
            p.listenAuth(); // ← 自動で Auth 変化を監視したい場合
            return p;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _initialRecordId;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      final uri = Uri.parse(html.window.location.href);
      // ↓ ここを修正: パスセグメントからIDを抽出
      if (uri.pathSegments.length >= 2 &&
          uri.pathSegments[0] == 'questionnaire_records') {
        _initialRecordId = uri.pathSegments[1];
        print(
          'MainApp: Initial URL (Path Segment) Record ID: $_initialRecordId',
        );
      } else {
        print('MainApp: No valid questionnaire_records ID found in path.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      title: 'MIECAL',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
//      initialRoute: '/',
      routes: {
//        '/': (context) => const TopPage(),
        '/LoginPage': (context) => const LoginScreen(),
        '/RegisterPage': (context) => const RegisterPage(),
        '/PersonalInformationPage':
            (context) => const PersonalInformationPage(),
        '/Menupage': (context) {
          final Map<String, dynamic>? args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return MenuPage(
            userName: args?['userName'] as String?,
            userDateOfBirth: args?['userDateOfBirth'] as DateTime?, // 例: 生年月日
            userHome: args?['userHome'] as String?,
            userGender: args?['userGender'] as String?,
            userTelNum: args?['userTelNum'] as String?,
            selectedOnsetDay: args?['selectedOnsetDay'] as DateTime?, // 発症日
            symptom: args?['symptom'] as String?, // 症状
            affectedArea: args?['affectedArea'] as String?, // 患部
            sufferLevel: args?['sufferLevel'] as String?, // 程度
            cause: args?['cause'] as String?, // 原因
            otherInformation: args?['otherInformation'] as String?, // その他情報
          );
        },
        '/SymptomPage': (context) {
          final Map<String, dynamic>? args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;

          return SymptomPage(
            userName: args?['userName'] as String?,
            userDateOfBirth: args?['userDateOfBirth'] as DateTime?,
            userHome: args?['userHome'] as String?,
            userGender: args?['userGender'] as String?,
            userTelNum: args?['userTelNum'] as String?,
            selectedOnsetDay: args?['selectedOnsetDay'] as DateTime?,
            symptom: args?['symptom'] as String?,
            affectedArea: args?['affectedArea'] as String?,
            sufferLevel: args?['sufferLevel'] as String?,
            cause: args?['cause'] as String?,
            otherInformation: args?['otherInformation'] as String?,
          );
        },
        '/AffectedAreaPage': (context) => const AffectedAreaPage(),
        '/DatePage': (context) => const DatePage(),
        '/SufferLevelPage': (context) => const SufferLevelPage(),
        '/CousePage': (context) => const CousePage(),
        '/OtherInformationPage': (context) => const OtherInformationPage(),
        '/PasswordResetPage': (context) => const PasswordResetPage(),
        '/DoctorApplication': (context) => const DoctorApplicationPage(),
        '/AdminApproval': (context) => const AdminApprovalPage(),
        '/TermsOfServicePage': (context) => const TermsOfServicePage(),
        '/QuestionnairePage': (context) {
          final Map<String, dynamic>? args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;

          return QuestionnairePage(
            userName: args?['userName'] as String?,
            userDateOfBirth: args?['userDateOfBirth'] as DateTime?, // 例: 生年月日
            userHome: args?['userHome'] as String?,
            userGender: args?['userGender'] as String?,
            userTelNum: args?['userTelNum'] as String?,
            selectedOnsetDay: args?['selectedOnsetDay'] as DateTime?, // 発症日
            symptom: args?['symptom'] as String?, // 症状
            affectedArea: args?['affectedArea'] as String?, // 患部
            sufferLevel: args?['sufferLevel'] as String?, // 程度
            cause: args?['cause'] as String?, // 原因
            otherInformation: args?['otherInformation'] as String?, // その他情報
          );
        },
      },
      home:
          _initialRecordId != null && _initialRecordId!.isNotEmpty
              ? QuestionnaireDisplayPage(
                questionnaireRecordId: _initialRecordId!,
              )
              : const TopPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
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
