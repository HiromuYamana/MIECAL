import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miecal/menu_page.dart';
import 'package:provider/provider.dart';
import 'package:miecal/user_input_model.dart';

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
  final _phoneController = TextEditingController();
  final _allergyController = TextEditingController();
  final _surgeryController = TextEditingController();

  String? gender;
  int? age;
  bool hadSurgery = false;

  bool isLoading = true;
  String errorMessage = '';
  String? profileImageUrl;

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
        _phoneController.text = data['phone'] ?? '';
        _allergyController.text = data['allergy'] ?? '';
        gender = data['gender'];
        hadSurgery = data['surgery'] ?? false;

        if (_birthdayController.text.isNotEmpty) {
          age = _calculateAge(_birthdayController.text);
        }
      }
    } catch (e) {
      errorMessage = '読み込みエラー: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  int? _calculateAge(String dateString) {
    try {
      final birthDate = DateTime.parse(dateString);
      final today = DateTime.now();
      int calculatedAge = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        calculatedAge--;
      }
      return calculatedAge;
    } catch (_) {
      return null;
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

      final inputModel = Provider.of<UserInputModel>(context, listen: false);
      inputModel.updatePersonal(
        name: _nameController.text,
        address: _addressController.text,
        birthday: _birthdayController.text,
        age: age?.toString() ?? '',
        gender: gender ?? '',
        phoneNumber: _phoneController.text,
        allergy: _allergyController.text,
        surgeryHistory: hadSurgery ? 'あり' : 'なし',
      );

      await _firestore.collection('users').doc(user.uid).set({
        'name': inputModel.name,
        'address': inputModel.address,
        'birthday': inputModel.birthday,
        'age': inputModel.age,
        'gender': inputModel.gender,
        'phone': inputModel.phoneNumber,
        'allergy': inputModel.allergy,
        'surgery': inputModel.surgeryHistory == 'あり',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存しました')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MenuPage()),
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
    _phoneController.dispose();
    _allergyController.dispose();
    _surgeryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (errorMessage.isNotEmpty)
                    Text(errorMessage, style: const TextStyle(color: Colors.red)),

                  const SizedBox(height: 16),

                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.person, size: 40),
                  ),

                  const SizedBox(height: 16),

                  _buildIconTextField(Icons.person, _nameController),
                  _buildIconTextField(Icons.home, _addressController),

                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        String dateStr =
                            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                        setState(() {
                          _birthdayController.text = dateStr;
                          age = _calculateAge(dateStr);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: _buildIconTextField(Icons.calendar_today, _birthdayController),
                    ),
                  ),

                  if (age != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('年齢: $age 歳', style: const TextStyle(color: Colors.grey)),
                    ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.male,
                            size: 40,
                            color: gender == 'male' ? Colors.blue : Colors.grey),
                        onPressed: () => setState(() => gender = 'male'),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: Icon(Icons.female,
                            size: 40,
                            color: gender == 'female' ? Colors.pink : Colors.grey),
                        onPressed: () => setState(() => gender = 'female'),
                      ),
                    ],
                  ),

                  _buildIconTextField(Icons.phone, _phoneController, keyboardType: TextInputType.phone),
                  _buildIconTextField(Icons.warning, _allergyController),

                  Row(
                    children: [
                      const Icon(Icons.local_hospital),
                      const SizedBox(width: 10),
                      const Text('手術歴'),
                      const Spacer(),
                      Switch(
                        value: hadSurgery,
                        onChanged: (val) => setState(() => hadSurgery = val),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: saveUserData,
                    icon: const Icon(Icons.save),
                    label: const Text('保存'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildIconTextField(IconData icon, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
