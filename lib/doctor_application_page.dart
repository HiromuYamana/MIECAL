import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DoctorApplicationPage extends StatefulWidget {
  const DoctorApplicationPage({Key? key}) : super(key: key);

  @override
  _DoctorApplicationPageState createState() => _DoctorApplicationPageState();
}

class _DoctorApplicationPageState extends State<DoctorApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _notesController = TextEditingController();

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

      await FirebaseFirestore.instance.collection('doctor_applications').doc(uid).set({
        'userId': uid,
        'name': _nameController.text.trim(),
        'hospital': _hospitalController.text.trim(),
        'licenseNumber': _licenseNumberController.text.trim(),
        'notes': _notesController.text.trim(),
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('申請を送信しました。承認をお待ちください。')),
      );

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
    _licenseNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hintText を入力してください';
        }
        return null;
      },
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
      automaticallyImplyLeading: true,
    ),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // 🔹 タイトル（カードの外）
            Text(
              '医師申請フォーム',
              style: GoogleFonts.notoSansJp(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),

            // 🔸 中央の白カードボックス（フォーム）
            Container(
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_nameController, '氏名', Icons.person_outline),
                    const SizedBox(height: 20),
                    _buildTextField(_hospitalController, '所属医療機関', FontAwesomeIcons.hospital,),
                    const SizedBox(height: 20),
                    _buildTextField(_licenseNumberController, '医師ライセンス番号', Icons.badge_outlined),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: '備考（任意）',
                        prefixIcon: const Icon(Icons.note_alt_outlined),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (errorMessage.isNotEmpty)
                      Text(errorMessage, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitApplication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 18, 81, 241),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('申請する'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
  );
}


}
