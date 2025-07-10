import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miecal/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // <-- この行を追加

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  bool _obscurePassword = true;

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
        // ログイン成功時に問診票ページへ直接遷移し、データを渡す
        Navigator.pushReplacementNamed(
          context,
          '/Menupage', // 問診票ページへのルート
          arguments: initialQuestionnaireData, // 取得したデータを引数として渡す
        );
        }
      else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/PersonalInformationPage',
          arguments: {'isNewUser': true},
        );
      }
    }
  } 
  on FirebaseAuthException catch (e) {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      errorMessage = getLocalizedAuthError(e.code, loc);
    });
  }
  finally {
    // 成功・失敗関係なくボタンを再び押せるようにする
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
                const Text(
                  'MIECAL',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0), // 濃い青
                  ),
                ),
                const SizedBox(height: 40),

                // メール
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

                // パスワード
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

                // ログインボタン
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF44336), // 赤系ボタン
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(loc.signIn),
                  ),
                ),
                const SizedBox(height: 30),

                // ここに追加 👇
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(loc.dontHaveAccount),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/RegisterPage');
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