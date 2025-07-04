import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miecal/login_page.dart'; // ← ここはログインページのパスに合わせて修正してください
import 'package:miecal/main.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'ログインしてください';
          isLoading = false;
        });
        return;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _addressController.text = data['address'] ?? '';
        _birthdayController.text = data['birthday'] ?? '';
      } else {
        errorMessage = 'ユーザー情報は未登録です。';
      }
    } catch (e) {
      errorMessage = '読み込みエラー: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveUserData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'ログインしてください';
          isLoading = false;
        });
        return;
      }

      await _firestore.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'birthday': _birthdayController.text.trim(),
      });

      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存しました')),
      );

      // 保存後にログアウト
      await _auth.signOut();

      // ログインページへ遷移（履歴をクリア）
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        errorMessage = '保存に失敗しました: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール編集')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (errorMessage.isNotEmpty)
                    Text(errorMessage, style: const TextStyle(color: Colors.red)),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: '名前'),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: '住所'),
                  ),
                  TextField(
                    controller: _birthdayController,
                    decoration:
                        const InputDecoration(labelText: '生年月日 (例: 1990-01-01)'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveUserData,
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
    );
  }
}
