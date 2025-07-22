import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorApplicationPage extends StatefulWidget {
  const DoctorApplicationPage({Key? key}) : super(key: key);

  @override
  _DoctorApplicationPageState createState() => _DoctorApplicationPageState();
}

class _DoctorApplicationPageState extends State<DoctorApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hospitalController = TextEditingController();

  bool _isSubmitting = false;
  String errorMessage = '';

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      errorMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'ログインしてください。';
          _isSubmitting = false;
        });
        return;
      }

      final uid = user.uid;

      await FirebaseFirestore.instance
          .collection('doctor_applications')
          .doc(uid)
          .set({
            'userId': uid,
            'name': _nameController.text.trim(),
            'hospital': _hospitalController.text.trim(),
            'status': 'pending',
            'timestamp': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('申請を送信しました。承認をお待ちください。')));

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorMessage = '申請送信中にエラーが発生しました。もう一度お試しください。';
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hospitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 246, 250),
      appBar: AppBar(
        title: Text('医師申請フォーム', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '医師申請',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),

                // 氏名
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: '氏名',
                    prefixIcon: const Icon(Icons.person_outline),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '氏名を入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 所属医療機関
                TextFormField(
                  controller: _hospitalController,
                  decoration: InputDecoration(
                    hintText: '所属医療機関',
                    prefixIcon: const Icon(Icons.local_hospital_outlined),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '所属医療機関を入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // エラーメッセージ表示
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                if (errorMessage.isNotEmpty) const SizedBox(height: 16),

                // 申請ボタン
                _isSubmitting
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                      onTap: _submitApplication,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.6),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_downward,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
