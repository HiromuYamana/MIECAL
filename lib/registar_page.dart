import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  String errorMessage = '';
  bool isLoading = false;

  Future<void> register() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      // 新規登録成功後、個人情報入力ページへ遷移
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

  // Googleアカウントで新規登録 or ログイン
  Future<void> signInWithGoogle() async {
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
                  'このメールアドレスは${signInMethods.join(', ')}で登録済みです。別の方法でログインしてください。',
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Googleログインに失敗しました: ${e.message}')),
          );
        }
      }
    } catch (e) {
      debugPrint('Google登録失敗: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Googleログインに失敗しました: $e')),
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
    return Scaffold(
      appBar: AppBar(title: const Text('新規登録')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'メールアドレス'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    child: const Text('登録'),
                  ),
            const SizedBox(height: 24),

            // Google登録ボタン（画像そのままのサイズで）
            GestureDetector(
              onTap: isLoading ? null : signInWithGoogle,
              child: Image.asset(
                'assets/google_light_new.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
