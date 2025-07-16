import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miecal/menu_page.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:provider/provider.dart';
import 'package:miecal/user_input_model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:miecal/l10n/app_localizations.dart';

/// 画像のパス
const String _malePictPath   = 'assets/man_image.png';
const String _femalePictPath = 'assets/woman_image.png';

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

  final _nameController     = TextEditingController();
  final _addressController  = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneController    = TextEditingController();
  final _allergyController  = TextEditingController();
  final _surgeryController  = TextEditingController();

  int _selectedYear  = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  int _selectedDay   = DateTime.now().day;

  String? gender;          // '男性' または '女性'
  int?    age;
  bool    hadSurgery = false;

  bool   isLoading   = true;
  String errorMessage = '';

  /* ──────────── 性別オプションボタン ──────────── */

  Widget _genderOption({required bool isMale}) {
    final loc = AppLocalizations.of(context)!;
    final bool  selected = gender == (isMale ? loc.male : loc.female);
    const Color accent   = Colors.black;   // 黒で統一

    return InkWell(
      onTap: () => setState(() => gender = isMale ? loc.male : loc.female),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        height: 80,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? accent : Colors.grey.shade400,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(isMale ? _malePictPath : _femalePictPath),
            Positioned(
              bottom: 4,
              right: 4,
              child: Icon(
                isMale ? Icons.male : Icons.female,
                size: 22,
                color: selected ? accent : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _genderOption(isMale: true),
          const SizedBox(width: 24),
          _genderOption(isMale: false),
        ],
      );

  /* ──────────── 年齢計算 ──────────── */

  int? _calculateAge(String d) {
    try {
      final bd  = DateTime.parse(d);
      final now = DateTime.now();
      int y = now.year - bd.year;
      if (now.month < bd.month || (now.month == bd.month && now.day < bd.day)) {
        y--;
      }
      return y;
    } catch (_) {
      return null;
    }
  }

  void _updateAgeFromSelectors() {
    setState(() {
      final d =
          '$_selectedYear-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}';
      age = _calculateAge(d);
    });
  }

  /* ──────────── 初期化 ──────────── */

  @override
  void initState() {
    super.initState();
    loadUserData().then((_) {
      if (_birthdayController.text.isNotEmpty) {
        final p = DateTime.tryParse(_birthdayController.text);
        if (p != null) {
          _selectedYear  = p.year;
          _selectedMonth = p.month;
          _selectedDay   = p.day;
        }
      }
      _updateAgeFromSelectors();
    });
  }
   /* ──────────── Firestore から読み込み ──────────── */

  Future<void> loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'ログインしてください';
          isLoading    = false;
        });
        return;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final d = doc.data()!;
        _nameController.text     = d['name']     ?? '';
        _addressController.text  = d['address']  ?? '';
        _birthdayController.text = d['birthday'] ?? '';
        _phoneController.text    = d['phone']    ?? '';
        _allergyController.text  = d['allergy']  ?? '';
        gender                   = d['gender'];
        hadSurgery               = d['surgery'] ?? false;
      }
    } catch (e) {
      errorMessage = '読み込みエラー: $e';
    } finally {
      setState(() => isLoading = false);
    }
  }

  /* ──────────── Firestore へ保存 ──────────── */

  Future<void> saveUserData() async {
    setState(() {
      isLoading   = true;
      errorMessage = '';
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'ログインしてください';
          isLoading    = false;
        });
        return;
      }

      final birthday =
          '${_selectedYear.toString().padLeft(4, '0')}-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}';
      final DateTime? parsedBirthday = DateTime.tryParse(birthday);
      age = _calculateAge(birthday);

      final input = Provider.of<UserInputModel>(context, listen: false);
      input.updatePersonal(
        name           : _nameController.text.trim(),
        address        : _addressController.text.trim(),
        birthday       : birthday,
        age            : age?.toString() ?? '',
        gender         : gender ?? '',
        phoneNumber    : _phoneController.text.trim(),
        allergy        : _allergyController.text.trim(),
        surgeryHistory : hadSurgery ? 'あり' : 'なし',
      );

      await _firestore.collection('users').doc(user.uid).set({
        'name'     : input.name,
        'address'  : input.address,
        'birthday' : input.birthday,
        'age'      : input.age,
        'gender'   : input.gender,
        'phone'    : input.phoneNumber,
        'allergy'  : input.allergy,
        'surgery'  : input.surgeryHistory == 'あり',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      setState(() => isLoading = false);

      Navigator.pushReplacement(
        context,
        VerticalSlideRoute(
          page: MenuPage(
            userName        : _nameController.text.trim(),
            userDateOfBirth : parsedBirthday,
            userHome        : _addressController.text.trim(),
            userGender      : gender,
            userTelNum      : _phoneController.text.trim(),
            selectedOnsetDay: widget.selectedOnsetDay,
            symptom         : widget.symptom,
            affectedArea    : widget.affectedArea,
            sufferLevel     : widget.sufferLevel,
            cause           : widget.cause,
            otherInformation: widget.otherInformation,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = '保存に失敗しました: $e';
        isLoading    = false;
      });
    }
  }

  /* ──────────── dispose ──────────── */

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _allergyController.dispose();
    _surgeryController.dispose();
    super.dispose();
  }

  /* ──────────── UI ──────────── */

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MIECAL",
          style: TextStyle(
            color: Colors.white,        // 白文字
            fontWeight: FontWeight.bold, // 太字
            fontSize: 24,
          ),
        ),
        centerTitle: true, 
        backgroundColor: const Color.fromARGB(255, 75, 170, 248),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Material(
              color: const Color.fromARGB(255, 207, 227, 230),
              //padding: EdgeInsets.only(top: topPadding),
              child: InkWell(
                onTap:(){
                  Navigator.pop(context);
                },
                child: SizedBox(
                  child: Center(
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),                 
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child:Container( 
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Center(
                child: Text(loc.profileEdit, style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
              )
            ),
          ),
          Expanded(
            flex: 16,
            child: Container(
              color: Colors.white, // 背景色を白に設定
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (errorMessage.isNotEmpty)
                      Text(errorMessage, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),

                    _buildIconTextField(Icons.person, _nameController, labelText: loc.name),
                    _buildIconTextField(Icons.home, _addressController, labelText: loc.address),

                    _buildBirthdayPickers(context),

                    if (age != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          loc.ageLabel(age.toString()),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),


                    const SizedBox(height: 12),
                    _buildGenderSelector(),
                    _buildIconTextField(Icons.phone, _phoneController,
                        keyboardType: TextInputType.phone, labelText: loc.phone),
                    _buildIconTextField(Icons.warning, _allergyController,
                        labelText: loc.allergy),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_hospital),
                            const SizedBox(width: 10),
                            Text(loc.surgicalHistory, style: TextStyle(fontSize: 16)),
                            const Spacer(),
                            Text(loc.yes),
                            Switch(
                              value: hadSurgery,
                              onChanged: (v) => setState(() => hadSurgery = v),
                            ),
                            Text(loc.no),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: saveUserData,
                        icon: const Icon(Icons.save, size: 24),
                        label: Text( loc.save, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor:
                        Colors.blue, 
                        foregroundColor: Colors.white, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ──────────── 補助 Widget ──────────── */

  Widget _buildBirthdayPickers(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.birthdate,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Text(loc.year, style: TextStyle(fontSize: 12, color: Colors.grey)),
                      NumberPicker(
                        value: _selectedYear,
                        minValue: DateTime.now().year - 120,
                        maxValue: DateTime.now().year,
                        itemHeight: 30,
                        axis: Axis.vertical,
                        onChanged: (v) {
                          setState(() {
                            _selectedYear = v;
                            _updateAgeFromSelectors();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Text(loc.month, style: TextStyle(fontSize: 12, color: Colors.grey)),
                      NumberPicker(
                        value: _selectedMonth,
                        minValue: 1,
                        maxValue: 12,
                        itemHeight: 30,
                        axis: Axis.vertical,
                        onChanged: (v) {
                          setState(() {
                            _selectedMonth = v;
                            _updateAgeFromSelectors();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Text(loc.day, style: TextStyle(fontSize: 12, color: Colors.grey)),
                      NumberPicker(
                        value: _selectedDay,
                        minValue: 1,
                        maxValue: 31,
                        itemHeight: 30,
                        axis: Axis.vertical,
                        onChanged: (v) {
                          setState(() {
                            _selectedDay = v;
                            _updateAgeFromSelectors();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconTextField(
    IconData icon,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    String? labelText,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      );
}
