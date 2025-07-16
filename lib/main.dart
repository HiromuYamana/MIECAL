// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // GoRouter をインポート
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
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:miecal/qr_scanner_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInputModel()),
        ChangeNotifierProvider(create: (_) {
          final p = RoleProvider();
          p.listenAuth();                       // ← 自動で Auth 変化を監視したい場合
          return p;
        }),
      ],
      child: const MyApp(),
    ),
  );
}

// GoRouter の定義
final GoRouter _router = GoRouter(
  initialLocation: '/', // アプリ起動時の最初のパス
  routes: [
    GoRoute(
      path: '/', // トップページ
      builder: (context, state) => const TopPage(),
    ),
    GoRoute(
      path: '/LoginPage', // ログインページ
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/RegisterPage', // 新規登録ページ
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/PersonalInformationPage', // プロフィール編集ページ
      builder: (context, state) => const PersonalInformationPage(),
    ),
    GoRoute(
      path: '/Menupage', // メニューページ
      builder: (context, state) {
        final Map<String, dynamic>? args = state.extra as Map<String, dynamic>?;
        return MenuPage(
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
    ),
    GoRoute(
      path: '/SymptomPage', // 症状選択ページ
      builder: (context, state) {
        final Map<String, dynamic>? args = state.extra as Map<String, dynamic>?;
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
    ),
    GoRoute(
      path: '/AffectedAreaPage', // 患部選択ページ
      builder: (context, state) {
        final Map<String, dynamic>? args = state.extra as Map<String, dynamic>?;
        return AffectedAreaPage(
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
    ),
    GoRoute(
      path: '/DatePage', // 発症日選択ページ
      builder: (context, state) {
        final Map<String, dynamic>? args = state.extra as Map<String, dynamic>?;
        return DatePage(
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
    ),
    GoRoute(
      path: '/SufferLevelPage', // 程度選択ページ
      builder: (context, state) {
        final Map<String, dynamic>? args = state.extra as Map<String, dynamic>?;
        return SufferLevelPage(
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
    ),
    GoRoute(
      path: '/CousePage', // 原因選択ページ
      builder: (context, state) {
        final Map<String, dynamic>? args = state.extra as Map<String, dynamic>?;
        return CousePage(
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
    ),
    GoRoute(
      path: '/OtherInformationPage', // その他情報入力ページ
      builder: (context, state) {
        final Map<String, dynamic>? args = state.extra as Map<String, dynamic>?;
        return OtherInformationPage(
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
    ),
    GoRoute(
      path: '/QuestionnairePage', // 問診票確認ページ (アプリ内フロー用)
      builder: (context, state) {
        final Map<String, dynamic>? args = state.extra as Map<String, dynamic>?;
        print(
          'main.dart: QuestionnairePage builder called. Received extra: $args',
        );
        return QuestionnairePage(
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
          isFromQrScanner: false, // アプリ内フローなのでfalse
        );
      },
    ),
    // IDベースの問診票表示ルート（QRコードスキャン用）
    GoRoute(
      path: '/questionnaire_records/:id', // パスパラメータとしてIDを受け取る
      builder: (context, state) {
        final String? recordId =
            state.pathParameters['id']; // pathParameters からIDを取得
        return QuestionnairePage(
          questionnaireRecordId: recordId, // IDを渡す
          isFromQrScanner: true, // 外部からのアクセスなので常にtrue
          // 他のデータはIDでロードするため、ここでは渡さない
        );
      },
    ),
  ],
  // 認証状態に応じてリダイレクトする
  redirect: (context, state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool loggingIn = state.matchedLocation == '/LoginPage';
    final bool registering = state.matchedLocation == '/RegisterPage';
    final bool personalInfo =
        state.matchedLocation == '/PersonalInformationPage';

    // QRコードからのディープリンクで問診票レコードに直接アクセスする場合
    // この場合、認証がなくても表示を許可する（Firestoreルールでpublic read可能なら）
    final bool isViewingQrQuestionnaire = state.matchedLocation.startsWith(
      '/questionnaire_records/',
    );

    // ログインしていないのに保護されたルートに行こうとしている場合
    // QRからの問診票は認証を必須としない（Firestoreルールによる）
    if (!loggedIn &&
        !loggingIn &&
        !registering &&
        !personalInfo &&
        !isViewingQrQuestionnaire) {
      return '/LoginPage'; // ログインページへリダイレクト
    }

    // ログインしているのにログイン/登録ページに行こうとしている場合
    if (loggedIn && (loggingIn || registering)) {
      return '/Menupage'; // メニューページへリダイレクト
    }

    // デフォルトのリダイレクトがない場合
    return null;
  },
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(child: Text('エラー: ページが見つかりません ${state.error}')),
      ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // MaterialApp.router を使用
      locale: const Locale('en'),
      title: 'MIECAL',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router, // GoRouter のインスタンスを設定
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
    );
  }
}
