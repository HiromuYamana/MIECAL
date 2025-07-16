import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:miecal/l10n/app_localizations.dart';
import 'package:provider/provider.dart';           // ★ 追加
import 'package:miecal/role_provider.dart';        // ★ 追加
import 'package:miecal/firestore_service.dart';

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

  // ローカライズされたエラーを取得
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

  // Googleログイン
  Future<void> signInWithGoogle() async {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        setState(() {
          errorMessage = '${loc.googleLoginFailed}: user == null';
        });
        return;                               // 以降の処理を中断
      }


      await FirestoreService.instance.ensureUserDoc(user.uid, email: user.email! ?? '');


      if (user == null) return;

      // パスワード追加ダイアログ
      if (user.providerData.every((p) => p.providerId != 'password')) {
        await _showAddPasswordDialog(user, loc);
      }

      await _handleUserLogin(user, loc);

      context.read<RoleProvider>().fetchRole(user.uid);

    } catch (e) {
      setState(() {
        errorMessage = '${loc.googleLoginFailed}: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // メールログイン
Future<void> signIn() async {
  final loc = AppLocalizations.of(context)!;
  setState(() {
    isLoading = true;
    errorMessage = '';
  });

  try {
    // ① メール & パスワードでログイン
    final credential = await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // ② User を取得し null チェック
    final user = credential.user;
    if (user == null) {
      setState(() => errorMessage = loc.authUnknownError);
      return;
    }

    // ③ users/{uid} が無ければ role: patient で作成
    await FirestoreService.instance.ensureUserDoc(
      user.uid,
      email: user.email ?? '',
    );

    // ④ アプリ側のログイン後処理
    await _handleUserLogin(user, loc);

    // ⑤ RoleProvider を更新
    context.read<RoleProvider>().fetchRole(user.uid);
  } on FirebaseAuthException catch (e) {
    setState(() => errorMessage = getLocalizedAuthError(e.code, loc));
  } finally {
    setState(() => isLoading = false);
  }
}


  // Firestore情報取得
  Future<void> _handleUserLogin(User user, AppLocalizations loc) async {
    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      final args = {
        'userName': data['name'],
        'userDateOfBirth': DateTime.tryParse(data['birthday'] ?? ''),
        'userHome': data['address'],
        'userGender': data['gender'],
        'userTelNum': data['phone'],
        'selectedOnsetDay': DateTime.tryParse(data['onsetDay'] ?? ''),
        'symptom': data['symptom'],
        'affectedArea': data['affectedArea'],
        'sufferLevel': data['sufferLevel'],
        'cause': data['cause'],
        'otherInformation': data['otherInformation'],
      };

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/Menupage', arguments: args);
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        '/PersonalInformationPage',
        arguments: {'isNewUser': true},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.userDataNotFound)));
    }
  }

  // パスワード追加ダイアログ
  Future<void> _showAddPasswordDialog(User user, AppLocalizations loc) async {
    final emailCtrl = TextEditingController(text: user.email ?? '');
    final passCtrl = TextEditingController();

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(loc.addPassword),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(labelText: loc.email),
                ),
                TextField(
                  controller: passCtrl,
                  decoration: InputDecoration(labelText: loc.password),
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
                    final cred = EmailAuthProvider.credential(
                      email: email,
                      password: password,
                    );
                    await user.linkWithCredential(cred);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.addEmailAndPassword)),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${loc.linkFailed}: $e')),
                    );
                  }
                },
                child: Text(loc.add),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(loc.later),
              ),
            ],
          ),
    );
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          "MIECAL",
          style: TextStyle(
            color: Colors.white, // 白文字
            fontWeight: FontWeight.bold, // 太字
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 75, 170, 248),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                Text(
                  'LOGIN',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 50),

                // メールアドレス入力
                _buildTextField(
                  emailController,
                  loc.email,
                  Icons.email_outlined,
                ),
                const SizedBox(height: 20),

                // パスワード入力
                _buildPasswordField(loc),
                const SizedBox(height: 2),

                // パスワードを忘れた方リンク
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed:
                        () =>
                            Navigator.pushNamed(context, '/PasswordResetPage'),
                    child: Text('  ${loc.forgetPassword}'),
                  ),
                ),
                const SizedBox(height: 4),

                // ログインボタン
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
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(loc.signIn),
                  ),
                ),
                const SizedBox(height: 24),

                // Google ログインボタン
                GestureDetector(
                  onTap: isLoading ? null : signInWithGoogle,
                  child: Image.asset(
                    'assets/ios_light_google.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),

                // エラーメッセージ表示
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 16),
                const Divider(thickness: 1), // 区切り線
                const SizedBox(height: 8),

                // 新規登録リンク（アイコン付き）
                TextButton(
                  onPressed:
                      () => Navigator.pushNamed(context, '/RegisterPage'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.person_add_alt_1_outlined, size: 20),
                      SizedBox(width: 6),
                      Text('Create new account'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildPasswordField(AppLocalizations loc) {
    return TextField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: loc.password,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
