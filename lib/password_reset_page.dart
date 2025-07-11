import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String message = '';

  Future<void> sendResetEmail() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());

      setState(() {
        message = 'パスワードリセットメールを送信しました。メールを確認してください。';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message ?? 'メール送信に失敗しました。';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('パスワードリセット')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: '登録済みメールアドレス'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: message.startsWith('パスワードリセットメールを送信') ? Colors.green : Colors.red,
                ),
              ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: sendResetEmail,
                    child: const Text('リセットメールを送信'),
                  ),
          ],
        ),
      ),
    );
  }
}
