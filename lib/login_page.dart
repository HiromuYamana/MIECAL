import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- この行を追加
import 'package:miecal/main.dart'; // main.dart にルーティングがある場合、必要
import 'package:miecal/menu_page.dart'; // ログイン後の遷移先（今回は問診票に直接遷移）
import 'package:miecal/personal_info_service.dart'; // <-- この行を追加 (PersonalInfoServiceがあるファイル)
import 'package:google_fonts/google_fonts.dart';
import 'package:miecal/l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  // 🔵 Googleログイン処理
Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

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
        await showDialog(
          context: context,
          builder: (context) {
            final emailCtrl = TextEditingController(text: user.email ?? '');
            final passCtrl = TextEditingController();

            return AlertDialog(
              title: const Text('パスワードを追加しますか？'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'メールアドレス'),
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
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('メール+パスワードを追加しました')),
                      );
                    } on FirebaseAuthException catch (e) {
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

      // 🔵 Firestore のデータ確認
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final initialQuestionnaireData = {
          'userName': userData['name'] as String?,
          'selectedOnsetDay': userData['onsetDay'] != null
              ? DateTime.tryParse(userData['onsetDay'])
              : null,
          'symptom': userData['symptom'] as String?,
          'affectedArea': userData['affectedArea'] as String?,
          'sufferLevel': userData['sufferLevel'] as String?,
          'cause': userData['cause'] as String?,
          'otherInformation': userData['otherInformation'] as String?,
        };

        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/Menupage',
          arguments: initialQuestionnaireData,
        );
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/PersonalInformationPage',
          arguments: {'isNewUser': true},
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ユーザーデータがありません。個人情報を登録してください。')),
        );
      }
    }
  } catch (e) {
    print('Googleログイン失敗: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Googleログインに失敗しました: $e')),
    );
  }
}

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

  String getLocalizedAuthError(String code, AppLocalizations loc) {
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

  try {
    final UserCredential userCredential = 
    await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final User? user = userCredential.user;

    if (user != null) {
      // 🔐 ログイン成功時
      // Firestoreからユーザーに紐付く個人情報と問診票情報を取得
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        // ドキュメントが存在すればデータを取得
        final Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        final Map<String, dynamic> initialQuestionnaireData = {
          'userName':userData['name'] as String?, // 氏名 (PersonalInfoService.saveUserInfo で保存したキー名)
          // 'userDateOfBirth': userData['dateOfBirth'] as String?, // 例: 生年月日
          // 問診票データ（Firestoreに保存済みのものがあれば）
          'selectedOnsetDay': userData['onsetDay'] != null ? DateTime.tryParse(userData['onsetDay']): null,
          'symptom': userData['symptom'] as String?,
          'affectedArea': userData['affectedArea'] as String?,
          'sufferLevel': userData['sufferLevel'] as String?,
          'cause': userData['cause'] as String?,
          'otherInformation': userData['otherInformation'] as String?,
          // ... 他の問診票項目もここに追加 ...
        };

          if (!mounted) return;
          Navigator.pushReplacementNamed(
            context,
            '/Menupage',
            arguments: initialQuestionnaireData,
          );
        } else {
          if (!mounted) return;
          Navigator.pushReplacementNamed(
            context,
            '/PersonalInformationPage',
            arguments: {'isNewUser': true},
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ユーザーデータがありません。個人情報を登録してください。')),
          );
        }
      } else {
        setState(() {
          errorMessage = 'ユーザー情報が取得できませんでした';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'ログインに失敗しました';
      });
    } catch (e) {
      setState(() {
        errorMessage = '予期せぬエラーが発生しました: ${e.toString()}';
      });
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
      backgroundColor: const Color.fromARGB(255, 218, 246, 250),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'MIECAL',
                style: GoogleFonts.montserrat(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
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
                    backgroundColor: const Color(0xFFF44336),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Sign in'),
                ),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/PasswordResetPage');
                },
                child: const Text('パスワードを忘れた場合'),
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
                  const Text("Don’t have an account?"),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/RegisterPage');
                    },
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                    label: const Text('Sign up'),
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

