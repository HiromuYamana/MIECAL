import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miecal/menu_page.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:provider/provider.dart';
import 'package:miecal/user_input_model.dart';
import 'package:numberpicker/numberpicker.dart';

class PersonalInformationPage extends StatefulWidget {
  final String? userName;
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea;
  final String? sufferLevel;
  final String? cause;
  final String? otherInformation;

  const PersonalInformationPage({
    super.key,
    this.userName,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea,
    this.sufferLevel,
    this.cause,
    this.otherInformation,
  });

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  // 修正点: _birthdayController を一つに戻す
  final _birthdayController = TextEditingController(); // YYYY-MM-DD 形式の文字列を保持
  final _phoneController = TextEditingController();
  final _allergyController = TextEditingController();
  final _surgeryController = TextEditingController();

  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  int _selectedDay = DateTime.now().day;

  String? gender;
  int? age;
  bool hadSurgery = false;

  bool isLoading = true;
  String errorMessage = '';
  String? profileImageUrl;

  int? _calculateAge(String dateString) {
    try {
      final birthDate = DateTime.parse(dateString); // 文字列からDateTimeに変換
      final today = DateTime.now();
      int calculatedAge = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        calculatedAge--;
      }
      return calculatedAge;
    } catch (_) {
      return null;
    }
  }

  void _updateAgeFromSelectors() {
    setState(() {
      try {
        if (_selectedYear != 0 && _selectedMonth != 0 && _selectedDay != 0) {
          String fullDate =
              '$_selectedYear-${_selectedMonth.toString().padLeft(2, '0')}-'
              '${_selectedDay.toString().padLeft(2, '0')}';
          age = _calculateAge(fullDate);
        } else {
          age = null;
        }
      } catch (_) {
        age = null; // 無効な日付の場合は年齢をクリア
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData().then((_) {
      // ユーザーデータ読み込み後、生年月日が設定されていれば各セレクターの初期値を更新
      if (_birthdayController.text.isNotEmpty) {
        try {
          final parsedDate = DateTime.parse(_birthdayController.text);
          _selectedYear = parsedDate.year;
          _selectedMonth = parsedDate.month;
          _selectedDay = parsedDate.day;
        } catch (_) {
          // パース失敗時は現在の年月日を使用
        }
      }
      // 初期年齢の計算
      _updateAgeFromSelectors();
    });
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
        _birthdayController.text = data['birthday'] ?? ''; // Firestoreから直接読み込み
        _phoneController.text = data['phone'] ?? '';
        _allergyController.text = data['allergy'] ?? '';
        gender = data['gender'];
        hadSurgery = data['surgery'] ?? false;

        // 年齢自動計算
        String? birthdayString = data['birthday'];
        if (birthdayString != null && birthdayString.isNotEmpty) {
          try {
            final parsedDate = DateTime.parse(birthdayString);
            _selectedYear = parsedDate.year;
            _selectedMonth = parsedDate.month;
            _selectedDay = parsedDate.day;
            age = _calculateAge(birthdayString); // 新しい年齢計算ロジックを呼び出し
          } catch (_) {
            //errorMessage = '読み込みエラー: $e';
          }
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

      String birthdayString = '';
      DateTime? parsedBirthday;

      if (_selectedYear != 0 && _selectedMonth != 0 && _selectedDay != 0) {
        try {
          birthdayString =
              '${_selectedYear.toString().padLeft(4, '0')}-'
              '${_selectedMonth.toString().padLeft(2, '0')}-'
              '${_selectedDay.toString().padLeft(2, '0')}';
          parsedBirthday = DateTime.tryParse(birthdayString);
        } catch (e) {
          errorMessage = '生年月日が不正です: ${e.toString()}';
          isLoading = false;
          return;
        }
      }

      // 年齢の再計算 (保存時)
      if (parsedBirthday != null) {
        age = _calculateAge(birthdayString);
      } else {
        age = null;
      }

      final inputModel = Provider.of<UserInputModel>(context, listen: false);
      inputModel.updatePersonal(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        birthday: birthdayString, // 結合した日付文字列を渡す
        age: age?.toString() ?? '',
        gender: gender ?? '',
        phoneNumber: _phoneController.text.trim(),
        allergy: _allergyController.text.trim(),
        surgeryHistory: hadSurgery ? 'あり' : 'なし',
      );

      await _firestore.collection('users').doc(user.uid).set({
        'name': inputModel.name,
        'address': inputModel.address,
        'birthday': inputModel.birthday, // 結合した日付文字列をFirestoreに保存
        'age': inputModel.age,
        'gender': inputModel.gender,
        'phone': inputModel.phoneNumber,
        'allergy': inputModel.allergy,
        'surgery': inputModel.surgeryHistory == 'あり',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      // MenuPageへ縦スライドで遷移し、問診票データもリレー
      final String? currentUserName = _nameController.text.trim();
      final DateTime? currentUserDateOfBirth = parsedBirthday;
      final String? currentUserHome = _addressController.text.trim();
      final String? currentUserGender = gender;
      final String? currentUserTelNum = _phoneController.text.trim();

      Navigator.pushReplacement(
        context,
        VerticalSlideRoute(
          page: MenuPage(
            userName: currentUserName,
            userDateOfBirth: currentUserDateOfBirth,
            userHome: currentUserHome,
            userGender: currentUserGender,
            userTelNum: currentUserTelNum,

            selectedOnsetDay: widget.selectedOnsetDay,
            symptom: widget.symptom,
            affectedArea: widget.affectedArea,
            sufferLevel: widget.sufferLevel,
            cause: widget.cause,
            otherInformation: widget.otherInformation,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = '保存に失敗しました: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    //_birthdayController.dispose(); // 修正点: 破棄するコントローラを一つに戻す
    _phoneController.dispose();
    _allergyController.dispose();
    _surgeryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: 16),

                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person, size: 40),
                    ),

                    const SizedBox(height: 16),

                    _buildIconTextField(
                      Icons.person,
                      _nameController,
                      labelText: '氏名',
                    ),
                    _buildIconTextField(
                      Icons.home,
                      _addressController,
                      labelText: '住所',
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  '年',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                NumberPicker(
                                  value: _selectedYear,
                                  minValue: DateTime.now().year - 120, // 過去120年
                                  maxValue: DateTime.now().year,
                                  step: 1,
                                  itemHeight: 30,
                                  axis: Axis.vertical,
                                  onChanged:
                                      (value) => setState(() {
                                        _selectedYear = value;
                                        _updateAgeFromSelectors(); // 年齢を更新
                                      }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  '月',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                NumberPicker(
                                  value: _selectedMonth,
                                  minValue: 1,
                                  maxValue: 12,
                                  step: 1,
                                  itemHeight: 30,
                                  axis: Axis.vertical,
                                  onChanged:
                                      (value) => setState(() {
                                        _selectedMonth = value;
                                        _updateAgeFromSelectors(); // 年齢を更新
                                      }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  '日',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                NumberPicker(
                                  value: _selectedDay,
                                  minValue: 1,
                                  maxValue: 31, // 月による日数の自動調整は後ほど
                                  step: 1,
                                  itemHeight: 30,
                                  axis: Axis.vertical,
                                  onChanged:
                                      (value) => setState(() {
                                        _selectedDay = value;
                                        _updateAgeFromSelectors(); // 年齢を更新
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 年齢表示 (変更なし)
                    if (age != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '年齢: $age 歳',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // 性別アイコン (変更なし)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.male,
                            size: 40,
                            color: gender == '男性' ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () => setState(() => gender = '男性'),
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          icon: Icon(
                            Icons.female,
                            size: 40,
                            color: gender == '女性' ? Colors.pink : Colors.grey,
                          ),
                          onPressed: () => setState(() => gender = '女性'),
                        ),
                      ],
                    ),

                    _buildIconTextField(
                      Icons.phone,
                      _phoneController,
                      keyboardType: TextInputType.phone,
                      labelText: '電話番号',
                    ),
                    _buildIconTextField(
                      Icons.warning,
                      _allergyController,
                      labelText: 'アレルギー',
                    ),

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
                      onPressed: () async {
                        await saveUserData();
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('保存'),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildIconTextField(
    IconData icon,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
