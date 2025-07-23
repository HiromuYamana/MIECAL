import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miecal/l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String errorMessage = '';
  bool isLoading = false;

  Future<void> register() async {
  setState(() {
    isLoading = true;
    errorMessage = '';
  });

  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final confirm = confirmPasswordController.text.trim();
    final loc = AppLocalizations.of(context)!;

  if (password != confirm) {
    setState(() {
      errorMessage = loc.authWrongPassword;
      isLoading = false;
    });
    return;
  }

  if (password.length < 6) {
    setState(() {
      errorMessage = loc.authShortPassword;
      isLoading = false;
    });
    return;
  }

  try {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'role': 'patient',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    if (!mounted) return;

    // 新規登録成功後、個人情報入力ページへ遷移
    Navigator.pushReplacementNamed(context, '/PersonalInformationPage');
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message ?? loc.registerFailed;
    });
  } catch (e) {
    setState(() {
      errorMessage = loc.unknownError;
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  InputDecoration buildInputDecoration(String hint, Icon icon, bool isObscure, VoidCallback toggle) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon,
      suffixIcon: IconButton(
        icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
        onPressed: toggle,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  // Googleアカウントで新規登録 or ログイン
  Future<void> signInWithGoogle() async {
    final loc = AppLocalizations.of(context)!;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          final userDoc = await _firestore.collection('users').doc(user.uid).get();

          if (!userDoc.exists) {
            // Firestoreのユーザーデータがなければ初期化
            await _firestore.collection('users').doc(user.uid).set({
              'name': user.displayName ?? '',
              'email': user.email ?? '',
              'role': 'patient',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }

          if (!mounted) return;
          // Firestoreのデータ有無に関わらず個人情報ページに遷移
          Navigator.pushReplacementNamed(
            context,
            '/PersonalInformationPage',
            arguments: {'isNewUser': !userDoc.exists},
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          final email = e.email;
          // final pendingCredential = e.credential; // 今回は使わず

          if (email != null) {
            final List<String> signInMethods =
                await _auth.fetchSignInMethodsForEmail(email);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  loc.accountExistsWithMethods(signInMethods.join(', ')),
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${loc.googleLoginFailed}: ${e.message}')),
          );
        }
      }
    } catch (e) {
      debugPrint('${loc.registerFailed}$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${loc.googleLoginFailed}: $e')),
      );
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          "MIECAL",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255), // 白文字
            fontWeight: FontWeight.bold, // 太字
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 75, 170, 248),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Material(
              color: const Color.fromARGB(255, 207, 227, 230),
              child: InkWell(
                onTap:(){
                  Navigator.pop(context);
                },
                child: SizedBox(
                  child: Center(
                    child: const Icon(
                      Icons.expand_less,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Center(
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
                        loc.createNewAccount,
                        style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // E-mail
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: loc.email,
                          prefixIcon: const Icon(Icons.email_outlined),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: buildInputDecoration(
                          loc.password,
                          const Icon(Icons.lock_outline),
                          obscurePassword,
                          () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        decoration: buildInputDecoration(
                          loc.confirmPassword,
                          const Icon(Icons.lock_outline),
                          obscureConfirmPassword,
                          () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // エラーメッセージ
                      if (errorMessage.isNotEmpty)
                        Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),

                      const SizedBox(height: 20),

                      // Google登録ボタン
                      GestureDetector(
                        onTap: isLoading ? null : signInWithGoogle,
                        child: Image.asset(
                          'assets/images/login/google_light_new.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40), // 横の余白を追加
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : register, // ローディング中は無効化
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 18, 81, 241), // ボタンの色
                      foregroundColor: Colors.white, // テキストの色
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // 角丸
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10), // 上下の余白
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white, // ローディングの色
                          )
                        : const Text(
                            'Create', // ボタンのテキスト
                            style: TextStyle(fontSize: 20), // テキストサイズ
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}