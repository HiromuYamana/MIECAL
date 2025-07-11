import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestoreを使用するためにインポート
import 'package:miecal/main.dart'; // main.dartにルーティングがある場合、必要
import 'package:miecal/menu_page.dart'; // ログイン後の遷移先（今回はMenuPageに直接遷移）
import 'package:miecal/personal_info_service.dart'; // PersonalInfoServiceがあるファイル

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestoreインスタンス

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  bool _obscurePassword = true; // パスワードの表示/非表示を切り替えるためのフラグ

  Future<void> signIn() async {
    setState(() {
      isLoading = true; // ローディング開始
      errorMessage = ''; // エラーメッセージをクリア
    });

    try {
      // メールとパスワードでサインインを試みる
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final User? user = userCredential.user; // ログインしたユーザー情報を取得

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
          // MenuPageのコンストラクタ引数に合わせてキーと型を調整
          final Map<String, dynamic> initialQuestionnaireData = {
            'userName': userData['name'] as String?, // 氏名
            // 修正点: 'birthday'はFirestoreにStringで保存されているため、DateTime.tryParseで変換
            'userDateOfBirth':
                userData['birthday'] != null
                    ? DateTime.tryParse(userData['birthday'] as String)
                    : null, // 生年月日
            'userHome': userData['address'] as String?, // 住所
            'userGender': userData['gender'] as String?, // 性別
            'userTelNum': userData['phone'] as String?, // 電話番号
            // 問診票データ（Firestoreに保存済みのものがあれば）
            'selectedOnsetDay':
                userData['onsetDay'] != null
                    ? DateTime.tryParse(userData['onsetDay'] as String)
                    : null, // 発症日
            'symptom': userData['symptom'] as String?, // 症状
            'affectedArea': userData['affectedArea'] as String?, // 患部
            'sufferLevel': userData['sufferLevel'] as String?, // 程度
            'cause': userData['cause'] as String?, // 原因
            'otherInformation':
                userData['otherInformation'] as String?, // その他情報
            // ... 他の問診票項目もここに追加 ...
          };

          if (!mounted) return; // ウィジェットがまだマウントされているか確認
          // ログイン成功時にMenuPageへ直接遷移し、取得したデータを引数として渡す
          Navigator.pushReplacementNamed(
            context,
            '/Menupage', // MenuPageへのルート
            arguments: initialQuestionnaireData, // 取得したデータを引数として渡す
          );
        } else {
          // ドキュメントが存在しない場合（新規登録後に個人情報が保存されていないケース）
          if (!mounted) return;
          // PersonalInformationPageに強制遷移し、個人情報を入力・保存させる
          Navigator.pushReplacementNamed(
            context,
            '/PersonalInformationPage',
            arguments: {
              'isNewUser': true,
            }, // PersonalInformationPageで新規ユーザーであることを示す
          );

          // ユーザーにデータがないことをSnackBarで通知
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
      // Firebase認証に関するエラーをキャッチ
      setState(() {
        errorMessage = e.message ?? 'ログインに失敗しました'; // エラーメッセージを表示
      });
    } catch (e) {
      // その他の予期せぬエラーをキャッチ
      setState(() {
        errorMessage = '予期せぬエラーが発生しました: ${e.toString()}'; // エラーメッセージを表示
      });
    } finally {
      setState(() {
        isLoading = false; // ローディング終了
      });
    }
  }

  @override
  void dispose() {
    // TextEditingControllerを破棄してリソースを解放
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 246, 250), // 薄いブルー系の背景色
      body: Center(
        child: SingleChildScrollView(
          // コンテンツが画面を超えた場合にスクロール可能にする
          padding: const EdgeInsets.symmetric(horizontal: 32), // 左右のパディング
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // コンテンツを中央に配置
            children: [
              const Text(
                'MIECAL',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0), // 濃い青色のテキスト
                ),
              ),
              const SizedBox(height: 40),

              // メールアドレス入力フィールド
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'e-mail',
                  prefixIcon: const Icon(Icons.email_outlined),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // 角丸のボーダー
                  ),
                ),
                keyboardType: TextInputType.emailAddress, // メールアドレス用のキーボードタイプ
              ),
              const SizedBox(height: 20),

              // パスワード入力フィールド
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword, // パスワードを隠すかどうか
                decoration: InputDecoration(
                  hintText: 'password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    // パスワード表示/非表示切り替えアイコン
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                              .visibility_off // 非表示アイコン
                          : Icons.visibility, // 表示アイコン
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword; // フラグをトグル
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
                width: double.infinity, // 幅を親要素いっぱいに広げる
                child: ElevatedButton(
                  onPressed: isLoading ? null : signIn, // ローディング中はボタンを無効化
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      255,
                      93,
                      99,
                      230,
                    ), // ボタンの背景色
                    foregroundColor: Colors.white, // ボタンのテキスト色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // ボタンの角丸
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ), // ボタンのパディング
                  ),
                  child: const Text('Sign in'), // ボタンのテキスト
                ),
              ),
              const SizedBox(height: 30),

              // サインアップ誘導（アカウントがない場合）
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 中央に配置
                children: [
                  const Text("Don’t have an account?"),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/RegisterPage',
                      ); // 新規登録ページへの遷移
                    },
                    icon: const Icon(Icons.person_add_alt_1_outlined), // アイコン
                    label: const Text('Sign up'), // テキスト
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
