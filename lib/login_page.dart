import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miecal/l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
// 以下はパスの解決のため必要に応じて追加または確認
import 'package:go_router/go_router.dart';
import 'package:miecal/menu_page.dart';
import 'package:miecal/personal_info_service.dart';
import 'package:miecal/registar_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;
  bool _obscurePassword = true;

  // 多言語化された認証エラーメッセージを取得するヘルパーメソッド
  String _getLocalizedAuthError(String code, AppLocalizations loc) {
    switch (code) {
      case 'user-not-found':
        return loc.authUserNotFound;
      case 'wrong-password':
        return loc.authWrongPassword;
      case 'invalid-email':
        return loc.authInvalidEmail;
      case 'user-disabled':
        return loc.authUserDisabled;
      default:
        return loc.authUnknownError;
    }
  }

  // 🔵 Googleログイン処理
  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return; // ユーザーがGoogleサインインをキャンセルした場合
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // 🔵 まだパスワードプロバイダとリンクされていなければ追加
        if (user.providerData.every((p) => p.providerId != 'password')) {
          if (!mounted) return;
          await showDialog(
            context: context,
            builder: (context) {
              final emailCtrl = TextEditingController(text: user.email ?? '');
              final passCtrl = TextEditingController();

              return AlertDialog(
                title: const Text('パスワードを追加しますか？'),
                content: Column(
                  mainAxisSize:
                      MainAxisSize.min, // <-- 修正点: MainAxisSize.min に変更
                  children: [
                    TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(labelText: 'メールアドレス'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: passCtrl,
                      decoration: const InputDecoration(labelText: 'パスワード'),
                      obscureText: true,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      try {
                        final email = emailCtrl.text.trim();
                        final password = passCtrl.text.trim();

                        final emailCred = EmailAuthProvider.credential(
                          email: email,
                          password: password,
                        );
                        await user.linkWithCredential(emailCred);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('メール+パスワードを追加しました')),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('リンク失敗: ${e.message}')),
                        );
                      }
                    },
                    child: const Text('追加'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('後で'),
                  ),
                ],
              );
            },
          );
        }

        // 🔵 Firestore のデータ確認（共通ロジック化）
        await _handleUserLoginSuccess(user); // 共通処理を呼び出し
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = _getLocalizedAuthError(
          e.code,
          AppLocalizations.of(context)!,
        );
      });
      print('Firebase Auth Error (Google): ${e.code} - ${e.message}');
    } catch (e) {
      setState(() {
        errorMessage = '予期せぬエラーが発生しました: ${e.toString()}';
      });
      print('Unexpected Error (Google): ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 共通のユーザーログイン成功後の処理
  Future<void> _handleUserLoginSuccess(User user) async {
    final DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      final Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;

      final Map<String, dynamic> initialQuestionnaireData = {
        'userName': userData['name'] as String?,
        'userDateOfBirth':
            userData['birthday'] != null
                ? DateTime.tryParse(userData['birthday'] as String)
                : null,
        'userHome': userData['address'] as String?,
        'userGender': userData['gender'] as String?,
        'userTelNum': userData['phone'] as String?,

        'selectedOnsetDay':
            userData['onsetDay'] != null
                ? DateTime.tryParse(userData['onsetDay'] as String)
                : null,
        'symptom': userData['symptom'] as String?,
        'affectedArea': userData['affectedArea'] as String?,
        'sufferLevel': userData['sufferLevel'] as String?,
        'cause': userData['cause'] as String?,
        'otherInformation': userData['otherInformation'] as String?,
      };

      if (!mounted) return;
      // ログイン成功時にMenuPageへ遷移し、データを渡す (GoRouter 形式)
      context.go('/Menupage', extra: initialQuestionnaireData);
    } else {
      if (!mounted) return;
      // PersonalInformationPageに強制遷移し、個人情報を入力・保存させる (GoRouter 形式)
      context.go('/PersonalInformationPage', extra: {'isNewUser': true});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ユーザーデータがありません。個人情報を登録してください。')),
      );
    }
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final User? user = userCredential.user;

      if (user != null) {
        await _handleUserLoginSuccess(user); // 共通処理を呼び出し
      } else {
        setState(() {
          errorMessage = 'ユーザー情報が取得できませんでした';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = _getLocalizedAuthError(
          e.code,
          AppLocalizations.of(context)!,
        );
      });
      print('Firebase Auth Error (Email): ${e.code} - ${e.message}');
    } catch (e) {
      setState(() {
        errorMessage = '予期せぬエラーが発生しました: ${e.toString()}';
      });
      print('Unexpected Error (Email): ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 246, 250), // 薄いブルー系背景
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LOGIN',
                style: GoogleFonts.montserrat(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 40),

              // メール入力
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: loc.eMail,
                  prefixIcon: const Icon(Icons.email_outlined),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // パスワード入力
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: loc.passWord,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 通常ログインボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 18, 81, 241),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(loc.signIn),
                ),
              ),
              const SizedBox(height: 16),

              // パスワードリセット誘導
              TextButton(
                onPressed: () {
                  context.push('/PasswordResetPage'); // GoRouter 形式に修正
                },
                child: Text(loc.forgetPassword),
              ),

              // Googleログイン画像ボタン
              GestureDetector(
                onTap: isLoading ? null : signInWithGoogle,
                child: Image.asset(
                  'assets/ios_light_google.png',
                  fit: BoxFit.contain,
                ),
              ),

              // 新規登録案内
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loc.dontHaveAccount),
                  TextButton.icon(
                    onPressed: () {
                      context.push('/RegisterPage'); // GoRouter 形式に修正
                    },
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                    label: Text(loc.createNewAccount),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
