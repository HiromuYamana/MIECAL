import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

    if (password != confirm) {
      setState(() {
        errorMessage = 'パスワードが一致しません';
        isLoading = false;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        errorMessage = 'パスワードは6文字以上で入力してください';
        isLoading = false;
      });
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );

      if (!mounted) return;

      // 登録成功したら個人情報入力ページに遷移
      Navigator.pushReplacementNamed(context, '/PersonalInformationPage');

    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? '登録に失敗しました';
      });
    } catch (e) {
      setState(() {
        errorMessage = '予期せぬエラーが発生しました';
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                'Sign up',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),

              // e-mail
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'e-mail',
                  prefixIcon: const Icon(Icons.email_outlined),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // password
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: buildInputDecoration(
                  'password',
                  const Icon(Icons.lock_outline),
                  obscurePassword,
                  () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // confirm password
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: buildInputDecoration(
                  'password(確認用)',
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

              // 登録（矢印）ボタン
              isLoading
                  ? const CircularProgressIndicator()
                  : GestureDetector(
                      onTap: register,
                      child: const Icon(
                        Icons.arrow_downward,
                        size: 60,
                        color: Colors.black87,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
