import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- この行を追加
import 'package:miecal/main.dart'; // main.dart にルーティングがある場合、必要
import 'package:miecal/menu_page.dart'; // ログイン後の遷移先（今回は問診票に直接遷移）
import 'package:miecal/personal_info_service.dart'; // <-- この行を追加 (PersonalInfoServiceがあるファイル)

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

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final User? user = userCredential.user;

      if (user != null) {
        // 🔐 ログイン成功時
        // Firestoreからユーザーに紐付く個人情報と問診票情報を取得
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          // ドキュメントが存在すればデータを取得
          final Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          // 取得した個人情報と問診票情報をMapにまとめる
          // QuestionnairePage のコンストラクタ引数に合わせてキーを調整
          final Map<String, dynamic> initialQuestionnaireData = {
            'userName':
                userData['name']
                    as String?, // 氏名 (PersonalInfoService.saveUserInfo で保存したキー名)
            // 'userDateOfBirth': userData['dateOfBirth'] as String?, // 例: 生年月日

            // 問診票データ（Firestoreに保存済みのものがあれば）
            'selectedOnsetDay':
                userData['onsetDay'] != null
                    ? DateTime.tryParse(userData['onsetDay'])
                    : null,
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
        } else {
          // ドキュメントが存在しない場合（通常は新規登録後に個人情報が保存されるべき）
          // 新規登録を促すか、個人情報入力ページに遷移させる
          // ここでは、データがない場合は空の問診票ページに遷移する（または個人情報入力ページへ誘導）
          if (!mounted) return;
          // ユーザーデータが存在しない場合は、PersonalInformationPageに強制遷移する
          // PersonalInformationPageで個人情報を入力・保存させる
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
        // userがnullの場合（通常は発生しないが念のため）
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
                    hintText: 'e-mail',
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
                    hintText: 'password',
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
                    child: const Text('Sign in'),
                  ),
                ),
                const SizedBox(height: 30),

                // サインアップ誘導
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('ログイン')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'メールアドレス'),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: 'パスワード'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             if (errorMessage.isNotEmpty)
//               Text(errorMessage, style: const TextStyle(color: Colors.red)),
//             const SizedBox(height: 20),
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(onPressed: signIn, child: const Text('ログイン')),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/RegisterPage'); // 新規登録ページへの遷移
//               },
//               child: const Text('新規登録はこちら'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
