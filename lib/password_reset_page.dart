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
      appBar: AppBar(
        title: const Text(
          "MIECAL",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 75, 170, 248),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // ← 上の戻るボタン
          SizedBox(
            height: 60,
            child: Material(
              color: const Color.fromARGB(255, 207, 227, 230),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Center(
                  child: Icon(
                    Icons.expand_less,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),

          // ↓ 真ん中の内容をExpandedで中央寄せ
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'パスワードリセット',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: '登録済みメールアドレス',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        if (message.isNotEmpty)
                          Text(
                            message,
                            style: TextStyle(
                              color: message.startsWith('パスワードリセット')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        const SizedBox(height: 20),
                        isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: sendResetEmail,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 75, 170, 248),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'リセットメールを送信',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                      ],
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
